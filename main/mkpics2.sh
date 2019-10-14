#!/bin/sh

# check if the input args are valid
if test ! "$#" -eq "2" 
    then
    echo " must input two arguements" >&2
    exit 1

# the condition where all the preconditions are satisfy
elif test "$1" -gt "0"  && test -d "$2" >/dev/null 2>/dev/null
    then
    # echo the html parts that does not depends on
    echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
    echo '<html>'
    echo '  <head>'
    echo '      <title>Pictures</title>'
    echo '  </head>'
    echo '<body>'
    echo '      <h1>Pictures</h1>'
    column=$1
    notClosed=0
    # go through all the year directories,

    for yearDirectory  in "$2"/*
    do
    # check if the year files are directory
        if  test -d "$yearDirectory"
        then


            yearNumber=$(echo $yearDirectory | rev | cut -d"/" -f1 | rev)
            echo "<h2>$yearNumber<h2>"
            echo '      <table>'
            counter=0
            #go through all the month directories
            for monthFile in "$yearDirectory"/*
            do
                # check if all the month are directories
                if test -d "$monthFile"
                then

                    for f in "$monthFile"/*
                    do
                        # check if the file is an image jpeg
                        file "$f" | grep "JPEG image" >/dev/null 2>/dev/null
                        if [ "$?" -eq "0" ]
                        then
                            # echo the valid image
                            if test "$counter" -eq "0"
                            then
                                echo '          <tr>'
                                notClosed=$((notClosed+1))
                            fi

                            if test "$counter" -gt "-1" && test "$counter" -lt "$column"
                            then
                                echo "              <td><img src='$f' height=100></td>"
                                counter=$((counter+1))
                            fi

                            if test "$counter" -eq "$column"
                            then
                                counter=0
                                notClosed=$((notClosed+1))
                                echo '          </tr>'
                            fi
                        fi
                    done

                fi
            done
            # if the
            if [ `expr $notClosed % 2` -eq "1" ]
            then
                echo '          </tr>'
                notClosed=0
            fi
            echo "      </table>"


        fi
    # frist for loop
    done
    echo '</body>'
    echo '</html>'
# prevent the program to crash
else
    echo " The input is not valid" >&2
    exit 1
fi
