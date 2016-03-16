#! /bin/bash
# Copyright 2014-2016 Peter Williams and collaborators.
# This file is licensed under a 3-clause BSD license; see LICENSE.txt.

set -e

if [ -n "$OSX_ARCH" ] ; then
    # Not actually sure if these even take effect, but for consistency let's
    # do it anyway.
    export MACOSX_DEPLOYMENT_TARGET=10.6
    sdk=/
    export CFLAGS="$CFLAGS -isysroot $sdk"
    export LDFLAGS="$LDFLAGS -Wl,-syslibroot,$sdk"
fi

./configure.py --bootstrap

cp -p ninja $PREFIX/bin/ninja
