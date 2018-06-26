#!/bin/sh

if [ $# -ne 1 ]; then
    echo "\n\033[01;31m[$(basename $0)] Usage: $(basename $0) FILE\033[00m\n"
    exit 1
fi

set -x

filename="$1"
basename="${filename%.*}"

if ! which gifsicle; then
    sudo apt-get install gifsicle
fi

if which ffmpeg &>/dev/null; then
    ffmpeg -i $1 -pix_fmt rgb8 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > ${basename}.gif
elif which avconv &>/dev/null; then
    avconv -i $1 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > ${basename}.gif
fi

set +x
