mkdir build && cd build

export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_PREFIX_PATH=$PREFIX

cmake --build . --target install
