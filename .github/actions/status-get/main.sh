#!/bin/sh -eu

REPO=${REPO:?}
SHA=${SHA:?}

state=0

for name
do
	value=$(gh api "/repos/${REPO}/statuses/${SHA}" --paginate -q "
		map(select(.context == \"${name}\")) |
		sort_by(.updated_at).[-1].state")

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

if [ "${state}" = success ] || [ "${state}" = failure ]
then
	cont=false
else
	cont=true
fi

printf '\nstatus=%s\ncontinue=%s\n' "${state}" "${cont}" >&2
printf 'status=%s\ncontinue=%s\n' "${state}" "${cont}"
