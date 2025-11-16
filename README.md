# Cubyz-app

Files necessary for creating bundled Cubyz distributions for MacOS.

## Usage

This project expects to be in the same root directory as Cubyz, i.e. you should have `~/Cubyz` and `~/Cubyz-app`.

To get a `Cubyz.app` bundle:
1. Compile Cubyz in its main directory.
2. Go to to Cubyz-app, and run `sh all.sh`

Note:
`all.sh` will then run the following:
- `grab_logo.sh`: fetches the `logo.png` from Cubyz to use as the app icon.
- `setup.sh`: collects and installs all necessary libraries into the Cubyz.app bundle.
- `package.sh`: compresses Cubyz.app into the `Cubyz.dmg` for distribution.

It also expects the files `libGL.1.dylib` and `libglapi.0.dylib` to be located in `usr/local/GL/lib`. These can be found in the [Releases](https://github.com/archbirdplus/cubyz-app/releases) section, along with pre-compiled `.dmg` file.

## Compiling Mesa:

TODO

