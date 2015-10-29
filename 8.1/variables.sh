# included by all scripts .. edit versions here, and in vips.modules

nip2_package=nip2
nip2_version=8.0

vips_package=vips
vips_version=8.1.1

# build-win32/x.xx dir we are building
basedir=$(pwd)

# download zips to here
packagedir=packages

# unzip to here
installdir=inst

# jhbuild will download sources to here 
checkoutdir=checkout

# need a linux vips install here to get cross-platform build results from
linux_install=~/vips
