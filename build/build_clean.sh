#!/bin/bash

TMP_DIR_PREFIX="_tmp_build_px2dt_";
TMP_DIR_NAME=$(date '+%Y%m%d_%H%M%S');
CURRENT_DIR=$(pwd);
REPOSITORY_URL="https://github.com/tomk79/app-pickles2-corn.git";
APPLE_IDENTITY='';
APPLE_CODESIGN_JSON='';

while getopts s:i: OPT
do
    case $OPT in
        "i" )
            APPLE_IDENTITY="$OPTARG";
            ;;
        "s" )
            APPLE_CODESIGN_JSON="$OPTARG";
            ;;
    esac
done
shift `expr $OPTIND - 1`

BRANCH_NAME=$1;
if [ ! $1 ]; then
    BRANCH_NAME="develop";
fi

echo "-------------------------";
echo "Build Start!";
echo "Current Dir = ${CURRENT_DIR}"
echo "Temporary Dir = ~/${TMP_DIR_PREFIX}${TMP_DIR_NAME}/"
echo "Repository = ${REPOSITORY_URL}"
echo "Branch Name = ${BRANCH_NAME}"
if [ $APPLE_IDENTITY ]; then
    echo "Apple IDENTITY = ${APPLE_IDENTITY}"
fi
if [ $APPLE_CODESIGN_JSON ]; then
    echo "apple_codesign.json = ${APPLE_CODESIGN_JSON}"
fi
echo $(date '+%Y/%m/%d %H:%M:%S');

sleep 1s; echo ""; echo "=-=-=-=-=-=-=-=-=-= making build directory";
mkdir ~/${TMP_DIR_PREFIX}${TMP_DIR_NAME};
cd ~/${TMP_DIR_PREFIX}${TMP_DIR_NAME}/;
pwd

sleep 1s; echo ""; echo "=-=-=-=-=-=-=-=-=-= git clone";
git clone --depth 1 -b ${BRANCH_NAME} ${REPOSITORY_URL} ./;

if [ $APPLE_CODESIGN_JSON ]; then
    sleep 1s; echo ""; echo "=-=-=-=-=-=-=-=-=-= copying apple_codesign.json";
    cd ${CURRENT_DIR};
    echo ""; 
    echo "cd $(pwd);"
    cp -v ${APPLE_CODESIGN_JSON} ~/${TMP_DIR_PREFIX}${TMP_DIR_NAME}/apple_codesign.json;
    cd ~/${TMP_DIR_PREFIX}${TMP_DIR_NAME}/;
    echo "cd $(pwd);"
fi

sleep 1s; echo ""; echo "=-=-=-=-=-=-=-=-=-= npm install";
npm install;

if [ $APPLE_IDENTITY ]; then
    sleep 1s; echo ""; echo "=-=-=-=-=-=-=-=-=-= Saving Apple IDENTITY";
    echo "${APPLE_IDENTITY}";
    echo ${APPLE_IDENTITY} > ~/${TMP_DIR_PREFIX}${TMP_DIR_NAME}/apple_identity.txt
    sleep 1s; echo "";
fi

sleep 1s; echo ""; echo "=-=-=-=-=-=-=-=-=-= npm run build";

npm run build-darwin-arm64;
ditto -ck --rsrc --sequesterRsrc "./Pickles 2 corn-darwin-arm64" "./build/dist/Pickles 2 corn-darwin-arm64.zip"
rm -r "./Pickles 2 corn-darwin-arm64"
sleep 1s; echo "";

npm run build-darwin-x64;
ditto -ck --rsrc --sequesterRsrc "./Pickles 2 corn-darwin-x64" "./build/dist/Pickles 2 corn-darwin-x64.zip"
rm -r "./Pickles 2 corn-darwin-x64"
sleep 1s; echo "";

npm run build-win32-x64;
zip -q -y -r "./build/dist/Pickles 2 corn-win32-x64.zip" "./Pickles 2 corn-win32-x64"
rm -r "./Pickles 2 corn-win32-x64"
sleep 1s; echo "";

npm run build-linux-x64;
zip -q -y -r "./build/dist/Pickles 2 corn-linux-x64.zip" "./Pickles 2 corn-linux-x64"
rm -r "./Pickles 2 corn-linux-x64"
sleep 1s; echo "";

sleep 1s; echo "";
sleep 1s; echo "";
sleep 1s; echo "";
echo "-------------------------";
echo "build completed!";
pwd
echo $(date '+%Y/%m/%d %H:%M:%S');
echo "-------------------------";
exit;
