#!/bin/sh

if [ $# -lt 1 ]; then
  echo "Usage: $0 VERSION"
  echo "Build libvips for win64 using Docker"
  echo "VERSION is the name of a versioned subdirectory, e.g. 8.1"
  exit 1
fi
VERSION="$1"

if ! type docker > /dev/null; then
  echo "Please install docker"
  exit 1
fi

# Create a machine image with all the required build tools pre-installed
docker build -t libvips-build-win64 container

# Run build scripts inside container, with versioned subdirectory mounted at /data
docker run --rm -t -v $PWD/$VERSION:/data libvips-build-win64 sh -c "cp /data/* .; ./build.sh && cp vips-dev-w64-*.zip /data"

# List result
ls -al $PWD/$VERSION/*.zip
