Fish
====

Generate random fish names.


Build and Install from Source
-----------------------------

1. Install build dependencies (these can be removed after build)

   - rust + cargo (>= 1.56)
   - make

2. Download and extract source code

       # packages available also in .tar.zst and .zip formats
       curl -LO https://github.com/szatanjl/fish/releases/download/v0.1.0/fish-v0.1.0.tar.gz
       tar -xzf fish-v0.1.0.tar.gz

3. Build and install

       cd fish-v0.1.0
       make CARGO_FLAGS=-r
       make install


Run Using Docker
----------------

    docker pull ghcr.io/szatanjl/fish:v0.1.0
    docker run -it --rm ghcr.io/szatanjl/fish:v0.1.0 /app/fish -P
    docker run -it --rm -p 3000:3000 ghcr.io/szatanjl/fish:v0.1.0


Quick Start
-----------

1. Install docker and docker-compose
2. Run `docker compose up`

See [documentation](docs/index.md) for details.


Development
-----------

1. Install required dependencies

   - rust + cargo (>= 1.56)
   - git

2. Install optional dependencies

   - sh: Run make scripts
   - make: Build using make, which wraps cargo commands and adds more
   - docker: Build docker image

3. Clone repository

       git clone https://github.com/szatanjl/fish.git

4. [Configure make](docs/make.md#configuration)

5. Build and run project

       cargo run --bin fish -- -P
       cargo run --bin fishd

See [documentation](docs/index.md#development) for details.


Questions
---------

Before asking a question, check out [documentation](docs/index.md)
and issues labeled "question".

Cannot find answer you are looking for?
[Submit an issue](docs/CONTRIBUTING.md#issues) or write an email to
<leszczak.jakub@gmail.com>.


Contributing
------------

Found a security vulnerability?
Read [security policy](docs/SECURITY.md).

Found a bug?  Missing a feature?  Want to help?
Read [contribution guidelines](docs/CONTRIBUTING.md).


License
-------

This project is licensed under the [MIT license](LICENSE).
