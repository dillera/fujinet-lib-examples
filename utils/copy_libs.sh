#!/bin/bash
#
# copies local dev version of fujinet-lib into _libs
# The default behaviour is to copy the version specified in makefiles/fujinet-lib.mk, but values can be overridden by specifying before the command
# e.g.
#
# FUJINET_LIB_VERSION=4.2.1 PLATFORMS=c64 ./copy_libs.sh
#
# Requires FUJI_LIB_DIR to be the path to your fujinet-lib src directory

THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ifeq ($(wildcard $(FUJI_LIB_DIR)),)
$(error You must have FUJI_LIB_DIR set to the location of fujinet-libs repo)
endif

PLATFORMS=${PLATFORMS:-"c64 atari apple2 apple2enh"}
VERSION=${FUJINET_LIB_VERSION:-$(grep '^FUJINET_LIB_VERSION :=' ${THIS_DIR}/makefiles/fujinet-lib.mk | awk '{print $3}')}

LIBS_DIR=_libs

mkdir ${THIS_DIR}/${LIBS_DIR} > /dev/null 2>&1

for platform in ${PLATFORMS}; do
  ZIP_FILE=${FUJI_LIB_DIR}/dist/fujinet-lib-${platform}-${VERSION}.zip

  if [ ! -f ${ZIP_FILE} ]; then
    echo "Couldn't find $ZIP_FILE"
    exit 1
  fi

  cp ${ZIP_FILE} ${THIS_DIR}/${LIBS_DIR}
  rm -rf ${THIS_DIR}/${LIBS_DIR}/${VERSION}-${platform}
  unzip ${ZIP_FILE} -d ${THIS_DIR}/${LIBS_DIR}/${VERSION}-${platform}
done
