#!/bin/bash

chmod +x configure

# build for 32bit if using 32bit conda
export ABI=$ARCH

./configure --prefix=$PREFIX --enable-cxx

make
make check
make install
