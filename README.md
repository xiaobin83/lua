
This is Lua 5.3.3, released on 30 May 2016. [![Build Status](https://travis-ci.org/xiaobin83/lua.svg?branch=master)](https://travis-ci.org/xiaobin83/lua)

For installation instructions, license details, and
further information about Lua, see doc/readme.html.

Build for Android,
	cmake.exe -G"MinGW Makefiles" 
			  -DCMAKE_TOOLCHAIN_FILE=pathto/cmake/android/android.toolchain.cmake 
			  -DCMAKE_MAKE_PROGRAM="$ANDROID_NDK/prebuilt/windows-x86_64/bin/make.exe" 
			  -DCMAKE_BUILD_TYPE=Release -DANDROID_ABI="armeabi-v7a" 
			  -DLUA_USE_ANDROID=On 
			  -DANDROID_NATIVE_API_LEVEL=android-15 
			  path/to/source && cmake --build .
