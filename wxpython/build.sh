#!/bin/bash


ARCH="$(uname 2>/dev/null)"

export CFLAGS="-m64 -pipe -O2 -march=x86-64 -fPIC"
export CXXLAGS="${CFLAGS}"

LinuxInstallation() {
    # Build dependencies:
    # - no system build deps. Use packaged wxPython libs.

    pushd wxPython/;
    ${PYTHON} ./build-wxpython.py --install --prefix="${PREFIX}"  || return 1;
    popd;


    return 0;
}

case ${ARCH} in
    'Linux')
        LinuxInstallation || exit 1;
        ;;
    *)
        echo -e "Unsupported machine type: ${ARCH}";
        exit 1;
        ;;
esac

