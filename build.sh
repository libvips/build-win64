#!/usr/bin/env bash

set -e

if [ $# -lt 1 ]; then
  echo "Usage: $0 VERSION [DEPS]"
  echo "Build libvips for win64 using Docker"
  echo "VERSION is the name of a versioned subdirectory, e.g. 8.1"
  echo "DEPS is the group of dependencies to build libvips with, defaults to 'all'"
  exit 1
fi
version="$1"
deps="${2:-all}"

if [ x$(whoami) == x"root" ]; then
  echo "Please don't run as root -- instead, add yourself to the docker group"
  exit 1
fi

# Is docker available?
if ! [ -x "$(command -v docker)" ]; then
  echo "Please install docker"
  exit 1
fi

# Ensure latest Ubuntu LTS base image
docker pull ubuntu:focal

# Create a machine image with all the required build tools pre-installed
docker build -t libvips-build-win64 container

# Run build scripts inside container
# - inheriting the current uid and gid
# - versioned subdirectory mounted at /data
# - set ~ to /data as well, since jhbuild likes to cache stuff there
# - run interactively, since it's often useful to be able to redo sections
docker run --rm -it \
  -u $(id -u):$(id -g) \
  -v $PWD/$version:/data \
  -e "HOME=/data" \
  libvips-build-win64 \
  $deps

# test outside the container ... saves us having to install wine inside docker
if [ -x "$(command -v wine)" ]; then
  echo -n "found wine, testing build ... "
  wine $version/vips-dev-$version/bin/vips.exe --help > /dev/null
  if [ "$?" -ne "0" ]; then
    echo "WARNING: vips.exe failed to run"
  else
    echo "ok"
  fi
fi

# List result
echo "Successful build"
ls -al $PWD/$version/*.zip
