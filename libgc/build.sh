
set -ex

# handle building 32bit on 64bit host
# https://gcc.gnu.org/ml/gcc-help/2010-09/msg00040.html

# Download additional source code and move into required position
# Important to run with Python from *root* because conda-build is installed there
CONDA_PYTHON=$(conda info --root)/bin/python
${CONDA_PYTHON} ${RECIPE_DIR}/download-extra-sources.py
ln -s ../libatomic_ops/libatomic_ops-7.4.2 libatomic_ops

extra_configure=""

if [[ "$ARCH" == "32" && "$(uname -m)" == "x86_64" ]]; then
    export CC="gcc -m32"
    export CXX="g++ -m32"
    extra_configure="--build=i686-linux-gnu --host=i686-linux-gnu --target=i686-linux-gnu"
fi

./configure --prefix="$PREFIX" "${extra_configure}"


make
make check
make install
