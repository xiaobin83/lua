#define LUA_LIB

#include "lua.h"
#include "ltm.h"
#include "lobject.h"

LUA_API int lua_const_LUA_REGISTRYINDEX()
{
	return LUA_REGISTRYINDEX;
}

LUA_API const char* lua_const_ttypename(int t)
{
	if (t >= 0 && t < LUA_TOTALTAGS)
		return ttypename(t);
	return "invalid_type";
}

