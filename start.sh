#!/bin/bash

#sleep 20

DIR=~/.conky/


launch() {
    RUN=`ps aux | grep conky | grep $1`

    if [ -z "$RUN" ]; then
        conky -c $DIR$1 -q &
    fi
}

launch "systemrc"
launch "cpurc"
launch "memoryrc"
launch "diskrc"
launch "networkrc"
launch "calrc"
launch "updatesrc"
launch "spotifyrc"