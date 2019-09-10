#!/bin/sh
if [ -n "$1" ]; then
    set -x
    youtube-dl -U
    youtube-dl -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4" -o "/home/$USER/YouTube/%(title)s.%(ext)s" "$1" --ignore-errors
else
    echo "[Error] : URL not passed"
fi