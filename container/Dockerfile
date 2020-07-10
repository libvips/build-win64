FROM ubuntu:bionic
MAINTAINER Lovell Fuller <npm@lovell.info>

ARG JHBUILD_REVISION=3.36.0

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

# basic stuff
RUN apt-get update \
  && apt-get install -y \
    build-essential \
    cmake \
    git \
    gperf \
    intltool \
    libtool \
    mingw-w64 \
    mingw-w64-tools \
    nasm \
    zip \
    # needed when building libvips from git
    gobject-introspection \
    gtk-doc-tools \
    # needed by Meson
    ninja-build \
    python3-pip \
    # needed by pe-util
    libboost-filesystem-dev \
    libboost-system-dev \
  && curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path --profile minimal -y \
  && rustup target add x86_64-pc-windows-gnu \
  && pip3 install meson

# install JHBuild from source for Meson support
RUN git clone https://github.com/GNOME/jhbuild.git /usr/local/src/jhbuild

WORKDIR /usr/local/src/jhbuild

RUN git checkout -b stable $JHBUILD_REVISION \
  && ./autogen.sh --prefix=/usr/local \
  && make \
  && make install

# build pe-util, handy for copying DLL dependencies
RUN git clone --recurse-submodules https://github.com/gsauthof/pe-util.git /usr/local/src/pe-util

WORKDIR /usr/local/src/pe-util/build

RUN cmake .. -DCMAKE_BUILD_TYPE=Release \
  && make \
  && make install

# the versioned build dir is mounted at /data, so this runs the build script
# in that
ENTRYPOINT ["/bin/bash", "/data/build.sh"]

# the versioned subdirectory is mounted here
WORKDIR /data
