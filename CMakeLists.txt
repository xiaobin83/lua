# Copyright (C) 2007-2015 LuaDist.
# Created by Peter Drahoš, Peter Kapec
# Redistribution and use of this file is allowed according to the terms of the MIT license.
# For details see the COPYRIGHT file distributed with LuaDist.
# Please note that the package source code is licensed under its own license.

# modified by 0x600d1dea <xiaobin.huang@gmail.com>
#    removed loadlib_rel, dont understand the propers. lua doing it quite well.
#    removed LUA_PATH, LUA_CPATH and LUA_INIT

project ( lua C )
cmake_minimum_required ( VERSION 2.8 )
include ( cmake/dist.cmake )

## CONFIGURATION
# Default configuration (we assume POSIX by default)

# 0x600d1dea, removed LUA_PATH, LUA_CPATH and LUA_INIT. 


option ( LUA_USE_C89 "Use only C89 features." OFF )
option ( LUA_32BITS "Use 32-bit integer and float." OFF )
option ( LUA_COMPAT_5_1 "Enable backwards compatibility options with lua-5.1." ON )
option ( LUA_COMPAT_5_2 "Enable backwards compatibility options with lua-5.2." ON )

#2DO: LUAI_* and LUAL_* settings, for now defaults are used.

set ( LUA_MODULE_SUFFIX ${CMAKE_SHARED_MODULE_SUFFIX} )

if ( WIN32 AND NOT CYGWIN )
  # Windows systems
  option ( LUA_USE_WINDOWS "Windows specific build." ON )
  option ( LUA_BUILD_WLUA "Build wLua interpretter without console output." ON )
  option ( LUA_BUILD_AS_DLL "Build Lua library as Dll." ${BUILD_SHARED_LIBS} )

else ( POSIX )

  # Posix systems (incl. Cygwin)
  option ( LUA_USE_POSIX "Use POSIX features." ON )
  option ( LUA_USE_DLOPEN "Use dynamic linker to load modules." ON )
  # Apple and Linux specific
  if ( LINUX OR APPLE )
    option ( LUA_USE_AFORMAT "Assume 'printf' handles 'aA' specifiers" ON )
  endif ( )

endif ( )

## SETUP
# Optional libraries
find_package ( Readline )
if ( READLINE_FOUND )
  option ( LUA_USE_READLINE "Use readline in the Lua CLI." ON )
endif ( )

# Setup needed variables and libraries
if ( LUA_USE_POSIX OR LUA_USE_ANDROID )
  # On POSIX Lua links to standard math library "m"
  list ( APPEND LIBS m )
endif ( )

if ( LUA_USE_DLOPEN )
  # Link to dynamic linker library "dl"
	find_library ( DL_LIBRARY NAMES dl )
	if ( DL_LIBRARY )
    list ( APPEND LIBS ${DL_LIBRARY} )
	endif ( )
endif ( )

if ( LUA_USE_READLINE )
  # Add readline
  include_directories ( ${READLINE_INCLUDE_DIR} )
  list ( APPEND LIBS ${READLINE_LIBRARY} )
endif ( )

## SOURCES
# Generate luaconf.h
configure_file ( src/luaconf.h.in ${CMAKE_CURRENT_BINARY_DIR}/luaconf.h )

# Sources and headers
include_directories ( src ${CMAKE_CURRENT_BINARY_DIR} )
set ( SRC_CORE src/lapi.c src/lcode.c src/lctype.c src/ldebug.c src/ldo.c src/ldump.c
  src/lfunc.c src/lgc.c src/llex.c src/lmem.c src/lobject.c src/lopcodes.c src/lparser.c
  src/lstate.c src/lstring.c src/ltable.c src/ltm.c src/lundump.c src/lvm.c src/lzio.c )
set ( SRC_LIB src/lauxlib.c src/lbaselib.c src/lbitlib.c src/lcorolib.c src/ldblib.c
  src/liolib.c src/lmathlib.c src/loslib.c src/lstrlib.c src/ltablib.c src/lutf8lib.c 
  src/linit.c src/loadlib.c)
set ( SRC_LUA src/lua.c )
set ( SRC_LUAC src/luac.c src/ldump.c src/lopcodes.c )

# extra lconst
set ( SRC_EXTRA_LCONST extra/lconst.c )

# extra lpeg
file (GLOB SRC_EXTRA_LPEG extra/lpeg/*.h extra/lpeg/*.c)


set ( SRC_EXTRA ${SRC_EXTRA_LCONST} ${SRC_EXTRA_LPEG} )

## BUILD
# Create lua library
source_group ( "extra" FILES ${SRC_EXTRA_LCONST} )
source_group ( "extra\\lpeg" FILES ${SRC_EXTRA_LPEG} )


add_library ( liblua ${SRC_CORE} ${SRC_LIB} ${LUA_DLL_RC} ${SRC_EXTRA} )
target_link_libraries ( liblua ${LIBS} )
set_target_properties ( liblua PROPERTIES OUTPUT_NAME lua CLEAN_DIRECT_OUTPUT 1 )
if ( LUA_BUILD_AS_DLL )
  set_target_properties ( liblua PROPERTIES COMPILE_DEFINITIONS LUA_BUILD_AS_DLL )
endif ()

if (NOT LUA_USE_IOS)
  add_executable ( lua ${SRC_LUA} src/lua.rc )
  target_link_libraries ( lua liblua )

  add_executable ( luac ${SRC_LUAC} src/luac.rc )
  target_link_libraries ( luac liblua )

  # On windows a variant of the lua interpreter without console output needs to be built
  if ( LUA_BUILD_WLUA )
    add_executable ( wlua WIN32 src/wmain.c ${SRC_LUA} src/lua.rc )
    target_link_libraries ( wlua liblua )
    install_executable ( wlua )
  endif ( )

  install_executable ( lua luac )
  install_library ( liblua )
  install_data ( README.md )
  install_header ( src/lua.h src/lualib.h src/lauxlib.h src/lua.hpp ${CMAKE_CURRENT_BINARY_DIR}/luaconf.h )
  install_doc ( doc/ )
  install_foo ( etc/ )
endif ()


