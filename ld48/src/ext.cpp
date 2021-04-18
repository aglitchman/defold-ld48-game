#include "camera.h"

#include <dmsdk/sdk.h>

static int Dummy(lua_State* L)
{
    DM_LUA_STACK_CHECK(L, 0);

    dmLogInfo("Hello, world!");

    return 0;
}

// Functions exposed to Lua
static const luaL_reg Module_methods[] = { { "dummy", Dummy },
                                           /* Sentinel: */
                                           { NULL, NULL } };

static void LuaInit(lua_State* L)
{
    int top = lua_gettop(L);

    // Register lua names
    luaL_register(L, "ld48", Module_methods);

    lua_pop(L, 1);
    assert(top == lua_gettop(L));
}

static dmExtension::Result InitializeExt(dmExtension::Params* params)
{
    LuaInit(params->m_L);
    Ld48Camera::LuaInit(params->m_L);
    return dmExtension::RESULT_OK;
}

static dmExtension::Result FinalizeExt(dmExtension::Params* params)
{
    return dmExtension::RESULT_OK;
}

DM_DECLARE_EXTENSION(LD48, "LD48", 0, 0, InitializeExt, 0, 0, FinalizeExt)
