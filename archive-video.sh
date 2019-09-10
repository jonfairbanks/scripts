#!/bin/sh
if [ -n "$1" ]; then
    USERDIR="$USER" && [ -n "$2" ]  && USERDIR="$2"
    set -x
    sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl >> /dev/null 2>&1
    sudo chmod a+rx /usr/local/bin/youtube-dl >> /dev/null 2>&1
    youtube-dl -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4" -o "/home/$USERDIR/archive/%(title)s.%(ext)s" "$1" --ignore-errors
else
    echo "[Error] : URL not passed"
fi