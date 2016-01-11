# don't install boost using rstudio deps script, it is installed from conda
perl -i.orig -pe '/install-boost/ and s/^/#/' dependencies/common/install-common


pushd dependencies/linux
./install-dependencies-yum --exclude-qt-sdk
popd


mkdir build
cd build

export LIBR_HOME=$PREFIX/lib/R
export BOOST_ROOT=$PREFIX
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DRSTUDIO_TARGET=Desktop \
      -DCMAKE_BUILD_TYPE=Release \
      -DQT_QMAKE_EXECUTABLE=$PREFIX/lib/qt5/bin/qmake \
      ..

make install
