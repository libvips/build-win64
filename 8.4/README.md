## build-win64

This set of scripts build a 64-bit vips or nip2 binary for Windows. 

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
	jhbuild --file=jhbuildrc --moduleset=nip2.modules build --nodeps nip2
	./package-nip2.sh

It'll make a simple nsis installer too. 

## TODO

* plots are not working, we see:

```
E Unable to open module file "Z:\home\john\GIT\build-win64\8.3\nip2-8.3.1\lib\goffice\0.8.17\plugins\plot_xy\xy".
  E 'Z:\home\john\GIT\build-win64\8.3\nip2-8.3.1\lib\goffice\0.8.17\plugins\plot_xy\xy.dll': Module not found.
```

  not related to 32/64 bit, tried making a 32-bit binary and that also failed

  probably due to our home-made glib ... for some reason, gmodule is trying to
  load a DLL when xy.la has already been compiled into goffice.dll 

  was glib 2.48.0, try 2.49.1

  nope, try 2.28.1, the version we were using for the win32 build

  modern gtk needs 2.37.6 or later, try that

  modern pango needs `g_assert_nonnull()` from 2.40.0 or later, try that

  nope, also fails

  try building with -g and using gdb inside wine

  the segv stack track looks like:

=>0 0x0000000063a4821d in libgobject-2.0-0 (+0x821d) (0x0000000001c6b3b0)
  1 0x0000000063a49fd1 in libgobject-2.0-0 (+0x9fd0) (0x0000000001c6b3b0)
  2 0x0000000063a4a6ed in libgobject-2.0-0 (+0xa6ec) (0x0000000001c6b3b0)
  3 0x0000000000457c53 in nip2 (+0x57c52) (0x0000000001c6b3b0)
  4 0x00000000004586fc in nip2 (+0x586fb) (0x0000000001c6b3b0)
  5 0x00000000004040c5 in nip2 (+0x40c4) (0x0000000001c6b3b0)

  perhaps we can stop it somehow?

  $ export VIPSHOME=../../../../../home/john/vips
  $ winedbg ./nip2-8.3.1/bin/nip2.exe 

  locks up when we crash

  $ ps aux | grep nip2
  $ gdb /usr/bin/wine
  (gdb) attach 24013

  fails with ptrace operation not permitted

  enable ptrace with

	echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

  still can't attach correctly

Attaching to program: /usr/bin/wine, process 10153
warning: Selected architecture i386 is not compatible with reported target architecture i386:x86-64
warning: Architecture rejected target-supplied description

  $ winedbg --gdb ./nip2-8.3.1/bin/nip2.exe 

  fails with "fixme:dbghelp:EnumerateLoadedModulesW64 If this happens, bump the
number in mod 0023:0024: create thread I @0x4014e0"

  ... it's going to be printf

  build goffice static, we get a huge .a file and no .dlls, but it still tries 
  to load plugins

  found the problem:

```
plot_new_gplot():plot.c
	gog_plot_new_by_name( "GogXYPlot" );
```
  
  returns NULL, because `g_type_from_name("GogXYPlot")` returned zero and it
  therefore tried to load the plugin

  we need to call the `go_plugin_init()` for XYPlot, I guess

  how has gmodule changed since 2.24 or whatever the last functioning glib was?

* text is broken ... pango-ft2 is not building?

* orc is not working

* test nip2 build in docker

* more testing
