#!/bin/bash

LANG=C

dpkg -l | tail -n +8 | awk '{print $2}' |
while read PACKAGE
do
    REPO=$(apt-cache policy $PACKAGE |
    awk '{
        if(match($0, "100")) {
            if(match(PREV, "500")) {
                print PREV
            }
        }
    }
    {PREV=$0}' |
    awk '{print $2}' |
    sed 's|http://||g')
    if [ -z "$REPO" ]
    then
        REPO="Not found"
    fi
    echo $REPO - $PACKAGE
done | grep -Ev 'ru.archive.ubuntu.com|security.ubuntu.com|archive.canonical.com' | sort
