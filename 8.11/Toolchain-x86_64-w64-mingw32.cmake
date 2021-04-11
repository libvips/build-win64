## general configuration
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86_64 CACHE STRING "System Processor")
set(MSYS 1)
set(CMAKE_EXPORT_NO_PACKAGE_REGISTRY ON)

## library config
set(BUILD_SHARED_LIBS ON CACHE BOOL "BUILD_SHARED_LIBS")
set(BUILD_STATIC_LIBS OFF CACHE BOOL "BUILD_STATIC_LIBS")
set(BUILD_SHARED ON CACHE BOOL "BUILD_SHARED")
set(BUILD_STATIC OFF CACHE BOOL "BUILD_STATIC")
set(LIBTYPE SHARED)

## programs
if(NOT CMAKE_C_COMPILER)
  set(CMAKE_C_COMPILER x86_64-w64-mingw32-gcc)
endif()

if(NOT CMAKE_CXX_COMPILER)
  set(CMAKE_CXX_COMPILER x86_64-w64-mingw32-g++)
endif()

set(CMAKE_RC_COMPILER x86_64-w64-mingw32-windres)
# Don't set the following variables in our toolchain,
# because it will break the cfitsio/harfbuzz build, see:
# https://cmake.org/pipermail/cmake/2010-March/035540.html
# SET(CMAKE_AR x86_64-w64-mingw32-ar)
# SET(CMAKE_RANLIB x86_64-w64-mingw32-ranlib)

# target environment location
set(CMAKE_FIND_ROOT_PATH /data/inst CACHE PATH "List of root paths to search on the filesystem")
set(CMAKE_PREFIX_PATH /data/inst CACHE PATH "List of directories specifying installation prefixes to be searched")
set(CMAKE_INSTALL_PREFIX /data/inst CACHE PATH "Installation Prefix")

# adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search 
# programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
