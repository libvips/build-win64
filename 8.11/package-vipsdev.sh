#!/usr/bin/env bash

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

# We need a POSIX-compliant libstdc++-6.dll,
# if we build anything but the -web flavour. Poppler,
# OpenEXR and libde265 needs a libstdc++
# with <thread> and <mutex> functionality.
if [ "$deps" != "web" ]; then
  threads=posix
else
  threads=win32
fi

# Copy libvips and dependencies with pe-util
/usr/local/bin/peldd \
  $installdir/bin/libvips-cpp-42.dll \
  --clear-path \
  --path $installdir/bin \
  --path /usr/lib/gcc/x86_64-w64-mingw32/*-$threads \
  --path /usr/x86_64-w64-mingw32/lib/ \
  -a \
  -w USERENV.dll \
  -w USP10.dll \
  -w DNSAPI.dll \
  -w IPHLPAPI.DLL \
  -w MSIMG32.DLL | xargs cp -t $repackagedir/bin

echo "Copying install area $installdir"

# Follow symlinks when copying /share, /etc, /lib and /include
cp -Lr $installdir/{share,etc,lib,include} $repackagedir

echo "Generating import files"

./gendeflibs.sh

echo "Cleaning unnecessary files / directories"

# TODO Do we need to keep /share/doc and /share/gtk-doc?
rm -rf $repackagedir/share/{aclocal,bash-completion,doc,glib-2.0,gtk-2.0,info,gtk-doc,installed-tests,man,thumbnailers,xml}

rm -rf $repackagedir/include/cairo

rm -rf $repackagedir/lib/{*cairo*,*gdk*,ldscripts}
find $repackagedir/lib -name "*.la" -exec rm -f {} \;

# We intentionally disabled the i18n features of (GNU) gettext,
# so the locales are not needed.
rm -rf $repackagedir/share/locale

echo "Copying vips executables"

# We still need to copy the vips executables
cp $installdir/bin/{vips,vipsedit,vipsheader,vipsthumbnail}.exe $repackagedir/bin/
cp $installdir/bin/vipsprofile $repackagedir/bin/

echo "Strip unneeded symbols"

# Remove all symbols that are not needed
strip --strip-unneeded $repackagedir/bin/*.{exe,dll}

echo "Copying packaging files"

cp $basedir/$checkoutdir/$vips_package-$vips_version.$vips_minor_version/{AUTHORS,ChangeLog,COPYING,README.md} $repackagedir

zipfile=$vips_package-dev-w64-$deps-$vips_version.$vips_minor_version.zip
echo "Creating $zipfile"
rm -f $zipfile
zip -r -qq $zipfile $repackagedir
