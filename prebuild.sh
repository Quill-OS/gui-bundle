#!/bin/bash

[ -z "${THREADS}" ] && echo "Warning: THREADS environment variable wasn't set. Running with only one thread." && THREADS=1

export PATH="${PATH}:/home/build/inkbox/compiled-binaries/arm-kobo-linux-gnueabihf/bin/"

rm -rf build
mkdir build
pushd build/

git clone https://github.com/Kobo-InkBox/inkbox.git build_inkbox
git clone https://github.com/Kobo-InkBox/lockscreen.git build_lockscreen
git clone https://github.com/Kobo-InkBox/oobe-inkbox.git build_oobe-inkbox

pushd build_inkbox/
git submodule update --init --recursive
/home/build/inkbox/compiled-binaries/qt-bin/qt-linux-5.15.2-kobo/bin/qmake
make -j${THREADS}
popd

pushd build_lockscreen/
/home/build/inkbox/compiled-binaries/qt-bin/qt-linux-5.15.2-kobo/bin/qmake
make -j${THREADS}
popd

pushd build_oobe-inkbox/
/home/build/inkbox/compiled-binaries/qt-bin/qt-linux-5.15.2-kobo/bin/qmake
make -j${THREADS}
popd

popd
