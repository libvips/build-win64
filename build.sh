#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 VERSION [DEPS]"
  echo "Build libvips for win64 using Docker"
  echo "VERSION is the name of a versioned subdirectory, e.g. 8.1"
  echo "DEPS is the group of dependencies to build libvips with, defaults to 'all'"
  exit 1
fi
VERSION="$1"
DEPS="${2:-all}"

if [ x$(whoami) == x"root" ]; then
  echo "Please don't run as root -- instead, add yourself to the docker group"
  exit 1
fi

if ! type docker > /dev/null; then
  echo "Please install docker"
  exit 1
fi

# Ensure latest Ubuntu LTS base image
docker pull ubuntu:xenial

# Create a machine image with all the required build tools pre-installed
docker build -t libvips-build-win64 container

# Run build scripts inside container
# 	- inheriting the currnet uid and gid
# 	- versioned subdirectory mounted at /data
# 	- set ~ to /data as well, since jhbuild likes to cache stuff there
docker run --rm -t \
	-u $(id -u):$(id -g) \
	-v $PWD/$VERSION:/data \
	-e "DEPS=$DEPS" \
	-e "HOME=/data" \
	libvips-build-win64 \
	sh -c ./build.sh

# List result
ls -al $PWD/$VERSION/*.zip
