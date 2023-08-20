#!/bin/sh -eu

REPO=${REPO:?}
SHA=${SHA:?}

is_untested()
{
	state=$(gh api "/repos/${REPO}/statuses/${1}" --paginate -q '
		map(select(.context == "check")) |
		sort_by(.updated_at).[-1].state')
	if [ "${state}" != success ] && [ "${state}" != failure ]
	then
		return 0
	fi

	state=$(gh api "/repos/${REPO}/statuses/${1}" --paginate -q '
		map(select(.context == "check-parents")) |
		sort_by(.updated_at).[-1].state')
	if [ "${state}" != success ] && [ "${state}" != failure ]
	then
		return 0
	fi

	return 1
}

get_untested_commits()
{
	q=" ${1} "
	git rev-list --topo-order --parents "${1}" -- | {
	while IFS=' ' read -r commit parents
	do
		# If commit in queue
		if [ -z "${q##* "${commit}" *}" ]
		then
			# Remove commit from queue
			q="${q% "${commit}" *} ${q#* "${commit}" }"
			if is_untested "${commit}"
			then
				q="${q}${parents} "
				commits="${commit} ${commits-}"
			fi
		fi
	done
	printf '%s\n' "${commits-}"
	}
}

untested_commits=$(get_untested_commits "${SHA}")
for commit in ${untested_commits}
do
	printf 'Dispatch tests: %s (wait for: %s)\n' \
		"${commit}" "${wait_for-}"
	gh workflow run -R "${REPO}" 02.check.yml \
		-f sha="${commit}" \
		-f _wait_for="${wait_for-}"
	wait_for="${commit}"
	# Give GitHub time to pick up the workflow run
	sleep 10
done
