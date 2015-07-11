#!/bin/bash

CONFIG_OPTS=" "

if [ `uname` == Linux ]; then
    MAKE_JOBS=$CPU_COUNT
fi

if [ `uname` == Darwin ]; then
    MAKE_JOBS=$(sysctl -n hw.ncpu)
fi

chmod +x configure
./configure -prefix $PREFIX \
            $CONFIG_OPTS

nice make -j $MAKE_JOBS
make install
