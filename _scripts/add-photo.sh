#!/bin/sh

if [ "$#" -ne 2 ] && [ "$#" -ne 3 ]; then
	echo "Usage: $0 <photo-path> [<new-photo-path>] <title>"
	exit 1
fi

if ! [ -f "$1" ]; then
	echo "Could not find a photo at \"$1\""
	exit 1 
fi

if [ "$#" -eq 2 ]; then
PHOTONAME=$(basename $1)
TITLE=$2
elif [ "$#" -eq 3 ]; then
PHOTONAME=$2
TITLE=$3
fi


if [ -f "photography/$PHOTONAME" ]; then
	echo "Error: A photo called $PHOTONAME already exists in photography/"
	echo "Please rename photo before importing"
	exit 1
fi

convert "$1" -resize 1200 "photography/$PHOTONAME"
convert "$1" -resize 300 -quality 80% "photography/thumbnail-$PHOTONAME"

if [ -f "_data/photography.yml" ]; then
	touch _data/photography.yml
fi

mv _data/photography.yml _data/photography.yml.old
echo "- path: $PHOTONAME" >> _data/photography.yml
echo "  title: $TITLE" >> _data/photography.yml
cat _data/photography.yml.old >> _data/photography.yml
rm _data/photography.yml.old

git add _data/photography.yml photography/$PHOTONAME photography/thumbnail-$PHOTONAME
git commit -m "Add photo $PHOTONAME"
