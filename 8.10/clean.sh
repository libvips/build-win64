#!/usr/bin/env bash

. variables.sh

echo "Wiping install area $installdir"
rm -rf $installdir
mkdir $installdir

echo "Cleaning checkout area $checkoutdir"
for i in $checkoutdir/*; do
  if [ -d $i ]; then
    rm -rf $i
  fi
done

echo "Cleaning build area $builddir"
for i in $builddir/*; do
  if [ -d $i ]; then
    rm -rf $i
  fi
done

echo "Cleaning misc files"

rm -f $basedir/*.zip
rm -f $basedir/*.exe

rm -rf $vips_package-$vips_version
rm -rf $nip2_package-$nip2_version

rm -rf nsis/$nip2_package-$nip2_version
rm -f nsis/$nip2_package-$nip2_version-setup.exe
rm -f nsis/$nip2_package-$nip2_version-setup.zip
rm -f nsis/makensis.log

rm -rf $basedir/$vips_package-dev-$vips_version

rm -rf .cache
