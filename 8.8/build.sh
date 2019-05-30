#!/bin/bash

# exit on error
set -e

if [ $# -lt 1 ]; then
  echo "Usage: $0 TARGET [VARIANT]"
  echo "Build jhbuild TARGET for win, eg.:"
  echo "    $0 libvips web"
  exit 1
fi

target="${1}"
variant="${2:all}"

. variables.sh

./clean.sh \
   && jhbuild --file=jhbuildrc build --nodeps $target-$variant \
   && ./package-$target.sh $variant
