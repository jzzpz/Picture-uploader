#!/bin/sh

# change from stdout to stderror :echo "error message" >&2
# >/dev/null 2>/dev/null to avoid error output



# check if the input args are valid
if [ $# -lt 2 ]
    then
    echo " number  of arguement less than 2" >&2
    exit 1
# the case where the input is valid
elif [ "$1" -gt "0" ] >/dev/null 2>/dev/null
    then
    # echo the html structure that does not depend on the picture table
    echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
    echo '<html>'
    echo '  <head>'
    echo '      <title>Pictures</title>'
    echo '  </head>'
    echo '  <body>'
    echo '      <h1>Pictures</h1>'
    echo '<table>'
    column=$1
    shift
    counter=0
    notClosed=0
    # iterate all the args and if the arg is a image file then add it to the html script
    while test "$1" != ""
    do
        file "$1" | grep "JPEG image" >/dev/null 2>/dev/null
        if [ "$?" -eq "0" ]
            then
            if test "$counter" -eq "0"
                then
                echo '  <tr>'
                counter=$((counter+1))
                notClosed=$((notClosed+1))

            elif test "$counter" -gt "0" && test "$counter" -lt "$((column+1))"
                then
                echo "      <td><img src='$1' height=100></td>"
                counter=$((counter+1))

                if test "$counter" -eq "$((column+1))" ;then
                    echo '  </tr>'
                    counter=0
                    notClosed=$((notClosed+1))
                fi
                shift
            fi

        else
            echo "$1 is not a JPEG file" >&2
            shift
        fi
    done
    # if  <tr> is not closed with </tr> then add it
    if [ `expr $notClosed % 2` -eq 1 ]
    then
        echo '  </tr>'
    fi

    echo '</table>'
    echo '</body> </html>'
else
    echo  "invalid args" >&2
    exit 1
fi
