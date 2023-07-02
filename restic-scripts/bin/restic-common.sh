#!/bin/bash

export PATH=/usr/local/bin:$PATH

LOG=/dev/null

if [ -n "$DEBUG" ]; then
    LOG=/dev/stdout
    echo "Enabling stdout"
fi

scriptname() {
    basename $0
}

log() {
    if [ -n "$DEBUG" ]; then
        tee >(logger -t $(scriptname))
    else 
        logger -t $(scriptname)
    fi
}


