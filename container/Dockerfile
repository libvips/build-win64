FROM ubuntu:wily
MAINTAINER Lovell Fuller <npm@lovell.info>

# Install dependencies ... these come in two parts: the first set are for the
# native linux build we need to do to generate the typelib, the second set for
# the cross-platform win64 build
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
    build-essential \
    libxml2-dev \
    glib2.0-dev \
    gobject-introspection \
    python-gi-dev \
    libgirepository1.0-dev \
    gtk-doc-tools \
    \
    jhbuild \
    libtool \
    mingw-w64 \
    mingw-w64-tools \
    nasm \
    cmake \
    xmlto \
    wget \
    yelp-tools \
    libglib2.0-dev \
    wine \
    wine1.6-amd64

# Create a default, non-root 'build' user
RUN groupadd -r build && useradd -m -g build build
WORKDIR /home/build
USER build
