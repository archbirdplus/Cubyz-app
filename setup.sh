#!/bin/bash

SUPERDIR="$(dirname "$(dirname "$(realpath $0)")")"

echo "SUPER $SUPERDIR"

cd Cubyz.app/Contents/Library

ROOT_DEPS="libGL.1.dylib libglapi.0.dylib"

include () {
    local dep=$1
    local dep_name=`basename $dep`
    install_name_tool -id $dep_name $dep_name 2>/dev/null
    otool -L $dep | grep -v ':' | grep homebrew | awk '{print $1}' | while read homebrew_lib_path; do
        local dylib_name=`basename $homebrew_lib_path`
        echo "$dep_name needs $dylib_name"
        if ! [ -f $homebrew_lib_path ]; then
            local brew_dep=`echo $homebrew_lib_path | awk -F '/' '{print $5}'`
            brew install $brew_dep
        fi
        install_name_tool $dep_name -change $homebrew_lib_path @loader_path/$dylib_name 2>/dev/null
        if ! [ -f $dylib_name ]; then
            echo " ... packaging $dylib_name"
            cp $homebrew_lib_path .
            include $homebrew_lib_path
        fi
    done
}

for root_dep in $ROOT_DEPS; do
    include $root_dep
done

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

