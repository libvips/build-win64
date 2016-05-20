#!/bin/bash

. variables.sh

# set -x

repackagedir=$nip2_package-$nip2_version

echo copying install area $installdir

rm -rf $repackagedir
cp -r $installdir $repackagedir

echo cleaning build $repackagedir

# rename all the -animate.exe etc. without the prefix
( cd $repackagedir/bin ; for i in $mingw_prefix*; do mv $i `echo $i | sed s/$mingw_prefix//`; done )

( cd $repackagedir/bin ; \
	mkdir ../poop ; \
	mv *nip2* ../poop ; \
	mv *.dll ../poop ; \
	mv convert.exe ../poop ; \
	mv gspawn*.exe ../poop ; \
	rm -f * ; \
	mv ../poop/* . ; \
	rmdir ../poop )

( cd $repackagedir/bin ; rm -f libvipsCC*.dll )

( cd $repackagedir/bin ; strip --strip-unneeded *.exe )

# for some reason we can't strip zlib1
( cd $repackagedir/bin ; mkdir ../poop ; mv zlib1.dll ../poop ; strip --strip-unneeded *.dll ; mv ../poop/zlib1.dll . ; rmdir ../poop )

( cd $repackagedir/share ; rm -rf aclocal applications glib-2.0 gtk-2.0 gtk-doc ImageMagick-* info jhbuild man mime pixmaps xml goffice)

( cd $repackagedir/share/doc ; mkdir ../poop ; mv nip2 ../poop ; rm -rf * ; mv ../poop/nip2 . ; rmdir ../poop )

( cd $repackagedir/share/doc/nip2 ; rm -rf pdf )

# we only support GB and de locales in nip2
( cd $repackagedir/share/locale ; mkdir ../poop ; mv en_GB de ../poop ; rm -rf * ; mv ../poop/* . ; rmdir ../poop )

( cd $repackagedir ; rm -rf include )

# we need some lib stuff at runtime for goffice and the theme
( cd $repackagedir/lib ; mkdir ../poop ; mv goffice gtk-2.0 ../poop ; rm -rf * ; mv ../poop/* . ; rmdir ../poop )

# we don't need a lot of it though
( cd $repackagedir/lib/goffice ; find . -name "*.la" -exec rm {} \; )
( cd $repackagedir/lib/goffice ; find . -name "*.a" -exec rm {} \; )
( cd $repackagedir/lib/goffice ; find . -name "*.ui" -exec rm {} \; )

( cd $repackagedir/lib/goffice ; find . -name "*.dll" -exec strip --strip-unneeded {} \; )

( cd $repackagedir/lib/gtk-2.0 ; find . -name "*.la" -exec rm {} \; )
( cd $repackagedir/lib/gtk-2.0 ; find . -name "*.a" -exec rm {} \; )
( cd $repackagedir/lib/gtk-2.0 ; find . -name "*.h" -exec rm {} \; )

( cd $repackagedir ; rm -rf make )

( cd $repackagedir ; rm -rf man )

( cd $repackagedir ; rm -rf manifest )

( cd $repackagedir ; rm -rf src )

# we need to copy the C++ runtime dlls in there
gccmingwlibdir=/usr/lib/gcc/x86_64-w64-mingw32/*-win32
cp $gccmingwlibdir/*.dll $repackagedir/bin

# turn on the theme
cat > $repackagedir/etc/gtk-2.0/gtkrc <<EOF
gtk-theme-name = "Clearlooks"
EOF

echo creating $nip2_package-$nip2_version.zip
rm -f $nip2_package-$nip2_version.zip
zip -r -qq $nip2_package-$nip2_version.zip $nip2_package-$nip2_version

# have to make in a subdir to make sure makensis does not grab other stuff
echo building installer nsis/$nip2_package-$nip2_version-setup.exe
( cd nsis ; rm -rf $nip2_package-$nip2_version ; unzip -qq -o ../$nip2_package-$nip2_version.zip ;
makensis -DVERSION=$nip2_version $nip2_package.nsi > makensis.log )
