FROM ubuntu:xenial
MAINTAINER Lovell Fuller <npm@lovell.info>

# basic stuff
RUN \
  echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
    build-essential \
    jhbuild \
    libtool \
    intltool \
    mingw-w64 \
    mingw-w64-tools \
    nasm \
    cmake 

# strange extras for certain packages
# croco needs gtk-doc
# we use wine to test the build
RUN \
  apt-get install -y \
    gtk-doc-tools \
    xmlto \
    wget \
    yelp-tools \
    gperf \
    wine \
    wine1.6-amd64

# the versioned subdirectory is mounted here
WORKDIR /data
