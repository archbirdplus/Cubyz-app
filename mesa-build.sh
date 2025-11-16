# There may be more to it than this. Stuff like -DLLVM_USE_CRT_DEBUG=MTd
# referenced in https://gallium.readthedocs.io/en/latest/gallium/drivers/llvmpipe.html

cd molten-zink

rm -rf *

OLD_PATH=$PATH

export PATH=/opt/homebrew/opt/llvm/bin:$OLD_PATH

# select most recent clang, otherwise the SDK breaks
export CC=`which clang`
export CXX=`which clang++`
export OBJC=`which clang`
export OBJCXX=`which clang`
export LD=`which ld`
export OBJC_LD=`which ld`
export OBJCXX_LD=`which ld`

echo "Using clang ($CC) version:"
$CC -v

export PATH="/opt/homebrew/opt/llvm@19/bin:$OLD_PATH"
export PKG_CONFIG_PATH="/opt/X11/share/pkgconfig:/opt/X11/lib/pkgconfig"

pkg-config --cflags --libs x11

COMMON_ARGS="-O2 -w -g -I/opt/X11/include -L/opt/X11/lib -I$MOLTENVK_DIR/include/vulkan --sysroot=$XCODE_SYSROOT"
LD_ARGS="--no-warnings"

meson setup \
    .. \
    -Dc_args="$COMMON_ARGS" \
    -Dcpp_args="$COMMON_ARGS -fpermissive" \
    -Dc_link_args=$LD_ARGS \
    -Dcpp_link_args=$LD_ARGS \
    -Dplatforms=x11 \
    -Dgles1=disabled \
    -Dgles2=disabled \
    -Dgallium-drivers=llvmpipe \
    -Dglx=xlib \
    -Dprefix="/usr/local/GL" \
    -Dbuildtype=release

sudo ninja install

: '

meson setup \
    .. \
    -Dc_args="$COMMON_ARGS" \
    -Dcpp_args="$COMMON_ARGS -fpermissive" \
    -Dc_link_args=$LD_ARGS \
    -Dcpp_link_args=$LD_ARGS \
    -Dplatforms=macos \
    -Degl=enabled \
    -Dopengl=true \
    -Dgles1=disabled \
    -Dgles2=disabled \
    -Degl-native-platform=macos \
    -Dmoltenvk-dir=$MOLTENVK_DIR \
    -Dgallium-drivers=llvmpipe,zink \
    -Dglx=disabled \
    -Dprefix="/usr/local/GL" \
    -Dbuildtype=debug

'

sh ~/Cubyz-app/mesa-rebuild.sh

