FROM ubuntu:bionic
MAINTAINER Lovell Fuller <npm@lovell.info>

# basic stuff
RUN \
  echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
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

# without this, configuring tzdata will ask for a time zone
# croco needs gtk-doc
RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  export DEBCONF_NONINTERACTIVE_SEEN=true && \
  echo "tzdata tzdata/Areas select Europe" > /tmp/preseed.txt && \
  echo "tzdata tzdata/Zones/Europe select London" >> /tmp/preseed.txt && \
  debconf-set-selections /tmp/preseed.txt && \
  apt-get install -y \
    gtk-doc-tools \
    xmlto \
    wget \
    yelp-tools \
    gperf 

# the versioned build dir is mounted at /data, so this runs the build script
# in that
ENTRYPOINT ["/bin/bash", "/data/build.sh"]

# the versioned subdirectory is mounted here
WORKDIR /data
