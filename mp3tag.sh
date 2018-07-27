#!/bin/bash

###############################################################################
# Loop through files and update the meta data tags based on file name 
# It should handle files paths with spaces in it, maybe
#
# Uses id3v2 as a re-tagger
# Assumes the artist and track are separated by a hyphen in the filename
###############################################################################

if ! `which id3v2`; then
    echo "This script requires package 'id3v2'"
    exit 1
elif [ $# -ne 1 ]; then
    echo "Expecting directory to fix as command line argument"
    exit 1
elif [ ! -d $1 ]; then
    echo "'$1' is not a directory"
    exit 1
fi

cd $1

SAVEIFS=$IFS
IFS=$'\n'
for file in `ls -l | awk '{for(i=9;i<NF;i++){printf "%s ", $i}; printf "%s\n",$NF}'`; do
    #-- Print the variables --#
    echo "File: '$file'"

    artist=`echo "$file" | egrep -o '^[^-]*' | sed 's/[[:blank:]]$//g'`
    echo "Artist: '$artist'"

    track=`echo "$file" | sed 's/^.*-//g; s/\.[^.]*$//g; s/^[[:blank:]]//g'`
    echo -e "Track: '$track'\n"

    #-- Update the fucking tags --#
    id3v2 -a "$artist" -t "$track" "$file"
done
IFS=$SAVEIFS
