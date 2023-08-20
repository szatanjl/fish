#!/bin/sh -eu

REPO=${REPO:?}
RUN_URL=${RUN_URL:?}
SHA=${SHA:?}
NAME=${NAME:?}
DESCRIPTION=${DESCRIPTION:?}

get_state()
{
	gh api "/repos/${REPO}/statuses/${1}" --paginate -q "
		map(select(.context == \"${2}\")) |
		sort_by(.updated_at).[-1].state"
}

parents="$(git rev-list -n 1 --parents "${SHA}") "
parents=${parents#* }

state=0
for status_name
do
	for commit in ${parents}
	do
		value=$(get_state "${commit}" "${status_name}")
		printf 'Commit status %s: %s = %s\n' "${commit}" \
			"${status_name}" "${value}" >&2

		case ${value} in
			success) value=0 ;;
			failure) value=1 ;;
			*)       value=9 ;;
		esac

		if [ "${value}" -gt "${state}" ]
		then
			state=${value}
		fi
	done
done

case ${state} in
	0) state=success ;;
	1) state=failure ;;
	*) state=error ;;
esac

gh api -X POST "/repos/${REPO}/statuses/${SHA}" \
	-f target_url="${RUN_URL}" \
	-f context="${NAME}" \
	-f description="${DESCRIPTION} (${state})" \
	-f state="${state}" >&2

if [ "${state}" = success ] || [ "${state}" = failure ]
then
	cont=false
else
	cont=true
fi

printf '\nstatus=%s\ncontinue=%s\n' "${state}" "${cont}" >&2
printf 'status=%s\ncontinue=%s\n' "${state}" "${cont}"
