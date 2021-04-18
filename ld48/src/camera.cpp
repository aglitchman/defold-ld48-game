#include "camera.h"

namespace Ld48Camera
{
    static Camera camera(glm::vec3(0.0f, 0.0f, 0.0f));

    static int Dummy(lua_State* L)
    {
        DM_LUA_STACK_CHECK(L, 0);

        dmLogInfo("Hello, world, from camera!");

        return 0;
    }

    // Functions exposed to Lua
    static const luaL_reg Module_methods[] = { { "dummy", Dummy },
                                               /* Sentinel: */
                                               { NULL, NULL } };

    void LuaInit(lua_State* L)
    {
        int top = lua_gettop(L);

        // Register lua names
        luaL_register(L, "ld48_camera", Module_methods);

        lua_pop(L, 1);
        assert(top == lua_gettop(L));
    }
} // namespace Ld48Camera
