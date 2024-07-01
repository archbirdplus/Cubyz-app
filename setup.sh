#!/bin/bash

SUPERDIR="$(dirname "$(dirname "$(realpath $0)")")"

echo "SUPER $SUPERDIR"

cd Cubyz.app/Contents/Library

ROOT_DEPS="libGL.1.dylib libglapi.0.dylib"

include () {
    dep=$1
    install_name_tool -id $dep $dep
    otool -L $dep | grep -v ':' | grep homebrew | awk '{print $1}' | while read homebrew_lib_path; do
        dylib_name=`echo $homebrew_lib_path | grep -o '[^/]*dylib'`
        if ! [ -f $homebrew_lib_path ]; then
            brew_dep=`echo $homebrew_lib_path | awk -F '/' '{print $5}'`
            echo "We need to install $brew_dep for $homebrew_lib_path"
            brew install $brew_dep
        fi
        echo "Copying $homebrew_lib_path into Library/"
        cp $homebrew_lib_path .
        install_name_tool $dep -change $homebrew_lib_path @loader_path/$dylib_name
    done
}

pwd

mkdir ../Resources
cp "$SUPERDIR"/Cubyz-app/logo.icns ../Resources/Cubyz.icns
cp "$SUPERDIR"/Cubyz-app/logo.png ../MacOS/logo.png
cd ../MacOS

cp -r "$SUPERDIR"/Cubyz/assets assets
cp -r "$SUPERDIR"/Cubyz/settings.json settings.json
cp "$SUPERDIR"/Cubyz/zig-out/bin/Cubyzig Cubyzig

for dep in $DEPS; do
    args -change $dep "@rpath/`basename $dep`" Cubyzig
    install_name_tool -change $dep "@rpath/`basename $dep`" Cubyzig
done

cd "$SUPERDIR"/Cubyz-app

