#!/bin/sh

width=$(( $(tput cols) * 2 ))
height=$(( $(tput lines) * 4 ))

convert "$1" -resize "${width}x${height}" -colors 2 -colorspace gray -ordered-dither o2x2 "/tmp/image.xpm"
gawk -f ./braille.awk "/tmp/image.xpm"
rm "/tmp/image.xpm"

