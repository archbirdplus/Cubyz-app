#!/bin/bash

cd "$(dirname "$0")"

HAS_DEPS=1

# Ideally this would prefer the /Applications official XQuartz, fallback to packaged.
# In other news, all X11 libraries can be found in XQuartz, so we can avoid brew.
if ! [ -f /opt/homebrew/opt/llvm/lib/libLLVM.dylib ]; then
	HAS_DEPS=0
fi
if ! [ -r /Applications/Utilities/XQuartz.app ]; then
	HAS_DEPS=0
fi
if ! open -a XQuartz.app; then
    HAS_DEPS=0
fi

if [ $HAS_DEPS = 0 ]; then
    open -W Install.sh -a Terminal
    open -a XQuartz.app
fi

DYLD_LIBRARY_PATH=../Library GALLIUM_DRIVER=llvmpipe MESA_GL_VERSION_OVERRIDE=4.6 MESA_LOADER_DRIVER_OVERRIDE= LP_NUM_THREADS= ./Cubyzig 2>&1 >./trace
# DYLD_LIBRARY_PATH=../Library GALLIUM_DRIVER=zink MESA_GL_VERSION_OVERRIDE=4.6 MESA_LOADER_DRIVER_OVERRIDE= LP_NUM_THREADS= ./Cubyzig

