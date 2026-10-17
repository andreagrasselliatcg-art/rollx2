#!/bin/bash
# Compila ROLL-X per macOS (Apple Silicon + Intel) e crea l'installer .pkg
set -e
cd "$(dirname "$0")"

VERSION="0.1.0"
NAME="ROLL-X"

cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64"
cmake --build build --config Release

SRC="build/RollX_artefacts/Release/VST3/${NAME}.vst3"
DEST="pkgroot/Library/Audio/Plug-Ins/VST3"

rm -rf pkgroot
mkdir -p "$DEST"
cp -R "$SRC" "$DEST/"

# firma "ad hoc" (necessaria su Apple Silicon, non richiede account sviluppatore)
codesign --force --deep -s - "$DEST/${NAME}.vst3"

pkgbuild --root pkgroot \
         --identifier "com.yourname.rollx.vst3" \
         --version "$VERSION" \
         --install-location "/" \
         "${NAME}-${VERSION}.pkg"

echo "Creato: ${NAME}-${VERSION}.pkg"
