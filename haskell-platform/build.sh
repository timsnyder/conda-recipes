# have to bootstrap the build with a bindist of ghc
#wget http://downloads.haskell.org/~ghc/7.10.2/ghc-7.10.2-x86_64-unknown-linux-centos66.tar.xz
#wgetting the tarball wasn't working becuase of lame proxy bullshit so I downloaded it into the $RECIPE_DIR
# outside of conda build... ugh


# do the build
# don't use --prefix=$PREFIX because the build system is expecting to
# install into some nonstandard path and create symlinks from the standard system
# paths.  We just let it build to the prefix that has 4 components on the front
# of all the paths.  We'll strip those unwanted path components out and install
# into the prefix using tar
nice ./platform.sh -j $(getconf _NPROCESSORS_ONLN) $RECIPE_DIR/ghc-7.10.2-x86_64-unknown-linux-centos66.tar.xz

# the install is untarring the tarball in ./build/product
tar --strip-components=4 -C $PREFIX -xzf ./build/product/*tar*

# instead of running the activate-hs script, just register the packages
for conf in $PREFIX/etc/registrations/*
do
    $PREFIX/bin/ghc-pkg register --force $conf
done

