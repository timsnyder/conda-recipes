mkdir build && cd build

cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX -DCRYPTO_BACKEND=OpenSSL -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_LIBDIR=lib

cmake --build . --target install
