#!/bin/sh
CMAKE=/Applications/CMake.app/Contents/bin/cmake
rm -rf _build_ios
mkdir _build_ios
cd _build_ios
$CMAKE -G"Xcode" -DCMAKE_TOOLCHAIN_FILE=../cmake/ios/toolchain/iOS.cmake -DLUA_USE_IOS=On -DBUILD_SHARED_LIBS=Off ..
$CMAKE --build . --config Release


