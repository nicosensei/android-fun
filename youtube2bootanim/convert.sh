#!/bin/bash

# Usage convert.sh myVid.mp4 800 480

MP4=$1
START_FRAME=0
RES_W=$2
RES_H=$3
FPS=$4

echo -e "\n**********\nWill convert "$MP4" to bootanimation, at "$RES_W"x"$RES_H" @ "$FPS" FPS\n**********\n"

TMP_FOLDER="bootanimation`date +%s`"
mkdir -p  $TMP_FOLDER/part0

ffmpeg -i "$MP4" -ss 0 -t $FPS -s "$RES_W"x"$RES_H" -f image2 -vcodec png $TMP_FOLDER/part0/%05d.png
