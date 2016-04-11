#!/bin/bash

. variables.sh

./clean.sh

for i in $packagedir/*.zip ; do
	echo installing $i
	( cd $installdir ; unzip -o -qq ../$i )
done

# openjpeg2.1 does not install a .pc file ... copy one in ourselves
echo installing libopenjp2.pc
cp libopenjp2.pc inst/lib/pkgconfig
