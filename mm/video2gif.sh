#!/bin/sh

if test $# -lt 4; then 
	cat <<-EOH
	$0: script to generate animated gif from video
	
	Usage:
	$0 input.(mp4|avi|webm|flv|...) output.gif horizontal_resolution fps
	EOH
    exit 1
fi

palette="$(mktemp /tmp/ffmpeg2gifXXXXXX.png)"

filters="fps=$4,scale=$3:-1:flags=lanczos" #crop=w:h:x:y
opts="" # -ss seconds [-to seconds/-t duration]

ffmpeg -v warning $opts -i "$1" -vf "$filters,palettegen" -y "$palette"
ffmpeg -v warning $opts -i "$1" -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y "$2"

rm -f "$palette"