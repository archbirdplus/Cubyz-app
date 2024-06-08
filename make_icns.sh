#!/bin/bash

# Check if the input file exists
if [ ! -f "$1" ]; then
  echo "Error: File does not exist."
  exit 1
fi

# Directory to store temporary icon files
mkdir icon.iconset
cd icon.iconset

# Generate the necessary icon sizes using ImageMagick
convert ../$1 -resize 16x16 icon_16x16.png
convert ../$1 -resize 32x32 icon_16x16@2x.png
convert ../$1 -resize 32x32 icon_32x32.png
convert ../$1 -resize 64x64 icon_32x32@2x.png
convert ../$1 -resize 128x128 icon_128x128.png
convert ../$1 -resize 256x256 icon_128x128@2x.png
convert ../$1 -resize 256x256 icon_256x256.png
convert ../$1 -resize 512x512 icon_256x256@2x.png
convert ../$1 -resize 512x512 icon_512x512.png
convert ../$1 -resize 1024x1024 icon_512x512@2x.png

# Use iconutil to create the icns file
iconutil -c icns -o ../${1%.*}.icns .

# Cleanup temporary files
cd ..
rm -rf icon.iconset

echo "ICNS file created: ${1%.*}.icns"
