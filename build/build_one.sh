#!/bin/bash

PLATFORM=$1;
if [ ! $1 ]; then
    PLATFORM="darwin";
fi
echo "Platform = ${PLATFORM}"

ARCH=$2;
if [ ! $2 ]; then
    ARCH="arm64";
fi
echo "Arch = ${ARCH}"

ICON="materials/icon/appicon-osx.icns"
if [ ${PLATFORM} = "win32" ] ; then
    ICON="materials/icon/appicon-win.ico"
fi
echo "Icon = ${ICON}"

OSXOPTIONS="";
if [ ${PLATFORM} = "darwin" ] ; then
    if [ -e "./apple_team.plist" ] ; then
        OSXOPTIONS="--extend-info='./apple_team.plist' --osx-sign";
    fi
fi

node_modules/.bin/electron-packager . \
    --platform=${PLATFORM} \
    --arch=${ARCH} \
    --icon=${ICON} \
    --overwrite \
    --out="build/tmp/" \
    ${OSXOPTIONS} \
    --ignore="^/(\.gitignore|\.gitmodules|materials|apple_[a-zA-Z0-9]+\.(json|txt|plist)|build|tests|README.md)" \
    ;
exit;
