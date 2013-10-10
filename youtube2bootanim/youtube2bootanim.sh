#!/bin/bash

# Usage youtube2bootanim.sh <YouTube video ID> <frames per second>
#
# The script is intended to be ran on Debian-based Linux distros. 
# It's been developed and tested under Linux Mint 15
# This script needs the following packages installed: ffmpeg and youtube-dl
#
# The base ffmpeg command comes from this utility: http://forum.xda-developers.com/showthread.php?t=1719104
#
# TODO ffmpeg is deprecated, should move to using avconv
#
# Nikojiro @ XDA-developers 2013

checkInstalled() {
    INSTALLED="`dpkg -L $1 | wc -l`"
    if [  $INSTALLED -eq 0 ]; then
        echo -e "$1 is not installed. Type 'sudo apt-get install $1' to do so. You'll need root privileges."
        echo -e "Exiting now."
        exit 0
    fi
}

checkInstalled ffmpeg
checkInstalled youtube-dl

YOUTUBE_ID=$1
while read mp4; do
    echo $mp4
done < <(youtube-dl -F $YOUTUBE_ID | grep mp4)


FORMAT=135
youtube-dl --id -f $FORMAT $YOUTUBE_ID

MP4=$YOUTUBE_ID.mp4
START_FRAME=0
RES_W=800
RES_H=480
FPS=$2

echo -e "\n**********\nWill convert "$MP4" to bootanimation, at "$RES_W"x"$RES_H" @ "$FPS" FPS\n**********\n"

TMP_FOLDER="bootanimation`date +%s`"
mkdir -p  $TMP_FOLDER/part0

ffmpeg -i "$MP4" -ss 0 -t $FPS -s "$RES_W"x"$RES_H" -f image2 -vcodec png $TMP_FOLDER/part0/%05d.png

# Create desc.txt

echo $RES_W $RES_H $FPS > $TMP_FOLDER/desc.txt
echo "p 0 0 part0" >> $TMP_FOLDER/desc.txt

# Zip it

ZIP_NAME=$YOUTUBE_ID"_bootanim_"$RES_W"x"$RES_H"_"$FPS".zip"
pushd $TMP_FOLDER
zip -qr $ZIP_NAME *
mv -f $ZIP_NAME ..
popd
echo -e "\n\nGenerated $ZIP_NAME\n\n"

# Cleanup
rm -f $MP4
rm -rf $TMP_FOLDER
