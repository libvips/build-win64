## build-win64

This set of scripts build a 64-bit vips binary for Windows. They won't
make a 64-bit nip2, see `build-win32` for that.

You don't need to follow these instructions to make a Windows binary.
Instead, see the README in the parent directory to make a binary using
a Docker container. Only keep reading if you want to work on the build
scripts themselves. 

On Ubuntu, follow these steps as a regular user:

### Install mingw

You need the mingw cross-compiler to generate 64-bit Windows binaries.

	sudo apt install mingw-w64 mingw-w64-tools 

The `tools` package provides `gendef`, which we use to generate .def files for
our DLLs. `gperf` is needed by fontconfig during build. 

### Install other bits and pieces

A few other packages are required

	sudo apt gperf intltool

### Install Wine

Optional, this is used to test the build. 

	sudo apt install wine-stable wine64

### Install `jhbuild`

`jhbuild` runs the whole builds process. Install the packaged version:

	sudo apt install jhbuild

### Check the build variables

Have a look in `variables.sh` and make sure the version numbers and other
settings are right. 

### Build

Run:

	export BASEDIR=$(pwd)
	./unpack.sh
	jhbuild --file=jhbuildrc build --nodeps libvips-all

`BASEDIR` is needed by vips.modules to pass the toolchain file to cmake. 
It will take a while. 

You can use libvips-web and libvips-transform as targets too.

## Package

Run:

	./package-vipsdev.sh 

To make a nice `vips-dev.zip` package. 

