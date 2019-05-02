#!/bin/bash

# set -x
set -e

if [ $# -lt 1 ]; then
  echo "Usage: $0 [DEPS]"
  echo "Build libvips for win"
  echo "DEPS is the group of dependencies to build libvips with,"
  echo "    defaults to 'all'"
  exit 1
fi

. variables.sh

deps="${1:-all}"

# Make sure that the repackaging dir is empty
rm -rf $repackagedir
mkdir -p $repackagedir/bin

echo "Copying libvips and dependencies"

# Copy libvips and dependencies with pe-util
/usr/local/bin/peldd \
  $installdir/bin/libvips-cpp-42.dll \
  --clear-path \
  --path $installdir/bin \
  --path /usr/lib/gcc/x86_64-w64-mingw32/*-posix \
  --path /usr/x86_64-w64-mingw32/lib/ \
  -a \
  -w USERENV.dll \
  -w USP10.dll \
  -w DNSAPI.dll \
  -w IPHLPAPI.DLL \
  -w MSIMG32.DLL | xargs cp -t $repackagedir/bin

echo "Copying install area $installdir"

# Follow symlinks when copying /share and /etc
cp -Lr $installdir/{share,etc} $repackagedir

# Copy everything from /lib and /include, then delete the symlinks
cp -r $installdir/{lib,include} $repackagedir
find $repackagedir/{lib,include} -type l -exec rm -f {} \;

echo "Generating import files"

./gendeflibs.sh

echo "Cleaning unnecessary files / directories"

# TODO Do we need to keep /share/doc and /share/gtk-doc?
rm -rf $repackagedir/share/{aclocal,bash-completion,doc,glib-2.0,gtk-2.0,info,gtk-doc,installed-tests,man,thumbnailers,xml}

rm -rf $repackagedir/include/cairo

rm -rf $repackagedir/lib/{*cairo*,*gdk*,ldscripts}
find $repackagedir/lib -name "*.la" -exec rm -f {} \;

# We only support GB and de locales
find $repackagedir/share/locale -mindepth 1 -maxdepth 1 -type d ! -name "en_GB" ! -name "de" -exec rm -rf {} \;

echo "Copying vips executables"

# We still need to copy the vips executables
cp $installdir/bin/{vips,vipsedit,vipsheader,vipsthumbnail}.exe $repackagedir/bin/
cp $installdir/bin/vipsprofile $repackagedir/bin/

echo "Strip unneeded symbols"

# Remove all symbols that are not needed
strip --strip-unneeded $repackagedir/bin/*.exe
strip --strip-unneeded $repackagedir/bin/*.dll

echo "Copying packaging files"

cp $basedir/$checkoutdir/$vips_package-$vips_version.$vips_minor_version/{AUTHORS,ChangeLog,COPYING,README.md} $repackagedir

echo "Creating $zipfile"

zipfile=$vips_package-dev-w64-$deps-$vips_version.$vips_minor_version.zip
rm -f $zipfile
zip -r -qq $zipfile $repackagedir
