Contributing
============

Interested in contributing?

Take a look at open issues and see if you can help there.
Focus on the ones labeled "help needed" or "good first issue".

Participate in discussions.

Submit a new [issue](#issues) or open a [pull request](#pull-requests).


Questions
---------

Before asking a question, check out [documentation](index.md) and issues
labeled "question".

Cannot find answer you are looking for?
[Submit an issue](#issues) or write an email to
<leszczak.jakub@gmail.com>.


Reporting Security Vulnerability
--------------------------------

If you discover a security issue, please bring it to our attention right
away.  **DO NOT** report security vulnerabilities through public issues,
discussions, or pull requests.
Send your report privately to <leszczak.jakub@gmail.com> instead.

See [security policy](SECURITY.md) for details.


Issues
------

Found a bug?  Have a feature request?  Got a question?
Fill out appropriate template and open an issue.

Before submitting an issue:

1. Try the latest version of software.  Bug may have already been fixed
2. Please search the issue tracker and open pull requests and make sure
   your problem has not been reported yet
3. Write detailed description of your problem and include steps required
   to reproduce the issue
4. Try to simplify the test case as much as possible to make it easier
   to confirm, reproduce, and find the root cause of the problem
5. Do not forget to remove sensitive data before posting.
   Replace it with "REDACTED"


Pull Requests
-------------

 1. Search open and unmerged Pull Requests (PR).  Do not duplicate work
 2. Fork repository
 3. Maintain [git discipline](git.md) and conform to our
    [style guides](styleguides.md)
 4. Run checks (formatters, linters, tests) and ensure they pass
 5. Keep documentation up to date
 6. Push changes to your branch
 7. Give PR short but descriptive title.  For example
    "Fix database connection", not "Fix bug #123"
 8. Reference any relevant issues in description and tag all users that
    should know about and/or review changes
 9. Do not submit "work in progress" PRs.  PR should only be submitted
    when it is ready for review
10. Open a PR
11. Ensure each commit successfully builds and passes all automatic CI
    checks.  Do not break `git bisect`


Pull Requests Review
--------------------

If there are fixes requested in review process:

1. Make required updates to the code
2. Most likely, do not add new commits on top, but update already
   existing ones instead.  Use `git rebase --interactive`
3. Rebase your changes on top of latest code
4. Rerun checks
5. Push changes to your branch and update the pull request.
   Do not be afraid of `git push --force`
6. Ensure each commit successfully builds and passes all automatic CI
   checks again
7. Respond to comments and mark them as "Resolved"


License
-------

By contributing to this project, you agree that your contributions will
be licensed under its [MIT license](../LICENSE).
