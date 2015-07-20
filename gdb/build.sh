
extra_configure=""

if [[ "$ARCH" == "32" && "$(uname -m)" == "x86_64" ]]; then
    export CC="gcc -m32"
    export CXX="g++ -m32"
    extra_configure="--build=i686-linux-gnu --host=i686-linux-gnu --target=i686-linux-gnu"
fi

./configure \
    -prefix=$PREFIX \
    --with-relocated-sources=$PREFIX/src \
    --enable-tui \
    --with-expat \
    --with-system-readline \
    --with-gdbtk \
    $extra_configure

nice make -j$CPU_COUNT --load-average=$CPU_COUNT
nice make -j$CPU_COUNT --load-average=$CPU_COUNT check-gdb
nice make -C gdb/doc gdb.pdf
make install
