#!/usr/bin/env bash

# this script makes .def and .lib files for all the dlls we've built

. variables.sh
dlltool=${mingw_prefix}dlltool

# set -x
set -e

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
    echo "Generating lib/$defname file for $base"
    gendef - $dllfile > lib/$defname 2> /dev/null
  fi

  if [ ! -f lib/$libname ]; then
    echo "Generating lib/$libname file for $base"
    $dlltool -d lib/$defname -l lib/$libname -D $dllfile 2> /dev/null
  fi
done
