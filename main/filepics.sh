#!/bin/sh

# add exiftime program to the path
export PATH=$PATH:/courses/courses/cscb09w19/bin/

if test ! "$#" -eq "1"
then
    echo "must contain one arg" >&2
    exit 1

elif  test ! -d "$1"
then
    echo "The arg:$1 is not a directory" >&2
    exit 1

# all preconditions are valid
elif test -d "$1"
then
    for filename in "$1"/* ; do

        # check if the current file is jpeg
        file "$filename" | grep "JPEG image" >/dev/null 2>/dev/null
        if test "$?" -eq "0"
        then


        # check if the image can be generated
        exiftime -tg "$filename" | grep "Image Generated" >/dev/null 2>/dev/null
        if test "$?" -eq "0"
        then

            year=$(exiftime -tg "$filename" | grep "Image Generated" | cut -d ":" -f2)
            month=$(exiftime -tg "$filename" | grep "Image Generated" | cut -d ":" -f3)

        # create a directories first then copy the image files into the correspond directory
        mkdir -p $year/$month
        cp "$filename" $year/$month
        else
            echo "$filename can not be excute by exiftime"
        fi
        else
            echo "$filename is not a JPEG file"


        fi
    done
# prevent the program to crash
else
    echo "invalid input" >&2
    exit 1
fi
