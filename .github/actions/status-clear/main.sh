#!/bin/sh -eu

REPO=${REPO:?}
BEGIN=${BEGIN:?}
END=${END:?}
NAME=${NAME:?}

commits="$(git rev-list "${BEGIN}..${END}") ${BEGIN}"
for commit in ${commits}
do
	printf 'Clear status: %s\n' "${commit}"
	gh api -X POST "/repos/${REPO}/statuses/${commit}" \
		-f context="${NAME}" -f state=pending
done
