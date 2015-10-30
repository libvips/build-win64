## build-win64

This set of scripts build a 64-bit vips binary for Windows. They won't make a
64-bit nip2, see `build-win32` for that. 

On Ubuntu, follow these steps:

### Install jhbuild

Install `jhbuild`. Don't use the official Ubuntu one, it's missing the
modulesets we need for the glib parts of the system. Instead, install from
git. 

Follow these instructions:

https://developer.gnome.org/jhbuild/3.12/getting-started.html.en

Briefly:

	sudo apt-get install yelp-tools
	git clone git://git.gnome.org/jhbuild
	cd jhbuild
	./autogen.sh
	make
	make install

add ~/.local/bin to your PATH

### Fetch binary dependencies

We use some binary zips for basic things like libz and gettext. Run:

	./get-win64-packages.sh

To fetch the zips. Run:

	./unpack.sh

To wipe inst/ and reinitialize it from the zips.

### Install mingw

You need the mingw cross-compiler for generating 64-bit Windows binaries.

	sudo apt-get install mingw-w64

### Build

Run:

	jhbuild --file=jhbuildrc build --nodeps libvips

## TODO

* fixing up package-vipsdev.sh

* test
