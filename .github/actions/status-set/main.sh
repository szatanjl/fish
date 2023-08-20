#!/bin/sh -eu

REPO=${REPO:?}
RUN_URL=${RUN_URL:?}
SHA=${SHA:?}
NAME=${NAME:?}
DESCRIPTION=${DESCRIPTION:?}
FORCE=${FORCE:-true}

if [ "${FORCE}" = false ]
then
	state=$(gh api "/repos/${REPO}/statuses/${SHA}" --paginate -q "
		map(select(.context == \"${NAME}\")) |
		sort_by(.updated_at).[-1].state")
fi

if [ "${state-}" = success ] || [ "${state-}" = failure ]
then
	cont=false
else
	cont=true
fi

printf '\nGET\nstatus=%s\ncontinue=%s\n' "${state-}" "${cont}" >&2

if [ "${cont}" = false ]
then
	printf 'status=%s\ncontinue=%s\n' "${state}" "${cont}"
	exit 0
fi

if [ "$#" -gt 0 ]
then
	state=0
	for value
	do
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
	case ${state} in
		0) state=success ;;
		1) state=failure ;;
		*) state=error ;;
	esac
else
	state=pending
fi

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

printf '\nSET\nstatus=%s\ncontinue=%s\n' "${state}" "${cont}" >&2
printf 'status=%s\ncontinue=%s\n' "${state}" "${cont}"
