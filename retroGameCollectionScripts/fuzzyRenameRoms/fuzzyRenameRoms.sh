#/bin/bash

# https://stackoverflow.com/questions/23908057/javascript-regex-for-a-partial-string-match-only
# Testing


# This bash script will try to match Roms by their name by words

# .*(Super[\s]|Buster[\s]|Bros[\s]|(USA)[\s]){2,}.*


# Print Usage
if [ "$#" -ne 4 ]; then

        # Not Enough Params, Show Usage
        echo "Rom Fuzzy Compare"
        echo "USAGE: [script.sh] [folder 1] [folder 2] [file exenstions of folder 1] [file extensions of folder two]"

    echo "NOTE: Extensions should have no '.', and folders should have no trailing slash"
    exit 0
fi

folder1=$1
folder2=$2
ext1=$3
ext2=$4

for fullfile in ${folder1}/*.$ext1
do
        # Get the file name without the extension
        filename=$(basename "$fullfile")

        # Create the beginning of our regex
        regex=".*("

        # Create a counter for our number of words
        numwords=0

        for word in $filename
        do
            regex="$regex$word[\s]|"
            ((numwords++))
        done

        # Get our default preciseness
        precise=$numwords

        if [ $precise > 1 ]; then

          # Decrease the preciseness
          ((precise--))

          # Drop the last | from our regex
          regex="${regex%?}"
          # Add the ending of ouy regex
          regex="$regex){$precise,}.*\gim"

          echo $regex

          # Now that we have our regex, search in the second folder for it
          ls $folder2 | grep $regex >> results.txt
        fi
done
