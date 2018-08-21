#!/bin/bash

# set -x
set -e

if [ $# -lt 1 ]; then
  echo "Usage: $0 [DEPS]"
  echo "Build libvips for win"
  echo "DEPS is the group of dependencies to build libvips with,"
  echo "    defaults to 'all'"
  exit 1
fi

. variables.sh

deps="${1:-all}"

echo copying install area $installdir

rm -rf $repackagedir
cp -r $installdir $repackagedir

echo generating import files 

./gendeflibs.sh

echo cleaning build $repackagedir

( cd $repackagedir ; rm -rf _jhbuild )

for i in COPYING ChangeLog README.md AUTHORS; do 
  ( cp $basedir/$checkoutdir/$vips_version.$vips_minor_version/$i $repackagedir )
done

# clean /bin 
( cd $repackagedir/bin ; mkdir ../poop ; mv *vips* ../poop ; mv *.dll ../poop ; rm -f * ; mv ../poop/* . ; rmdir ../poop )

( cd $repackagedir/bin ; rm -f vips-8.* )

( cd $repackagedir/bin ; strip --strip-unneeded *.exe )

( cd $repackagedir/bin ; strip --strip-unneeded *.dll )

( cd $repackagedir/share ; rm -rf aclocal glib-2.0 gtk-2.0 info jhbuild man xml themes )

( cd $repackagedir/share/gtk-doc/html ; mkdir ../poop ; mv libvips ../poop ; rm -rf * ; mv ../poop/* . ; rmdir ../poop )

# we only support GB and de locales 
( cd $repackagedir/share/locale ; mkdir ../poop ; mv en_GB de ../poop ; rm -rf * ; mv ../poop/* . ; rmdir ../poop )
( cd $repackagedir/share/locale ; find . -name "gtk*.mo" -exec rm {} \; )
( cd $repackagedir/share/locale ; find . -name "atk*.mo" -exec rm {} \; )

( cd $repackagedir/include ; rm -rf atk-1.0 cairo gtk-2.0 libglade-2.0 ) 

( cd $repackagedir ; rm -rf make man manifest src )

( cd $repackagedir/etc ; rm -rf gtk-2.0 gconf )

( cd $repackagedir/lib ; rm -rf *atk* *cairo* *gdk* *gtk*  )
( cd $repackagedir/lib ; find . -name "*.la" -exec rm {} \; )

# we need to copy the C++ runtime dlls in there
gccmingwlibdir=/usr/lib/gcc/x86_64-w64-mingw32/*-win32
cp $gccmingwlibdir/*.dll $repackagedir/bin

# don't need these two
( cd $repackagedir/bin ; rm -f libgomp*.dll )
( cd $repackagedir/bin ; rm -f libgfortran*.dll )

zipfile=$vips_package-dev-w64-$deps-$vips_version.$vips_minor_version.zip
echo creating $zipfile
rm -f $zipfile
zip -r -qq $zipfile $repackagedir
