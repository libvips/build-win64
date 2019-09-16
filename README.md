# build-win64

Build a libvips binary for 64-bit Windows. The resulting zip file includes all
necessary DLLs, EXEs, headers, etc.

Only use this repo if you MUST build libvips yourself. There are pre-compiled
binaries for libvips here:

https://github.com/libvips/libvips/releases

One of those would probably be a better idea. 

### Build with docker

Docker will make a light-weight virtual machine containing all the
tools you need and then build inside that. You won't need to install any
extra stuff on the host machine, and everything is automated.

First, install docker:

https://docs.docker.com/engine/installation/

Make sure you're in the docker group so you can run docker without needing
`sudo`.

Now run the build script:

```
$ ./build.sh 8.8 web
```

At the end of the build, the script will display the paths of all the
zip files it created, ready to be uploaded to the server. Be patient,
this process can take an hour, even on a powerful machine.

### Build with `jhbuild`

See the README in the 8.x subdirectory for instructions for building
directly in `jhbuild`.

### TODO

- try installing win64 python and running it under wine so we can run the test
  suite? who knows, it could work

	wget https://www.python.org/ftp/python/2.7.10/python-2.7.10.amd64.msi

  headless install

	wine msiexec /qn /i python-2.7.10.amd64.msi 

  does not set PATH, so to run, use:

	WINEPATH=c:/python27 wine python.exe test.py

  try

	WINEPATH="c:/python27;/home/john/GIT/build-win64/8.1/x/vips-dev-8.1.1/bin" GI_TYPELIB_PATH=/home/john/GIT/build-win64/8.1/x/vips-dev-8.1.1/lib/girepository-1.0 wine python test_all.py


