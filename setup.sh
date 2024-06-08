#!/bin/bash

SUPERDIR="$(dirname "$(dirname "$(realpath $0)")")"

echo "SUPER $SUPERDIR"

# cp -f /usr/local/GL/lib/libEGL.1.dylib
if [ -f /usr/local/GL/lib/libGL.1.dylib ] && [ -f /usr/local/GL/lib/libglapi.0.dylib ]; then
    cp -f /usr/local/GL/lib/libGL.1.dylib /usr/local/GL/lib/libglapi.0.dylib Cubyz.app/Contents/Library
else
    # TODO: fetch from Arch/Cubyz?
    echo "there is no libGL"
fi

cd Cubyz.app/Contents/Library

DEPS="/usr/local/GL/lib/libGL.1.dylib /usr/local/GL/lib/libglapi.0.dylib"
for lib in $DEPS; do
    for dep in $DEPS; do
        OP="-change"
        if [ $dep = $lib ]; then
            args -id `basename $lib` `basename $lib`
            install_name_tool -id `basename $lib` `basename $lib`
        else
            args -change $dep "@rpath/`basename $dep`" `basename $lib`
            install_name_tool -change $dep "@rpath/`basename $dep`" `basename $lib`
        fi
    done
done

pwd

mkdir ../Resources
cp "$SUPERDIR"/Cubyz-app/logo.icns ../Resources/Cubyz.icns
cp "$SUPERDIR"/Cubyz-app/logo.png ../MacOS/logo.png
cd ../MacOS

cp -r "$SUPERDIR"/Cubyz/assets assets
cp -r "$SUPERDIR"/Cubyz/saves saves
cp -r "$SUPERDIR"/Cubyz/settings.json settings.json
cp "$SUPERDIR"/Cubyz/zig-out/bin/Cubyzig Cubyzig

for dep in $DEPS; do
    args -change $dep "@rpath/`basename $dep`" Cubyzig
    install_name_tool -change $dep "@rpath/`basename $dep`" Cubyzig
done

cd "$SUPERDIR"/Cubyz-app

