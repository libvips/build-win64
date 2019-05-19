FROM ubuntu:bionic
MAINTAINER Lovell Fuller <npm@lovell.info>

ARG MESON_PATCH=https://raw.githubusercontent.com/libvips/build-win64-mxe/master/8.8/meson-3939.patch
ARG JHBUILD_REVISION=1de63586237917279487dcdbb138fba894351b01

# basic stuff
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
  && apt-get update \
  && apt-get install -y \
    build-essential \
    git \
    zip \
    libtool \
    intltool \
    mingw-w64 \
    mingw-w64-tools \
    nasm \
    cmake \
    # needed by fontconfig
    gperf \
    # needed by JHBuild
    python-minimal \
    # needed for Ninja and Meson
    python3-pip \
    # needed by pe-util
    libboost-filesystem-dev \
    libboost-system-dev

# build source packages here
WORKDIR /usr/local/src

# install JHBuild from source for Meson support
RUN git clone https://github.com/GNOME/jhbuild.git \
   && cd jhbuild \
   && git checkout -b stable $JHBUILD_REVISION \
   && ./autogen.sh --prefix=/usr/local \
   && make \
   && make install

# install Ninja and Meson
RUN pip3 install ninja meson

# TODO: remove if https://github.com/mesonbuild/meson/pull/3939 is merged
RUN cd `python3 -c "import site; print(site.getsitepackages()[0])"` \
  && curl $MESON_PATCH | git apply -v

# build pe-util, handy for copying DLL dependencies
RUN git clone --recurse-submodules https://github.com/gsauthof/pe-util.git \
  && cd pe-util \
  && mkdir build \
  && cd build \
  && cmake .. -DCMAKE_BUILD_TYPE=Release \
  && make \
  && make install

# the versioned build dir is mounted at /data, so this runs the build script
# in that
ENTRYPOINT ["/bin/bash", "/data/build.sh"]

# the versioned subdirectory is mounted here
WORKDIR /data
