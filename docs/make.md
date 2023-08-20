make
====


Targets
-------

- `make [all]`

  Build project binaries and libraries

- `make bin`

  Build binaries

- `make lib`

  Build libraries

- `make deps`

  Fetch dependencies

- `make dist`

  Build cargo create

- `make version`

  Generate version information

- `make release`

  Create new release

- `make install`

  Install all files

- `make install-bin`

  Install binaries

- `make install-lib`

  Install libraries

- `make install-man-bin`

  Install man pages for binaries

- `make install-man-lib`

  Install man pages for libraries

- `make uninstall`

  Uninstall all files

- `make uninstall-bin`

  Uninstall binaries

- `make uninstall-lib`

  Uninstall libraries

- `make uninstall-man-bin`

  Uninstall man pages for binaries

- `make uninstall-man-lib`

  Uninstall man pages for libraries

- `make check`

  Check code formatting, and run linters and tests

- `make test`

  Run tests

- `make lint`

  Lint project

- `make fmt`

  Format code

- `make fmt-check`

  Check code formatting

- `make run`

  Build and run project

- `make docker`

  Build docker image

- `make docker-run`

  Run built docker image

- `make clean`

  Remove built files

- `make distclean`

  Remove built files, configuration files, and Cargo.lock

- `make cleanall`

  Remove built files, configuration files, Cargo.lock,
  and generated version information


Configuration
-------------

`make` can be configured by setting following variables
in config.mk file or via CLI:

- `NAME`

  Project name

- `PKGNAME`

  Distribution tarball filename without extension.  Default: `${NAME}`

- `DOCKERNAME`

  Docker image name.  Default: `${NAME}`

- `TAR`

  Archive utility to use.  Default `tar`

- `TARFLAGS`

  Options passed to the archive utility.  Default: `-cf ${PKGNAME}.tar`

- `ZIP`

  Compression utility to use.  Default: `gzip`

- `ZIPFLAGS`

  Options passed to the compression utility.  Default: empty

- `CARGO`

  Rust package manager to use.  Default: `cargo`

- `CARGO_FLAGS`

  Options passed to `${CARGO} build`.  Default: empty

- `CARGO_FETCH_FLAGS`

  Options passed to `${CARGO} fetch`.  Default: empty

- `CARGO_DIST_FLAGS`

  Options passed to `${CARGO} package`.  Default: empty

- `CARGO_TEST_FLAGS`

  Options passed to `${CARGO} test`.  Default: empty

- `CARGO_LINT_FLAGS`

  Options passed to `${CARGO} clippy`.  Default: empty

- `CARGO_FMT_FLAGS`

  Options passed to `${CARGO} fmt`.  Default: empty

- `CARGO_RUN_FLAGS`

  Options passed to `${CARGO} run`.  Default: empty

- `CARGO_RUN_ARGS`

  Arguments passed to binary executed by `${CARGO} run`.  Default: empty

- `CARGO_CLEAN_FLAGS`

  Options passed to `${CARGO} clean`.  Default: empty

- `DOCKER`

  Container management utility to use: `docker` or `podman`.
  Default: `docker`

- `DOCKER_FLAGS`

  Options passed to `${DOCKER} build`.  Default:

      --build-arg CARGO='${CARGO}'
      --build-arg CARGO_FLAGS='${CARGO_FLAGS}'
      --build-arg CARGO_FETCH_FLAGS='${CARGO_FETCH_FLAGS}'

- `DOCKER_RUN_FLAGS`

  Options passed to `${DOCKER} run`.
  Default: `-it --rm --init --name ${DOCKERNAME}`

- `DOCKER_CMD`

  Command executed by `${DOCKER} run`.  Default: empty


Installation
------------

`make install` can be configured by setting following variables
in config.mk file or via CLI:

- `DESTDIR`

  Destination directory.  Default: empty

- `prefix`

  Prefix used in constructing all default values of directories below.
  Default: `/usr/local`

- `exec_prefix`

  Prefix used in constructing some default values of directories below.
  Default: `${prefix}`

- `bindir`

  Directory for installing binaries for users.
  Default: `${exec_prefix}/bin`

- `sbindir`

  Directory for installing binaries for system administrators.
  Default: `${exec_prefix}/sbin`

- `libexecdir`

  Directory for installing binaries run by other programs, not by users.
  Default: `${exec_prefix}/libexec`

- `libdir`

  Directory for installing libraries.  Default: `${exec_prefix}/lib`

- `includedir`

  Directory for installing C headers.  Default: `${prefix}/include`

- `datarootdir`

  Root directory for installing read-only architecture-independent data
  files.  Default: `${prefix}/share`

- `datadir`

  Directory for installing read-only data files.
  Default: `${datarootdir}`

- `sysconfdir`

  Directory for installing read-only configuration files.
  Default: `${prefix}/etc`

- `localstatedir`

  Directory for installing persistent modifiable data files.
  Default: `${prefix}/var`

- `runstatedir`

  Directory for installing non-persistent modifiable data files.
  Default: `${prefix}/run`

- `mandir`

  Root Directory for installing man pages.
  Default: `${datarootdir}/man`

- `man1dir`, `man2dir`, `man3dir`, ...

  Directories for installing man pages into specific sections.
  Default: `${mandir}/man{1,2,3,...}`
