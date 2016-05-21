## build-win64

This set of scripts build a 64-bit vips binary for Windows. They won't
make a 64-bit nip2, see `build-win32` for that.

You don't need to follow these instructions to make a Windows binary,
instead, see the README in the parent directory to make a binary using
a Docker container. Only keep reading if you want to work on the build
scripts.

On Ubuntu, follow these steps:

### Install mingw

You need the mingw cross-compiler to generate 64-bit Windows binaries.

	sudo apt-get install mingw-w64 mingw-w64-tools

The `tools` package provides `gendef`, which we use to generate .def files for
our DLLs.

### Install `jhbuild`

I installed from git, but the packaged `jhbuild` might work. 

Follow these instructions:

https://developer.gnome.org/jhbuild/3.12/getting-started.html.en

Briefly:

	sudo apt-get install yelp-tools
	git clone git://git.gnome.org/jhbuild
	cd jhbuild
	./autogen.sh
	make
	make install

add `~/.local/bin` to your `PATH`.

### Check the build variables

Have a look in `variables.sh` and make sure the version numbers and other
settings are right. 

### Fetch binary dependencies

We use some binary zips for basic things like `libz` and `gettext`. Run:

	./get-win64-packages.sh

To fetch the zips. Run:

	./unpack.sh

To wipe `inst/` and reinitialize it from the zips.

### Build

Run:

	export BASEDIR=$(pwd)
	jhbuild --file=jhbuildrc build --nodeps libvips-all

BASEDIR is needed by vips.modules to pass the toolchain file to cmake. 
It will take a while. 

You can use libvips-web and libvips-transform as targets too.

## Package

Run:

	./package-vipsdev.sh 

To make a nice `vips-dev.zip` package. 

## nip2

There's a nip2 build here as well, just as above but run:

	./get-win64-packages.sh
	./unpack.sh
	export BASEDIR=$(pwd)
	jhbuild --file=jhbuildrc build --nodeps nip2
	./package-nip2.sh

It'll make a simple nsis installer too. 

## TODO

* text is broken ... pango-ft2 is not building?

* orc is not working

* test nip2 build in docker

* more testing

