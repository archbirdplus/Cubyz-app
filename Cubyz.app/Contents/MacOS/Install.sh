#!/bin/bash

cd "$(dirname "$0")"

echo "Cubyz needs to install some dependencies."

echo "Do you wish to install the necessary XQuartz and LLVM? (Enter a number)"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
        * ) exit;;
    esac
done

echo "Installing XQuartz."

# XQuartz replaces all of brew install libxrandr libxrender libxdmcp libxau libxcb libxext libx11
wget https://github.com/XQuartz/XQuartz/releases/download/XQuartz-2.8.5/XQuartz-2.8.5.pkg -v -O ../Resources/XQuartz-2.8.5.pkg && open ../Resources/XQuartz-2.8.5.pkg

echo "Installing LLVM-18."

brew install llvm@18

echo "Extra installation complete."
echo "Press enter to continue..."

read

