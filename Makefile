CRATE_NAME = "bps"
PKG_NAME = $(shell basename -s .git $$(git remote get-url origin))
PKG_VERSION = $(shell echo "$$(cargo pkgid | cut -d\# -f2-)-$$(git rev-list --all --count)")
BRANCH = $(shell echo "-$$(git rev-parse --abbrev-ref HEAD)")

ifeq "$(BRANCH)" "-main"
BRANCH = ""
endif

ifeq "$(BRANCH)" "-master"
BRANCH = ""
endif

PKG_NAME := "$(PKG_NAME)$(BRANCH)"
BUILD_COMMNAD = $(shell echo "cargo build --release")

clear:
	rm -rf ./out

build-native:
	$(BUILD_COMMNAD)
	mkdir -p ./out
	cp target/release/$(CRATE_NAME) out/$(CRATE_NAME)

build-x64:
	rustup target add x86_64-unknown-linux-gnu
	$(BUILD_COMMNAD) --target=x86_64-unknown-linux-gnu
	mkdir -p ./out
	cp target/x86_64-unknown-linux-gnu/release/$(CRATE_NAME) out/$(CRATE_NAME)
	gzip -cf out/$(CRATE_NAME) > out/$(CRATE_NAME)-x64-bin.gz

build: build-native

create-deb-template:
	rm -rf out/deb/DEBIAN
	mkdir -p ./out/deb/DEBIAN
	mkdir -p ./out/deb/usr/bin/
	cp contrib/deb/control out/deb/DEBIAN/control
	echo "Package: $(PKG_NAME)" >> out/deb/DEBIAN/control
	echo "Version: $(PKG_VERSION)" >> out/deb/DEBIAN/control

build-deb-x64: build-x64 create-deb-template
	rm -rf out/$(PKG_NAME)-x64
	cp -r out/deb out/$(PKG_NAME)-x64
	echo "Architecture: amd64" >> out/$(PKG_NAME)-x64/DEBIAN/control
	cp out/$(CRATE_NAME) out/$(PKG_NAME)-x64/usr/bin/$(CRATE_NAME)
	dpkg-deb --build out/$(PKG_NAME)-x64

install-deb-x64:
	apt install out/$(PKG_NAME)-x64

install:
	cp out/$(CRATE_NAME) /usr/bin/$(CRATE_NAME)

uninstall:
	rm /usr/bin/$(CRATE_NAME)
