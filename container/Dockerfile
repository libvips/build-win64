FROM ubuntu:wily
MAINTAINER Lovell Fuller <npm@lovell.info>

# Install dependencies
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
	  gtk-doc-tools \
	  jhbuild \
	  libtool \
	  mingw-w64 \
	  mingw-w64-tools \
	  nasm \
	  wget \
	  yelp-tools \
	  libglib2.0-dev \
	  wine \
	  wine1.6-amd64

# Create a default, non-root 'build' user
RUN groupadd -r build && useradd -m -g build build
WORKDIR /home/build
USER build
