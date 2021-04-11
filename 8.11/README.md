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

```bash
sudo apt install mingw-w64 mingw-w64-tools
```

The `tools` package provides `gendef`, which we use to generate .def files for
our DLLs.

### Install `jhbuild`

You need to install jhbuild from source to get meson support. 
You need to install pe-util from source as well. 

Check Dockerfile.

### Install Rust

You need Rust to build librsvg.

```bash
curl https://sh.rustup.rs -sSf | sh -s -- -y
~/.cargo/bin/rustup target add x86_64-pc-windows-gnu
```

### Other packages 

Various other packages required during the build:

```bash
sudo apt install cmake nasm gperf intltool
```

### Check the build variables

Have a look in `variables.sh` and make sure the version numbers and other
settings are right. 

### Build

Run:

  ./clean.sh
	jhbuild --file=jhbuildrc build --nodeps libvips-all

You can use libvips-web and libvips-transform as targets too.

### Package

Run:

	./package-vipsdev.sh web

To make a nice `vips-dev-w64-web-x.y.z.zip` package. 

