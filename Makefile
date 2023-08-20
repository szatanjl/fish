NAME = fish
PKGNAME = $(NAME)
DOCKERNAME = $(NAME)

TAR = tar
TARFLAGS = -cf $(PKGNAME).tar
ZIP = gzip
ZIPFLAGS =

CARGO = cargo
CARGO_FLAGS =
CARGO_FETCH_FLAGS =
CARGO_DIST_FLAGS =
CARGO_TEST_FLAGS =
CARGO_LINT_FLAGS =
CARGO_FMT_FLAGS =
CARGO_RUN_FLAGS =
CARGO_RUN_ARGS =
CARGO_CLEAN_FLAGS =

DOCKER = docker
DOCKER_FLAGS = \
	--build-arg CARGO='$(CARGO)' \
	--build-arg CARGO_FLAGS='$(CARGO_FLAGS)' \
	--build-arg CARGO_FETCH_FLAGS='$(CARGO_FETCH_FLAGS)'
DOCKER_RUN_FLAGS = -it --rm --init --name $(DOCKERNAME)
DOCKER_CMD =

DESTDIR =
prefix = /usr/local
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
sbindir = $(exec_prefix)/sbin
libexecdir = $(exec_prefix)/libexec
libdir = $(exec_prefix)/lib
includedir = $(prefix)/include
datarootdir = $(prefix)/share
datadir = $(datarootdir)
sysconfdir = $(prefix)/etc
localstatedir = $(prefix)/var
runstatedir = $(localstatedir)/run
mandir = $(datarootdir)/man
man1dir = $(mandir)/man1
man3dir = $(mandir)/man3


all:

-include version.mk
-include config.mk


.PHONY: all bin lib deps
.PHONY: dist version release
.PHONY: install install-bin install-lib install-man-bin install-man-lib
.PHONY: uninstall uninstall-bin uninstall-lib
.PHONY: uninstall-man-bin uninstall-man-lib
.PHONY: check test lint fmt fmt-check
.PHONY: run serve
.PHONY: docker docker-run
.PHONY: clean distclean cleanall

all:
	$(CARGO) build $(CARGO_FLAGS)

bin:
	$(CARGO) build --bins $(CARGO_FLAGS)

lib:
	$(CARGO) build --lib $(CARGO_FLAGS)

deps:
	$(CARGO) fetch $(CARGO_FETCH_FLAGS)

dist:
	$(CARGO) package $(CARGO_DIST_FLAGS)

version: make/version.sh
	{ \
	./$< && printf '%s\n' '' \
		'PKGNAME = $$(NAME)-$$(VERSION)' \
		'DOCKERNAME = $$(NAME):$$(VERSION)'; \
	} >| version.mk

release: make/release.sh
	./$<

install: install-bin install-lib install-man-bin install-man-lib

install-bin: bin
	mkdir -p $(DESTDIR)$(bindir)
	cp -f target/release/fish target/release/fishd $(DESTDIR)$(bindir)
	chmod +x $(DESTDIR)$(bindir)/fish $(DESTDIR)$(bindir)/fishd

install-lib: lib
	mkdir -p $(DESTDIR)$(libdir)

install-man-bin: man/fish.1 man/fishd.1
	mkdir -p $(DESTDIR)$(man1dir)
	cp -f man/fish.1 man/fishd.1 $(DESTDIR)$(man1dir)

install-man-lib:
	mkdir -p $(DESTDIR)$(man3dir)

uninstall: uninstall-man-lib uninstall-man-bin
uninstall: uninstall-lib uninstall-bin

uninstall-bin:
	rm -f $(DESTDIR)$(bindir)/fish $(DESTDIR)$(bindir)/fishd
	-cd $(DESTDIR) && rmdir -p .$(bindir)

uninstall-lib:
	-cd $(DESTDIR) && rmdir -p .$(libdir)

uninstall-man-bin:
	rm -f $(DESTDIR)$(man1dir)/fish.1 $(DESTDIR)$(man1dir)/fishd.1
	-cd $(DESTDIR) && rmdir -p .$(man1dir)

uninstall-man-lib:
	-cd $(DESTDIR) && rmdir -p .$(man3dir)

check: fmt-check lint test

test:
	$(CARGO) test $(CARGO_TEST_FLAGS)

lint: make/lint.sh
	$(CARGO) clippy $(CARGO_LINT_FLAGS)
	./$<

fmt: make/fmt.sh
	$(CARGO) fmt $(CARGO_FMT_FLAGS)
	./$<

fmt-check: make/fmt-check.sh
	$(CARGO) fmt --check $(CARGO_FMT_FLAGS)
	./$<

run:
	$(CARGO) run --bin fish $(CARGO_RUN_FLAGS) -- $(CARGO_RUN_ARGS)

serve:
	$(CARGO) run --bin fishd $(CARGO_RUN_FLAGS) -- $(CARGO_RUN_ARGS)

docker:
	$(DOCKER) build $(DOCKER_FLAGS) -t $(DOCKERNAME) .

docker-run:
	$(DOCKER) run $(DOCKER_RUN_FLAGS) $(DOCKERNAME) $(DOCKER_CMD)

clean:
	$(CARGO) clean $(CARGO_CLEAN_FLAGS)

distclean: clean
	rm -f Cargo.lock config.mk

cleanall: distclean
	rm -f version.mk
