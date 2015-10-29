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
dependencies/expat_2.0.1-3_win64.zip
dependencies/expat-dev_2.0.1-3_win64.zip
dependencies/fontconfig_2.8.0-2_win64.zip
dependencies/fontconfig-dev_2.8.0-2_win64.zip
dependencies/freetype_2.4.4-1_win64.zip
dependencies/freetype-dev_2.4.4-1_win64.zip
dependencies/gettext-runtime-dev_0.18.1.1-2_win64.zip
dependencies/gettext-runtime_0.18.1.1-2_win64.zip
dependencies/libpng_1.4.3-1_win64.zip
dependencies/libpng-dev_1.4.3-1_win64.zip
dependencies/libxml2_2.7.7-1_win64.zip
dependencies/libxml2-dev_2.7.7-1_win64.zip
dependencies/win-iconv-dev_tml-20100912_win64.zip
dependencies/zlib_1.2.5-1_win64.zip
dependencies/zlib-dev_1.2.5-1_win64.zip 
EOF
