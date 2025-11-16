#!/bin/bash

SUPERDIR="$(dirname "$(dirname "$(realpath $0)")")"
ROOTDIR="$(dirname "$(realpath $0)")"
APPDIR="$(dirname "$(realpath $0)")/Cubyz.app"

echo "SUPER $SUPERDIR"

mkdir -p Cubyz.app/Contents/Library
cd Cubyz.app/Contents/Library

ROOT_DEPS="libGL.1.dylib libglapi.0.dylib"

sizeof () {
    du -schH $1 | grep total | awk -F'\t' '{print $1}'
}

include () {
    local dep=$1
    local dep_name=`basename $dep`
    install_name_tool -id $dep_name $dep_name 2>/dev/null
    otool -L $dep | grep -v ':' | grep homebrew | awk '{print $1}' | while read homebrew_lib_path; do
        local dylib_name=`basename $homebrew_lib_path`
        echo "$dep_name needs $dylib_name"
        if [ $dylib_name != "libLLVM.dylib" -a $dylib_name != "libzstd.1.dylib" ]; then
            if ! [ -f $homebrew_lib_path ]; then
                local brew_dep=`echo $homebrew_lib_path | awk -F '/' '{print $5}'`
                echo "Installing $brew_dep"
                brew install $brew_dep
            fi
            install_name_tool $dep_name -change $homebrew_lib_path @loader_path/$dylib_name 2>/dev/null
            if ! [ -f $dylib_name ]; then
                echo " ... packaging $dylib_name ($(sizeof $homebrew_lib_path))"
                cp $homebrew_lib_path .
                include $homebrew_lib_path
            fi
        fi
    done
}

for root_dep in $ROOT_DEPS; do
    cp /usr/local/GL/lib/$root_dep .
    echo " including packaging $root_dep ($(sizeof $root_dep))"
    include $root_dep
done

pwd

mkdir "$APPDIR/Contents/Resources" "$APPDIR/Contents/MacOS"
cp "$ROOTDIR/templates/Info.plist" "$APPDIR/Contents"
cp "$ROOTDIR/templates/Install.sh" "$APPDIR/Contents/MacOS"
cp "$ROOTDIR/templates/RunCubyzig.sh" "$APPDIR/Contents/MacOS"
cp "$ROOTDIR"/logo.icns ../Resources/Cubyz.icns
cp "$ROOTDIR"/logo.png ../MacOS/logo.png
cd ../MacOS

cp -r "$SUPERDIR"/Cubyz/assets assets
cp -r "$SUPERDIR"/Cubyz/launchConfig.zon "$APPDIR/Contents/MacOS"
cp -r "$SUPERDIR"/Cubyz/settings.zig.zon settings.zig.zon
cp "$SUPERDIR"/Cubyz/zig-out/bin/Cubyz Cubyzig

for dep in $DEPS; do
    args -change $dep "@rpath/`basename $dep`" Cubyzig
    install_name_tool -change $dep "@rpath/`basename $dep`" Cubyzig
done

cd "$SUPERDIR"/Cubyz-app

