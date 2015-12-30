#!/bin/bash

. variables.sh

./clean.sh

for i in $packagedir/*.zip ; do
	echo installing $i
	( cd $installdir ; unzip -o -qq ../$i )
done

