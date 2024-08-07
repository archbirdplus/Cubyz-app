#!/bin/bash

cd "$(dirname "$0")"

echo "Cubyz needs to install some dependencies."

echo -n "Do you wish to install the dependency XQuartz? (yes/no) "
read r
case $r in
    Yes | yes | y | Y ) ;;
    * )
        echo "Not installing"
        echo "Press enter to close"
        pause
        exit;;
esac

echo "Installing XQuartz."

# XQuartz replaces all of brew install libxrandr libxrender libxdmcp libxau libxcb libxext libx11
curl -L -o ../Resources/XQuartz-2.8.5.pkg https://github.com/XQuartz/XQuartz/releases/download/XQuartz-2.8.5/XQuartz-2.8.5.pkg && open ../Resources/XQuartz-2.8.5.pkg

echo "Extra installation complete."
echo "Press enter to continue..."

read

