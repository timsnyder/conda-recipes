./configure \
    --prefix=$PREFIX \
    --with-gmp=$PREFIX \
    --with-mpfr=$PREFIX \
    --with-mpc=$PREFIX \
    --with-ppl=$PREFIX \
    --enable-languages=c,c++,fortran

nice make -j16
make install
