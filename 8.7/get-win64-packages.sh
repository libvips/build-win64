#!/bin/bash

. variables.sh

mkdir -p $installdir
mkdir -p $packagedir
mkdir -p $checkoutdir

while read PACKAGE; do
  if [[ $PACKAGE =~ [^/]*$ ]]; then
    NAME=$BASH_REMATCH

    # see if we need to download the package.
    if [ ! -e "$packagedir/$NAME" ]; then
	  echo "fetching $NAME ..."
      ( cd $packagedir ; \
          wget ftp://ftp.gnome.org/pub/GNOME/binaries/win64/$PACKAGE )
    fi
  else
    echo "I don't know what to do with $PACKAGE as it doesn't match anything I am looking for."
  fi
done << EOF
dependencies/zlib_1.2.5-1_win64.zip
dependencies/zlib-dev_1.2.5-1_win64.zip 
EOF

