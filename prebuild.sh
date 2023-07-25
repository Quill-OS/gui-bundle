#!/bin/bash

export PATH=$PATH:/home/build/inkbox/compiled-binaries/arm-kobo-linux-gnueabihf/bin/

rm -rf build
mkdir build
cd build

git clone https://github.com/Kobo-InkBox/inkbox.git build_inkbox
git clone https://github.com/Kobo-InkBox/lockscreen.git build_lockscreen
git clone https://github.com/Kobo-InkBox/oobe-inkbox.git build_oobe-inkbox\

cd build_inkbox/
git submodule update --init --recursive
/home/build/inkbox/compiled-binaries/qt-bin/qt-linux-5.15.2-kobo/bin/qmake
make -j 16
cd ..

cd build_lockscreen/
/home/build/inkbox/compiled-binaries/qt-bin/qt-linux-5.15.2-kobo/bin/qmake
make -j 16
cd ..

cd build_oobe-inkbox/
/home/build/inkbox/compiled-binaries/qt-bin/qt-linux-5.15.2-kobo/bin/qmake
make -j 16
cd ..

cd ..
