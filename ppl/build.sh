
# handle building 32bit on 64bit host
# https://gcc.gnu.org/ml/gcc-help/2010-09/msg00040.html
if [[ "$ARCH" == "32" && "$(uname -m)" == "x86_64" ]]; then
    export CC="gcc -m32"
    export CXX="g++ -m32"
    echo -n "Using gcc:"
    which gcc
fi

./configure --prefix=$PREFIX --with-gmp-prefix=$PREFIX
make
make install
