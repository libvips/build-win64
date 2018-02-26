#!/bin/bash

. variables.sh

./clean.sh

# no longer used
# for i in $packagedir/*.zip ; do
# 	echo installing $i
# 	( cd $installdir ; unzip -o -qq ../$i )
# done

# strange, jhbuild refuses to work without this old pc file in there .. this
# file is overwritten later during fontconfig install
mkdir -p $installdir/lib/pkgconfig
cp fontconfig.pc $installdir/lib/pkgconfig
