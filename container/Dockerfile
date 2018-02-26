FROM ubuntu:xenial
MAINTAINER Lovell Fuller <npm@lovell.info>

# croco needs gtk-doc
# we use wine to test the build
RUN \
  echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
    build-essential \
    jhbuild \
    libtool \
    gtk-doc-tools \
    mingw-w64 \
    mingw-w64-tools \
    nasm \
    cmake \
    xmlto \
    wget \
    yelp-tools \
    gperf \
    libglib2.0-dev \
    wine \
    wine1.6-amd64

# Create a default, non-root 'build' user
RUN groupadd -r build && useradd -m -g build build
WORKDIR /data
USER build
