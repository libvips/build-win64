#!/bin/bash

. variables.sh

# set -x

echo copying install area $installdir

rm -rf $repackagedir
cp -r $installdir $repackagedir

# some mingws will write some libs to lib64, strangely
if [ -d $repackagedir/lib64 ]; then
	cp -r $repackagedir/lib64/* $repackagedir/lib
	rm -rf $repackagedir/lib64
fi

echo generating import files 

./gendeflibs.sh

echo cleaning build $repackagedir

( cd $repackagedir ; rm -rf _jhbuild )

# clean /bin 
( cd $repackagedir/bin ; mkdir ../poop ; mv *vips* ../poop ; mv *.dll ../poop ; rm -f * ; mv ../poop/* . ; rmdir ../poop )

( cd $repackagedir/bin ; rm -f vips-8.* )

# no need for this
rm $repackagedir/bin/vipsprofile

( cd $repackagedir/bin ; strip --strip-unneeded *.exe )

# we only want dynamic libs, so get rid of everything that is not .dll.a
( cd $repackagedir/lib ; mkdir ../poop ; mv *.dll.a ../poop ; rm *.a ; mv ../poop/* . ; rmdir ../poop )

# libvips does not distribute cmake files
rm -rf $repackagedir/lib/cmake
rm -rf $repackagedir/lib/openjpeg-*

# lib gettext is only for maintenance
rm -rf $repackagedir/lib/gettext

rm $repackagedir/lib/xml2Conf.sh

( cd $repackagedir/share ; rm -rf aclocal glib-2.0 gtk-2.0 info jhbuild man xml themes doc bash-completion gdb gettext* thumbnailers )

( cd $repackagedir/share/gtk-doc/html ; rm -rf * )

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

for i in COPYING ChangeLog README.md AUTHORS; do 
  cp $checkoutdir/vips-$vips_version.$vips_micro_version/$i $repackagedir 
done

# ... and test we startup OK
echo -n "testing build ... "
wine $repackagedir/bin/vips.exe --help > /dev/null
if [ "$?" -ne "0" ]; then
  echo WARNING: vips.exe failed to run
else
  echo ok
fi

zipfile=$vips_package-dev-w64-$DEPS-$vips_version.$vips_micro_version.zip
echo creating $zipfile
rm -f $zipfile
zip -r -qq $zipfile $repackagedir
