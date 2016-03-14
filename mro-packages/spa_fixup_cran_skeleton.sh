#!/bin/bash

SCRIPT_NAME=$(basename $0)

print_help () {
    cat <<-END
    USAGE:
        $SCRIPT_NAME <r-package>

    DESCRIPTION:

    For some reason, conda-build doesn't export R_HOME yet and MRO needs it.
    So, we have to handle that in the recipe.  After running 
    'conda skeleton cran <package>', run this script 
    './$SCRIPT_NAME r-<package>' and it will update ./r-<package>/{build.sh,meta.yaml}
    so that R_HOME is exported.
END
}


if [[ $# -ne 1 ]]; then
    print_help
    exit 1
elif [[ ! -d "$1" ]]; then
    echo "ERROR: '$1' is not a directory"
    print_help
    exit 1
else
    for f in build.sh meta.yaml; do
        perl -i.bk -ne '
            print "$_"; 
            if (/^(\s+)# You can put additional/) {
                print "${1}- export R_HOME=\$PREFIX/lib/R # [not win]\n" ; 
            } 
            if (/^\#\!\/bin\/bash/) {
                print "export R_HOME=\${PREFIX}/lib/R\n";
                print "export R_LIBS=\${R_HOME}/library\n";
            }
        ' "$1/$f"
        (set -x; diff "$1/$f"{.bk,})
    done
fi
