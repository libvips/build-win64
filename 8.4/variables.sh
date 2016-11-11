# included by all scripts .. edit versions here, and in vips.modules

nip2_package=nip2
nip2_version=8.4

vips_package=vips
vips_version=8.4
vips_minor_version=4

# build-win32/x.xx dir we are building
basedir=$(pwd)

# download zips to here
packagedir=packages

# unzip to here
installdir=inst

# jhbuild will download sources to here 
checkoutdir=checkout

mingw_prefix=x86_64-w64-mingw32-

repackagedir=$vips_package-dev-$vips_version

# we need a native linux install to pull the typelib from
# if VIPSHOME is defined, take that, otherwise we're probaly a containerized
# build, look for it here
if [ $VIPSHOME ]; then
	linux_install="$VIPSHOME"
else
	linux_install=$basedir/vips
fi
