# haskell-platform's platform.sh installer script wants to be able to install deps
# with cabal.  Make sure the hackage package list is up to date
# cabal update is slow, disable while debugging recipe
##cabal update

# have to bootstrap the build with a bindist of ghc that matches the build of haskell-platform
# we're trying to build from source.  Since the GHC bindist isn't tiny, we will download it into the $RECIPE_DIR
# I wish that meta.yaml supported build "data" that would be downloaded like source tarballs and stored
# in a cache but instead of being unarchived into $SOURCE_DIR, they would be copied or symlinked after the source
# is unarchived
RECIPE_DIR=$HOME/conda/conda-recipes/haskell-platform
GHC_BINDIST_URL="http://downloads.haskell.org/~ghc/7.10.2/ghc-7.10.2-x86_64-unknown-linux-centos66.tar.xz"
GHC_BINDIST_FN=$(basename $GHC_BINDIST_URL)

# NOTE: md5sum --check requires *two* spaces after the checksum before the filename...
echo "2f2034ba1ba5aca95656f1c4381f434b  $RECIPE_DIR/$GHC_BINDIST_FN" > $GHC_BINDIST_FN.md5
md5sum --check $GHC_BINDIST_FN.md5
if [ $? -ne 0  ]; then
    echo Begin Download of GHC Bindist from $GHC_BINDIST_URL
    pushd $RECIPE_DIR
    wget $GHC_BINDIST_URL
    popd
fi
ln -s $RECIPE_DIR/$GHC_BINDIST_FN .



# do the build
# don't use --prefix=$PREFIX because the build system is expecting to
# install into some nonstandard path and create symlinks from the standard system
# paths.  We just let it build to the prefix that has 4 components on the front
# of all the paths.  We'll strip those unwanted path components out and install
# into the prefix using tar
nice ./platform.sh -j $(getconf _NPROCESSORS_ONLN) ./$GHC_BINDIST_FN

# the install is untarring the tarball in ./build/product
tar --strip-components=4 -C $PREFIX -xzf ./build/product/*tar*

# instead of running the activate-hs script, just register the packages
for conf in $PREFIX/etc/registrations/*
do
    $PREFIX/bin/ghc-pkg register --force $conf
done

