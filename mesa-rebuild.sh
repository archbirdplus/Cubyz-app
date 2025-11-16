cd molten-zink

type llvm-ar >/dev/null 2>/dev/null
if [ $? ]
then
    export PATH="/opt/homebrew/opt/llvm@19/bin:$PATH"
else
    echo "$(which llvm-ar) <- llvm-ar already found"
fi

sudo ninja install

# sudo install_name_tool $MOLTENZINKDIR/lib/libGL.1.dylib -add_rpath /usr/local/lib

