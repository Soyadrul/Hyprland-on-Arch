#! /usr/bin/bash

while true; do
    sleep 4
    echo click left | dotool
    paplay "/usr/share/sounds/freedesktop/stereo/complete.oga"
done
