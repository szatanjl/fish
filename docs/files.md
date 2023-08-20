Files
=====

    ./
    |-- .git/
    |-- .github/
    |   |-- actions/
    |   |-- workflows/
    |   `-- ...
    |-- docs/
    |   |-- CONTRIBUTING.md
    |   |-- SECURITY.md
    |   |-- SUPPORT.md
    |   |-- index.md
    |   `-- ...
    |-- make/
    |   |-- release.sh
    |   |-- version.sh
    |   `-- ...
    |-- man/
    |-- src/
    |   |-- main.rs
    |   `-- ...
    |-- target/ (generated)
    |-- tests/
    |-- .dockerignore
    |-- Cargo.lock (generated)
    |-- Cargo.toml
    |-- Dockerfile
    |-- LICENSE
    |-- Makefile
    |-- README.md
    |-- config.mk (optional)
    `-- version.mk (generated)


Source Code
-----------

- `src/`

  Source code

- `src/main.rs`

  Program entry point

- `tests/`

  Tests


Documentation
-------------

- `README.md`

  Project description

- `LICENSE`

  Project license

- `docs/`

  Project documentation

- `docs/index.md`

  Documentation entry point

- `docs/CONTRIBUTING.md`

  Contribution guidelines

- `docs/SECURITY.md`

  Security policy

- `docs/SUPPORT.md`

  How to get support

- `man/`

  Man pages


Build
-----

- `Cargo.toml`

  Rust project metadata and dependencies

- `Cargo.lock`

  Locked dependencies versions

- `make/`

  Scripts and other files used during build and release processes

- `Makefile`

  Build instructions for make utility

- `config.mk`

  make utility configuration

- `Dockerfile`

  Build instructions for docker utility

- `.dockerignore`

  Specifies files that docker should ignore

- `target/`

  Built files: binaries, libs, dependencies, and packages


Versioning and Releasing
------------------------

- `make/version.sh`

  Shell script generating version information

- `make/release.sh`

  Shell script for creating project releases

- `version.mk`

  Generated version information


CI/CD
-----

- `.github/workflows/`

  CI/CD workflows

- `.github/actions/`

  CI/CD actions used by workflows


Repository
----------

- `.git/`

  Git version control system metadata

- `.gitignore`

  Specifies untracked files that git should ignore

- `.github/`

  GitHub repository configuration
