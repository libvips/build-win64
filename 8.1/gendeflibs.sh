#!/bin/bash

# this script makes .def and .lib files for all the dlls we've built

. variables.sh
dlltool=${mingw_prefix}dlltool

# set -x

cd $repackagedir

for dllfile in bin/*.dll; do
	base=$(basename $dllfile .dll)

	# dll names can have extra versioning in ... remove any trailing
	# "-\d+" pattern
	pure=$base
	if [[ $pure =~ (.*)-[0-9]+$ ]]; then
		pure=${BASH_REMATCH[1]}
	fi

	defname=$pure.def
	libname=$pure.lib

	if [ ! -f lib/$defname ]; then
		echo generating lib/$defname file for $base
		gendef - $dllfile > lib/$defname
	fi

	if [ ! -f lib/$libname ]; then
		echo generating lib/$libname file for $base
		$dlltool -d lib/$defname -l lib/$libname -D $dllfile
	fi
done



