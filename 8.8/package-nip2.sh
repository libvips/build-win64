#!/bin/bash

# set -x
set -e

. variables.sh

# eg. nip2-8.8.1
fullname=$nip2_package-$nip2_version.$nip2_minor_version

repackagedir=$fullname
mingw_prefix=i686-pc-mingw32-

# Make sure that the repackaging dir is empty
rm -rf $repackagedir
mkdir -p $repackagedir/bin

copy_exe() {
  name="$1"

  echo "Copying $name and dependencies ..."

  # Copy thing plus dependencies with pe-util
  /usr/local/bin/peldd \
    $installdir/bin/$name \
    --clear-path \
    --path $installdir/bin \
    --path /usr/lib/gcc/x86_64-w64-mingw32/*-win32 \
    --path /usr/x86_64-w64-mingw32/lib/ \
    -a \
    -w USERENV.dll \
    -w USP10.dll \
    -w DNSAPI.dll \
    -w IPHLPAPI.DLL \
    -w MSIMG32.DLL | xargs cp -t $repackagedir/bin
}

copy_exe nip2.exe
copy_exe nip2-cli.exe
copy_exe x86_64-w64-mingw32-convert.exe
copy_exe gspawn-win64-helper-console.exe
copy_exe gspawn-win64-helper.exe

# strip the silly exe prefix
mv $repackagedir/bin/x86_64-w64-mingw32-convert.exe \
  $repackagedir/bin/convert.exe 

# Follow symlinks when copying /share and /etc
cp -Lr $installdir/{share,etc} $repackagedir

# clean up share
rm -rf $repackagedir/share/aclocal
rm -rf $repackagedir/share/bash-completion
rm -rf $repackagedir/share/doc
rm -rf $repackagedir/share/info
rm -rf $repackagedir/share/installed-tests
rm -rf $repackagedir/share/man
rm -rf $repackagedir/share/thumbnailers
rm -rf $repackagedir/share/xml
rm -rf $repackagedir/share/gettext
# we don't yet build the nip2 manual in the container, so remove everything
rm -rf $repackagedir/share/gtk-doc

# we need some lib stuff at runtime for goffice and the theme
mkdir -p $repackagedir/lib
cp -r $installdir/lib/goffice $repackagedir/lib
cp -r $installdir/lib/gtk-2.0 $repackagedir/lib

# we don't need a lot of it though
find $repackagedir/lib/goffice \
  \( -name "*.a" -or -name "*.ui" \) -exec rm {} \; 
find $repackagedir/lib/gtk-2.0 \
  \( -name "*.a" -or -name "*.h" \) -exec rm {} \; 

find $repackagedir/lib -name "*.dll" -exec strip --strip-unneeded {} \;

# We only support GB and de locales
find $repackagedir/share/locale -mindepth 1 -maxdepth 1 -type d ! -name "en_GB" ! -name "de" -exec rm -rf {} \;

# Remove all symbols that are not needed
strip --strip-unneeded $repackagedir/bin/*.exe
strip --strip-unneeded $repackagedir/bin/*.dll

echo "Copying packaging files ..."

cp $basedir/$checkoutdir/$vips_package-$vips_version.$vips_minor_version/{AUTHORS,ChangeLog,COPYING,README.md} $repackagedir

# turn on the theme
cat > $repackagedir/etc/gtk-2.0/gtkrc <<EOF
gtk-theme-name = "Clearlooks"
EOF

# have to make in a subdir to make sure makensis does not grab other stuff
echo "Building installer nsis/$fullname-setup.exe ..."
( cd nsis \
    && rm -rf $fullname \
    && cp -r ../$fullname . \
    && makensis -DVERSION=$nip2_version.$nip2_minor_version $nip2_package.nsi > makensis.log )

# and zip up the exe so people can download it
echo "Zipping installer as $fullname-setup.zip ..."
( cd nsis \
    && zip -r -qq ../$fullname-setup.zip $fullname-setup.exe )

echo done
