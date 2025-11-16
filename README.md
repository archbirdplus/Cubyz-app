# Cubyz-app

This repo contains some files useful for bundling Cubyz for MacOS. There are a couple ways to do this.

## Installing from DMG

This is the most direct way to run Cubyz. Download `Cubyz.dmg` from the [Releases](https://github.com/archbirdplus/cubyz-app/releases). Then open the dmg, drag Cubyz.app into some folder, and _right-click_ -> "Open" -> "Open Anyways".

Cubyz.app will try to install two things: XQuartz and LLVM. These are both necessary for this implementation of Cubyz. LLVM is installed through brew which may require administrator privileges.

## Building `Cubyz.dmg` yourself

To get a `Cubyz.app` bundle:
1. Compile the `Cubyzig` executable.
    - This project looks for the executable in `../Cubyz/zig-out/bin/Cubyz`.
2. Obtain `libGL.1.dylib`.
    - This projects expects `libGL.1.dylib` and `libglapi.0.dylib` in `/usr/local/GL/lib/`.
    - You can find these files in [Releases](https://github.com/archbirdplus/cubyz-app/releases) or compile Mesa drivers yourself.
3. Go to to Cubyz-app, and run `sh all.sh`. That will then
    - `grab_logo.sh`: fetches the `logo.png` from Cubyz to use as the app icon.
    - `setup.sh`: collects and installs all necessary libraries into the Cubyz.app bundle.
    - `package.sh`: compresses Cubyz.app into the `Cubyz.dmg` for distribution.

## Building `Cubyzig`

`Cubyzig` is not provided here as Cubyz is in rapid development. Compiling Cubyz for MacOS might require some additional changes, possibly including:
1. Make sure XQuartz and a recent version of LLVM are installed.
2. Download [Cubyz-libs](https://github.com/PixelGuys/Cubyz-libs).
3. You will need to patch `glfw` to support X11 libraries on MacOS. If you don't know how:
    - Download my [fork](https://github.com/archbirdplus/glfw/tree/mac-x11) of `glfw` next to Cubyz.
    - Update the Cubyz-libs `build.zig.zon`'s dependency to say `.path = "../glfw"`
4. You may need to modify `build.zig` to enable vulkan-related blocks labeled with `TODO(blackedout)` unless you modify Cubyz sources yourself.
5. Compile: `$CUBYZ_ZIG build native -Doptimize=ReleaseSafe`

## Building Mesa drivers

1. Download [Mesa](https://gitlab.freedesktop.org/mesa/mesa).
2. Compile Mesa with `x11`, `llvmpipe`, `xlib`.
    - Mesa's build system uses `meson` and `ninja`. The [docs](https://docs.mesa3d.org/install.html) [may](https://docs.mesa3d.org/macos.html) be useful.
    - For reference, check out [`mesa-build.sh`](https://github.com/archbirdplus/Cubyz-app/tree/main/mesa-build.sh) and [`mesa-rebuild.sh`](https://github.com/archbirdplus/Cubyz-app/tree/main/mesa-rebuild.sh). Be careful though, as those may nuke your system :)
    - Specific versions of Mesa/LLVM are not compatible with each other. The latest (24.1/21.1.5).
    - Make sure it installs in `/usr/local/GL` (which may require sudo access), otherwise modify `setup.sh` to check in a different directory.

`XCODE_SYSROOT` should be set to something like `/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk` (a directory such that `$XCODE_SYSROOT/usr`). Remove `MOLTENVK_DIR` if you don't have the MoltenVK SDK.

It _may_ be possible to compile `iris` drivers for Intel Macs in addition to `llvmpipe`. It _may_ be possible to build `zink` drivers with MoltenVK.

