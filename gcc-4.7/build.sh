ln -s $PREFIX/lib $PREFIX/lib64

# handle building 32bit on 64bit host
# https://gcc.gnu.org/ml/gcc-help/2010-09/msg00040.html

extra_configure=""

if [[ "$ARCH" == "32" && "$(uname -m)" == "x86_64" ]]; then
    export CC="gcc -m32"
    export CXX="g++ -m32"
    extra_configure="--build=i686-linux-gnu --host=i686-linux-gnu --target=i686-linux-gnu"
fi

./configure \
    --prefix=$PREFIX \
    --libdir=$PREFIX/lib \
    --with-gmp=$PREFIX \
    --with-mpfr=$PREFIX \
    --with-mpc=$PREFIX \
    --with-ppl=$PREFIX \
    --enable-languages=c,c++,fortran \
    --disable-multilib $extra_configure

nice make -j16
make install
rm $PREFIX/lib64
