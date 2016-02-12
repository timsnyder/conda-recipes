#!/bin/sh

# features=big required for multibyte char editing support

./configure --prefix=$PREFIX    \
            --enable-gui=gtk2 \
            --enable-cscope     \
            --enable-pythoninterp=yes \
            --enable-perlinterp=yes \
            --with-features=big \
            --enable-fail-if-missing


make
make install



# vim:set ts=8 sw=4 sts=4 tw=78 et:
