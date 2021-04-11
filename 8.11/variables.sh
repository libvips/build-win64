# included by all scripts .. edit versions here, and in vips.modules

nip2_package=nip2
nip2_version=8.6

vips_package=vips
vips_version=8.11
vips_minor_version=0

# build-win32/x.xx dir we are building
basedir=$(pwd)

# download zips to here
packagedir=packages

# unzip to here
installdir=inst

# jhbuild will download sources to here 
checkoutdir=checkout

# do out of tree builds here
builddir=build

mingw_prefix=x86_64-w64-mingw32-

repackagedir=$vips_package-dev-$vips_version
