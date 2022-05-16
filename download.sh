#!/bin/bash

mkdir build
cd build
git clone https://github.com/Kobo-InkBox/inkbox build_inkbox
git clone https://github.com/Kobo-InkBox/oobe-inkbox build_oobe-inkbox
git clone https://github.com/Kobo-InkBox/lockscreen build_lockscreen

echo "Have fun crosscompiling these! :)"
echo "Don't forget to turn off shadow builds in qt creator, if you are using it"
