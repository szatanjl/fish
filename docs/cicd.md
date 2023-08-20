CI/CD
=====


Workflows
---------

- `check-all`

  Run tests on all commits

- `check`

  Run tests

- `release`

  Release project

- `deploy-release`

  Deploy release

- `deploy-commit`

  Deploy commit

- `clear-statuses`

  Clear statuses


Helper Actions
--------------

- `checkout`

  Checkout project code

- `get-hash`

  Get commit hash from ref

- `status-get`

  Get commit status

- `status-set`

  Set commit status (or skip if status already set)

- `status-clear`

  Clear statuses

- `status-inherit`

  Inherit status from parent commits

- `dispatch-check`

  Dispatch `check` workflow run


Build Actions
-------------

- `make-test`

  Run tests

- `make-lint`

  Run formatters and linters

- `make-version`

  Generate version information

- `make-dist`

  Build distribution tarballs

- `make-docker`

  Build docker image



Release Actions
---------------

- `release-create`

  Create new release (and delete old one if needed)

- `release-delete`

  Delete release

- `release-files`

  Release files

- `release-docker`

  Push docker image to registry


Deploy Actions
--------------

- `deploy`

  Deploy
