#!/bin/bash

chmod +x configure

# build for 32bit if using 32bit conda
export ABI=$ARCH

if [ `uname` == Darwin ]; then
    ./configure --prefix=$PREFIX --enable-cxx
else
    ./configure --prefix=$PREFIX
fi

make
make check
make install
