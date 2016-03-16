#!/bin/bash

set -ex

# Download additional source code and move into required position
# Important to run with Python from *root* because conda-build is installed there
CONDA_PYTHON=$(conda info --root)/bin/python
${CONDA_PYTHON} ${RECIPE_DIR}/download-extra-sources.py
mv ../cfe/* tools/clang
# see meta.yaml for reasons we're not building tools-extra right now
#mv ../clang-tools-extra/*/* tools/clang/tools
mv ../projects/*/* projects

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
    -G "Ninja" \
    -Wno-dev \
    ..

nice cmake --build .
cmake --build . --target install
