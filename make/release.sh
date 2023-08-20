#!/bin/sh -eu

PROGNAME=release.sh
CHLOG=docs/CHANGELOG.md
CHLOG_TMP=.git/CHANGELOG.tmp.md
CHLOG_NEW=.git/CHANGELOG.new.md
CHLOG_DBG=.git/CHANGELOG.dbg.txt
EDITOR=${VISUAL:-${EDITOR:-vi}}
export TZ=UTC0


# Map commit type to version bump
#
# TYPE    - commit type
# NO      - used for sorting
# VERSION - version number to increase
#       <TYPE>    <NO> <VERSION>
MAP_TYPE_TO_VER=$(printf '/^\(revert: \)*%s\((.*)\)*: /i#1-VER-%s#\n' \
	'feat'      '2 MINOR' \
	'change'    '2 MINOR' \
	'deprecate' '2 MINOR' \
	'remove'    '2 MINOR' \
	'fix'       '3 PATCH' \
	'security'  '3 PATCH' \
	'perf'      '3 PATCH' \
)

# Map commit type to changelog section.
# Changes with impact on end users
#
# TYPE    - commit type
# NO      - used for sorting
# SECTION - changelog section
# PREFIX  - optional prefix to put before commit subject
#       <TYPE>            <NO> <SECTION>   <PREFIX>
MAP_TYPE_TO_CHANGELOG=$(printf 's|^%s\((.*)\)*!*: |#2-LOG-%s#%s|\n' \
	'security'          '1 Security'   ''         \
	'revert: security'  '1 Security'   'Revert: ' \
	'fix'               '2 Fixed'      ''         \
	'revert: fix'       '2 Fixed'      'Revert: ' \
	'remove'            '3 Removed'    ''         \
	'revert: remove'    '5 Added'      'Revert: ' \
	'deprecate'         '4 Deprecated' ''         \
	'revert: deprecate' '4 Deprecated' 'Revert: ' \
	'feat'              '5 Added'      ''         \
	'revert: feat'      '3 Removed'    'Revert: ' \
	'change'            '6 Changed'    ''         \
	'revert: change'    '6 Changed'    'Revert: ' \
	'perf'              '6 Changed'    ''         \
	'revert: perf'      '6 Changed'    'Revert: ' \
)

# Map commit type to commit message section.
# Changes relevant only to developers
#
# TYPE    - commit type
# NO      - used for sorting
# SECTION - changelog section
# PREFIX  - optional prefix to put before commit subject
#       <TYPE>           <NO> <SECTION>    <PREFIX>
MAP_TYPE_TO_COMMIT=$(printf 's|^%s\((.*)\)*!*: |#3-DEV-%s#%s|\n' \
	'test'             '1 Tests'       ''         \
	'revert: test'     '1 Tests'       'Revert: ' \
	'build'            '2 Build'       ''         \
	'revert: build'    '2 Build'       'Revert: ' \
	'ci'               '3 CI/CD'       ''         \
	'revert: ci'       '3 CI/CD'       'Revert: ' \
	'docs'             '4 Docs'        ''         \
	'revert: docs'     '4 Docs'        'Revert: ' \
	'merge'            '5 Merged'      ''         \
	'refactor'         '6 Maintenance' ''         \
	'revert: refactor' '6 Maintenance' 'Revert: ' \
	'style'            '6 Maintenance' ''         \
	'revert: style'    '6 Maintenance' 'Revert: ' \
	'deps'             '6 Maintenance' ''         \
	'revert: deps'     '6 Maintenance' 'Revert: ' \
	'chore'            '6 Maintenance' ''         \
	'revert: chore'    '6 Maintenance' 'Revert: ' \
)


error()
{
	printf '%s: %s\n' "${PROGNAME}" "$*" >&2
	exit 1
}

debug()
{
	if [ -n "${DEBUG-}" ]
	then
		tee -- "${1}"
	else
		cat
	fi
}

# Bump version in files: manpages, package.json, Cargo.toml, etc,
# and `git add` them here
bump()
{
	:
}

gen_chlog()
{
	ver=${1-}
	ref=${2:-HEAD}
	prev=$(git describe --abbrev=0 --first-parent --match='v*.*.*' \
		-- "${ref}~" 2>/dev/null || true)

	if [ -n "${ver}" ]
	then
		major=${ver}
		minor=${ver}
		patch=${ver}
	else
		tmp=${prev#v}
		major=${tmp%%.*}
		major=${major:-0}

		tmp=${tmp#*.}
		minor=${tmp%%.*}
		minor=${minor:-0}

		tmp=${tmp#*.}
		patch=${tmp%%-*}
		patch=${patch:-0}

		patch=${major}.${minor}.$(( patch + 1 ))
		minor=${major}.$(( minor + 1 )).0
		if [ "${major}" -gt 0 ]
		then
			major=$(( major + 1 )).0.0
		else
			major="${minor}"
		fi
	fi

	date=$(git show -s --format='%cd' \
		--date="format-local:%Y-%m-%d")

	# Assuming no commit subject starts with '#' character,
	# otherwise below sed script will not work correctly.
	git log --reverse --pretty='%s' "${prev}${prev:+..}${ref}" -- |
	sed '
		# Bump at least BUILD version number
		1i#1-VER-4 BUILD# <!-- NOBUMP -->

		# Separate development changes from user changes
		1i#3-DEV-0# <!-- EOF -->

		# Map commit type to version bump
		/^\(revert: \)*[a-z]*\((.*)\)*!: /  i#1-VER-1 MAJOR#
		'"${MAP_TYPE_TO_VER}"'

		# Remove double reverts
		s/^\(revert: revert: \)*//

		# Map commit type to changelog section.
		# Changes with impact on end users
		'"${MAP_TYPE_TO_CHANGELOG}"'

		# Map commit type to commit message section.
		# Changes relevant only to developers
		'"${MAP_TYPE_TO_COMMIT}"'

		# Mark unknown commit types
		/^#/!s/^/#3-DEV-99 Unknown#/
	' | sort -u | debug "${CHLOG_DBG}" | sed -n "
		# Print version
		1s/^#1-VER-1 MAJOR#/## ${major} (${date})/p
		1s/^#1-VER-2 MINOR#/## ${minor} (${date})/p
		1s/^#1-VER-3 PATCH#/## ${patch} (${date})/p
		1s/^#1-VER-4 BUILD#/## ${patch} (${date})/p
	"'
		# Extract changelog section
		s/^#[23]-[^ ]* .*#/&\n/
		# Save current section for later
		H; s/\n.*$//; x
		# Skip duplicated section
		s/^\([^\n]*\)\n\1/\n/

		# Print with section
		s/^[^\n]*\n#[^ ]* \(.*\)#\n/\n### \1\n\n- /p
		# Print without section
		s/^\n\n/- /p
		# Print comments
		s/^#[23]-.*#/\n/p
	'
}


if [ -z "${1-}" ] || [ "${1-}" = release ]
then
	# Generate changelog and edit it
	gen_chlog > "${CHLOG_TMP}"
	${EDITOR} "${CHLOG_TMP}"

	# Extract version from changelog
	version=$(sed 's/^## //; s/ .*$//; q' -- "${CHLOG_TMP}")
	date=$(sed 's/^## .* (//; s/).*$//; q' -- "${CHLOG_TMP}")
	if grep -q "^## ${version}" -- "${CHLOG}" 2>/dev/null
	then
		error "version '${version}' in changelog already"
	fi

	tag=$(git tag -l "v${version}")
	if [ -n "${tag}" ]
	then
		error "tag 'v${version}' already exists"
	fi

	# Bump version in files: manpages, package.json, Cargo.toml, etc
	bump "${version}" "${date}"

	# Prepend generated changes to changelog
	{
		printf 'Changelog\n=========\n\n\n'
		sed '/<!-- EOF -->/,$d' -- "${CHLOG_TMP}"
		if [ -r "${CHLOG}" ]
		then
			tail -n +4 -- "${CHLOG}"
		fi
	} > "${CHLOG_NEW}"
	mv -f -- "${CHLOG_NEW}" "${CHLOG}"
	git add -- "${CHLOG}"

	# Create release commit and tag
	sed '
		s/^## \([^ ]*\) .*$/release: \1/
		/^<!-- EOF -->$/,/^$/d
	' -- "${CHLOG_TMP}" | git commit -F -
	sed '
		s/^## \([^ ]*\) .*$/Release \1/
		/^<!-- EOF -->$/,/^$/d
	' -- "${CHLOG_TMP}" | git tag -aF - "v${version}"
elif [ "${1-}" = changelog ] && [ "${2-}" = - ]
then
	printf 'Changelog\n=========\n\n\n'
	gen_chlog 'Unreleased'
elif [ "${1-}" = changelog ] && [ -n "${2-}" ]
then
	printf 'Changelog\n=========\n\n\n'
	gen_chlog "${2#v}" "${2}"
elif [ "${1-}" = changelog ]
then
	printf 'Changelog\n=========\n\n\n'
	gen_chlog 'Unreleased'
	for tag in $(git tag -l --sort=-v:refname 'v*.*.*')
	do
		printf '\n\n'
		gen_chlog "${tag#v}" "${tag}"
	done
elif [ "${1-}" = version ]
then
	gen_chlog '' "${2-}" | sed 's/^## //; q'
else
	printf "${PROGNAME} %s\\n    %s\\n\\n" \
	'[release]' 'Create new release' \
	'changelog' 'Print full changelog' \
	'version [REF]' 'Print proposed version for REF' \
	'help' 'Print help' >&2
fi
