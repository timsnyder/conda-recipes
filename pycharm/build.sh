#!/bin/bash

VER=$PKG_VERSION

# Install extracted files to lib dir and create a link in bin
mkdir -pv ${PREFIX}/lib
mkdir -pv ${PREFIX}/bin
pushd ../
cp -r pycharm-community-${VER} ${PREFIX}/lib
popd

pushd ${PREFIX}
ln -sv ../lib/pycharm-community-${VER}/bin/pycharm.sh bin/pycharm
popd
