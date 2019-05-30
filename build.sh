#!/bin/bash

set -e

if [ $# -lt 2 ]; then
  echo "Usage: $0 VERSION TARGET [VARIANT]"
  echo "Build jhbuild TARGET for win64 inside a Docker container"
  echo "VERSION is the name of a versioned subdirectory, e.g. 8.1"
  echo "TARGET is the jhbuild target, eg. libvips"
  echo "VARIANT is the target variant, eg. 'all'"
  exit 1
fi
version="$1"
target="$2"
variant="${3:-all}"

if [ x$(whoami) == x"root" ]; then
  echo "Please don't run as root -- instead, add yourself to the docker group"
  exit 1
fi

if ! type docker > /dev/null; then
  echo "Please install docker"
  exit 1
fi

# Ensure latest Ubuntu LTS base image
docker pull ubuntu:bionic

# Create a machine image with all the required build tools pre-installed
docker build -t libvips-build-win64 container

# Run build scripts inside container
# - inheriting the current uid and gid
# - versioned subdirectory mounted at /data
# - set ~ to /data as well, since jhbuild likes to cache stuff there
docker run --rm -t \
  -u $(id -u):$(id -g) \
  -v $PWD/$version:/data \
  -e "HOME=/data" \
  libvips-build-win64 $target $variant

# test outside the container ... saves us having to install wine inside docker
if [ -x "$(command -v wine)" ]; then
  echo -n "Found wine, testing build ... "
  if [ x"$target" = x"libvips" ]; then
    exe="$version/vips-dev-$version/bin/vips.exe"
  elif [ x"$target" = x"nip2" ]; then
    exe="$version/nip2-$version.*/bin/nip2.exe"
  else
    exe=
  fi

  if [ x"$exe" != x"" ]; then
    wine $exe --help > /dev/null
    if [ "$?" -ne "0" ]; then
      echo "WARNING: $exe failed to run"
    else
      echo "ok"
    fi
  else
    echo "no exe to test"
  fi
fi

# List result
echo "Successful build"
ls -al $version/*.zip
