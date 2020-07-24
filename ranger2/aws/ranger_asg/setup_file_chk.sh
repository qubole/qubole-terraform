#!/bin/bash

set -e
sleep 120

loop=1
while [ ! -f /tmp/setup-done ]; do
    if [ $loop -gt 20 ]; then
        exit 1
    else
        echo "$loop: Waiting for setup script to complete"
        sleep 20
        loop=$(($loop + 1))
    fi
done
