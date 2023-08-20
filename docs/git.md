Git Discipline
==============

- Follow [branch naming convention](#branch-naming)
- Follow [commit message convention](#commit-messages)
- Split changes into separate commits
- Do not mix different types of changes in the same commit
- Do not mix unrelated changes in the same branch/PR,
  like bug fixes and new features
- Squash fixes of bugs, typos, etc introduced in the same branch/PR
  during development
- In particular, during review process, do not add new commits,
  but consider updating already existing ones instead
- Reorder commits to form coherent story of evolving software
  instead of development process
- Use `git rebase` instead of `git merge` when updating branch
  on top of latest changes
- Make sure each commit builds and passes tests.
  Do not break `git bisect`
- Do not "squash and merge"


Branch Naming
-------------

Name feature branches as follows: `<USER>/<TYPE>/<NAME>[/<EXT>]`.
Branch name must only contain ASCII lowercase letters, digits, hyphens,
and forward slashes.

- USER

  Owner of the branch

- TYPE

  [Branch type](#branch-types) based on the changes made

- NAME

  Short but descriptive name of the branch e.g. "fix-db-conn",
  not "task-123"

- EXT

  Additional information like issue number etc


Commit Messages
---------------

Commit messages must follow [conventional commits][conventional-commits]
specification and have the following format:

    <TYPE>(<SCOPE>): <TITLE>
        ... blank line ...
    <BODY>
        ... blank line ...
    <FOOTER>
        ... blank line ...
        ... blank line ...
    <REFS>

- TYPE (required)

  [Commit type](#commit-types).  Must be followed by exclamation mark
  ('!') if commit introduces a breaking change.

- SCOPE (optional)

  Scope of the commit changes.

- TITLE (required)

  Short description of commit changes.
  Use the imperative, present tense: "fix", not "fixed", nor "fixes".
  Capitalize the first letter.  Do not put dot ('.') at the end.
  The whole subject line (TYPE + SCOPE + TITLE) should not be longer
  than 50 characters (UTF-8 code points) and must not be longer than 72.

- BODY (optional)

  Detailed description of the commit changes.  Explanation why changes
  are introduced.  Use the imperative, present tense: "fix",
  not "fixed", nor "fixes".  Wrap text at 72 characters.

- FOOTER (optional)

  Breaking changes, deprecated features, removed features,
  major bugfixes, and security fixes should be described in the footer
  in sections starting with the phrases, in order: "BREAKING CHANGE",
  "DEPRECATED", "REMOVED", "FIXED", "SECURITY" followed by ": "
  (colon and space), summary of the change/fix, a blank line,
  and a detailed description of the change.

- REFS (optional)

  Reference to related issue that is being fixed:

      Closes #<issue>
      or
      Fixes #<issue>

[conventional-commits]: https://www.conventionalcommits.org


Branch Types
------------

- feat

  Add, change, refactor, deprecate, or remove a feature

- fix

  Properly fix a bug

- hotfix

  Quickly fix a critical bug with a temporary solution or create a
  workaround

- dev

  Make development improvements which do not have direct impact
  on end users

- test

  Experimental temporary branch.  Not to be merged


Commit Types
------------

- feat

  Add new feature

- change

  Change existing feature

- deprecate

  Deprecate existing feature

- remove

  Remove feature completely

- fix

  Fix a bug

- security

  Fix security vulnerability

- perf

  Improve performance

- docs

  Improve or add missing documentation.  Documentation only change

- refactor

  Refactor code

- style

  Small stylistic changes: typos, whitespace, etc

- test

  Improve or add missing tests.  Tests only change

- build

  Improve or change build process

- deps

  Update dependencies

- ci

  Improve or change CI/CD process

- release

  Create a release

- chore

  Any other type of commit that does not fit above types

- revert: ...

  Revert previous commit

- merge: ...

  Merge commits


Versioning and Changelog
------------------------

Commit types and how they relate to versioning and generating changelog.

| COMMIT TYPE | VERSION | CHANGELOG  |
|-------------|---------|------------|
| ...!        |  MAJOR  |            |
| feat        |  MINOR  | Added      |
| change      |  MINOR  | Changed    |
| deprecate   |  MINOR  | Deprecated |
| remove      |  MINOR  | Removed    |
| fix         |  PATCH  | Fixed      |
| security    |  PATCH  | Security   |
| perf        |  PATCH  | Changed    |
| docs        |   ---   |    ---     |
| refactor    |   ---   |    ---     |
| style       |   ---   |    ---     |
| test        |   ---   |    ---     |
| build       |   ---   |    ---     |
| deps        |   ---   |    ---     |
| ci          |   ---   |    ---     |
| release     |   ---   |    ---     |
| chore       |   ---   |    ---     |
| revert: ... |         |            |
| merge: ...  |         |            |


Example
-------

BAD:

    * ...
    * commit00  <- Main branch
    |\
    | * commit1   Add feature1, fix bug in feature0, and refactor some code
    | * commit2   Fix bug introduced by commit1
    | * commit3   Add feature2
    | * commit4   Fix compilation
    | * commit5   Fix failing unittests after introducing feature1 from commit1
    * | commit01  Some change introduced in the meantime in the main branch
    |/
    * commit6  Merge branch into main
    * ...

Why is it bad?

- `commit1` is big and contains multiple different changes.
  This makes it hard to fully understand and see which changes are
  needed for new feature to work, and which ones are fixing a bug, etc
- Branch contains unrelated changes.  It is better to split this into
  separate feature branches/PRs
- `commit2` is a development detail and should be squashed into
  `commit1`.  It does not matter that during development process bugs
  were introduced and later fixed while testing, etc.
  What matters is clean and easy to follow history of changes
- Commits `commit4` and `commit5` are fixing build and test processes.
  This means that previous commits do not compile and/or pass tests.
  This makes future `git bisect` unnecessarily more complicated or even
  impossible.  Which makes finding bugs harder
- History of commits is intermixed, first we make changes related to
  feature1, then feature2, and then back to feature1
- Merge commit is unnecessary.  It does not matter from which commit we
  happened to branch off nor how many times we run `git pull` and have
  resolved merge conflicts during development.
  Rebase instead and keep linear history that is easier to follow
- Commits do not follow convention and make it harder to see what
  type of changes are being made and harder to generate changelog

GOOD:

    branch1: user/fix/fix-feature0

    * ...
    * commit00  <- Main branch
    * commit01  Some change introduced in the meantime in the main branch
    * commit1   refactor: Refactor some code
    * commit2   fix: Fix bug in feature0
    * ...

    branch2: user/feat/add-features-1-2

    * ...
    * commit2   <- branch2 is on top of branch1 in this example
    * commit3   feat: Add feature1 (and align unittests to pass while doing so)
    * commit4   feat: Add feature2
    * ...
