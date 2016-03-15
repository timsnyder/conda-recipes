#!/bin/bash

set -e

# Important to run with Python from *root* because conda-build is installed there
CONDA_PYTHON=$(conda info --root)/bin/python
${CONDA_PYTHON} ${RECIPE_DIR}/download-extra-sources.py

mkdir -p tools/clang
tar --strip-components=1 --directory=tools/clang       -xJf ./cfe-3.8.0.src.tar.xz 
tar --strip-components=1 --directory=tools/clang/tools -xJf ./clang-tools-extra-3.8.0.src.tar.xz
tar --strip-components=1 --directory=projects          -xJf ./compiler-rt-3.8.0.src.tar.xz

mkdir build
cd build

# useful blog post regarding building on Centos6.5
# http://btorpey.github.io/blog/2015/01/02/building-clang/

# cmake rpath options are discussed in:
# https://cmake.org/Wiki/CMake_RPATH_handling

cmake \
    -DCMAKE_INSTALL_PREFIX=$PREFIX            \
    -DCMAKE_C_COMPILER=$PREFIX/bin/gcc        \
    -DCMAKE_CXX_COMPILER=$PREFIX/bin/g++      \
    -DCMAKE_SKIP_BUILD_RPATH=FALSE            \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE     \
    -DCMAKE_INSTALL_RPATH="${PREFIX}/lib"     \
    -DCMAKE_C_FLAGS="-D__GCC_HAVE_SYNC_COMPARE_AND_SWAP_1=1 -D__GCC_HAVE_SYNC_COMPARE_AND_SWAP_2=1 -D__GCC_HAVE_SYNC_COMPARE_AND_SWAP_4=1 -D__GCC_HAVE_SYNC_COMPARE_AND_SWAP_8=1" \
    -DCMAKE_CXX_LINK_FLAGS="-L${PREFIX}/lib"  \
    -DCMAKE_BUILD_TYPE=Release                \
    -DGCC_INSTALL_PREFIX=$PREFIX              \
    -DLLVM_ENABLE_ASSERTIONS=true             \
    -DLLVM_ENABLE_SPHINX=true                 \
    -Wno-dev \
    ..

cmake --build .
cmake --build . --target install
