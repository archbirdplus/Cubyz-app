#!/bin/bash

cd "$(dirname "$0")"

echo "Cubyz needs to install some dependencies."

do_xquartz() {
    echo "Installing XQuartz."

    # XQuartz replaces all of brew install libxrandr libxrender libxdmcp libxau libxcb libxext libx11
    curl -L -o ../Resources/XQuartz-2.8.5.pkg https://github.com/XQuartz/XQuartz/releases/download/XQuartz-2.8.5/XQuartz-2.8.5.pkg && open ../Resources/XQuartz-2.8.5.pkg
}

do_llvm() {
    echo "Installing LLVM."
}

echo -n "Do you need to install the dependency XQuartz? (yes/no) "
read r
case $r in
    Yes | yes | y | Y )
        do_xquartz;;
    * )
        echo "Not installing"
        exit;;
esac

echo -n "Do you need to install the dependency LLVM? (yes/no) "
read r
case $r in
    Yes | yes | y | Y )
        brew install llvm;;
    * )
        echo "Not installing"
        exit;;
esac

echo "Extra installation complete."
echo "Press enter to continue..."

read
