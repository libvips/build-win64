#!/bin/bash

. variables.sh

./clean.sh

for i in $packagedir/*.zip ; do
	echo installing $i
	( cd $installdir ; unzip -o -qq ../$i )
done

# strange, jhbuild refuses to work without this old pc file in there .. this
# file is overwritten later during fontconfig install
mkdir $installdir/lib/pkgconfig
cp fontconfig.pc $installdir/lib/pkgconfig
