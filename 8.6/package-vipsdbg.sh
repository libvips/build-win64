#!/bin/bash

. variables.sh

repackagedir=$vips_package-dbg-$vips_version

# set -x

echo copying install area $installdir

rm -rf $repackagedir
cp -r $installdir $repackagedir

# some mingws will write some libs to lib64, strangely
if [ -d $repackagedir/lib64 ]; then
	cp -r $repackagedir/lib64/* $repackagedir/lib
	rm -rf $repackagedir/lib64
fi

echo generating import files 

./gendeflibs.sh

# we need to copy the C++ runtime dlls in there
gccmingwlibdir=/usr/lib/gcc/x86_64-w64-mingw32/*-win32
cp $gccmingwlibdir/*.dll $repackagedir/bin

for i in COPYING ChangeLog README.md AUTHORS; do 
  cp $checkoutdir/vips-$vips_version.$vips_micro_version/$i $repackagedir 
done

# ... and test we startup OK
echo -n "testing build ... "
wine $repackagedir/bin/vips.exe --help > /dev/null
if [ "$?" -ne "0" ]; then
  echo WARNING: vips.exe failed to run
else
  echo ok
fi

zipfile=$vips_package-dbg-w64-$DEPS-$vips_version.$vips_micro_version.zip
echo creating $zipfile
rm -f $zipfile
zip -r -qq $zipfile $repackagedir
