# don't completely understand why ghc-pkg is seeing the system
# config in
# ghc-pkg: /usr/lib64/ghc-7.0.4/package.conf.d/package.cache: you don't have permission to modify this file
#
# but with the addition of explicit argument to where the global db is for the $PREFIX
# we can hopefully get around that and end up with a correct package cache

"$PREFIX"/bin/ghc-pkg recache --global-package-db "$PREFIX"/lib/ghc-"$PKG_VERSION"/package.conf.d --no-user-package-conf
