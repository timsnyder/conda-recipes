set -xe

# handle building 32bit on 64bit host
# https://gcc.gnu.org/ml/gcc-help/2010-09/msg00040.html

extra_configure=""

if [[ "$ARCH" == "32" && "$(uname -m)" == "x86_64" ]]; then
    export CC="gcc -m32"
    export CXX="g++ -m32"
    extra_configure="--build=i686-linux-gnu --host=i686-linux-gnu --target=i686-linux-gnu"
fi

./configure --prefix="$PREFIX" "${extra_configure}" \
            CPPFLAGS="-I$PREFIX/include" \
            LDFLAGS="-L$PREFIX/lib"


# Couldn't get the --with-<lib>-prefix options to work
# and resorted to setting CCFLAGS as well as LDFLAGS
# conda is going to set rpaths anyway, so we should be good




nice make -j$(getconf _NPROCESSORS_ONLN)
make install

