#/bin/bash

# ---------------------------------------------------------------
#
# Usa Roms Only
#
# Bash Script to find all files in the current directory that do not contain
# "(USA", no-intro naming USA, to be deleted. Useful for saving space
# ---------------------------------------------------------------


ls | grep -v \(USA.* | tr "\n" "\0" | xargs -0 rm
