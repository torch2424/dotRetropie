#/bin/bash

# ---------------------------------------------------------------
#
# Non-Matching File Remover
#
# Bash Script to utilize the compareFolders.sh to perform a removal
# Of roms not found in the media folder, or vice versa
# ---------------------------------------------------------------

if [ "$#" -ne 4 ]; then

        # Not Enough Params, Show Usage
        echo "Non-Matching File Remover"
        echo "compareFolders.sh must be in the same directory"
        echo "WARNING: This will permenantly remove some your files"
        echo "May be better to simply run the following:"
        echo ""
        echo "./compareFolders.sh $1 $2 $3 $4 > tmp.txt
        xargs -d "\n" rm < tmp.txt"
        echo ""
        echo " And then inspect tmp.txt for the files"
        echo ""
        echo "USAGE: [script.sh] [folder 1 where files will be removed] [folder 2 where files will be compared] [file exenstions of folder 1] [file extensions of folder two]"

    echo "NOTE: Extensions should have no '.', and folders should have no trailing slash"
    exit 0
fi

./compareFolders.sh $1 $2 $3 $4 > tmp.txt
xargs -d "\n" rm < tmp.txt
rm tmp.txt
