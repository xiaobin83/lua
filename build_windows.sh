#!/bin/sh
rm -rf _build_windows_x86
mkdir _build_windows_x86
cd _build_windows_x86
cmake -G"Visual Studio 14 2015" -DCMAKE_BUILD_TYPE=Release ..
cmake --build .

cd ..

rm -rf _build_windows_x86_64
mkdir _build_windows_x86_64
cd _build_windows_x86_64
cmake -G"Visual Studio 14 2015 Win64" -DCMAKE_BUILD_TYPE=Release ..
cmake --build .

