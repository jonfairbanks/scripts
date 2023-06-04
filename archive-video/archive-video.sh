#!/bin/sh
if [ -n "$1" ]; then
    set -x
    yt-dlp -U
    yt-dlp --download-archive -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4" -o "/home/$USER/archive-video/%(title)s.%(ext)s" "$1" --ignore-errors
else
    echo "[Error] : URL not passed"
fi