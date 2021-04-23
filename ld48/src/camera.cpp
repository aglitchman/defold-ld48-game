#include "camera.h"

#include <glm/glm.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <glm/gtc/matrix_transform.hpp>

namespace Ld48Camera
{
    static Camera camera(glm::vec3(0.0f, 0.0f, 0.0f));

    static int Perspective(lua_State* L)
    {
        DM_LUA_STACK_CHECK(L, 16);

        glm::mat4 projection = glm::perspective(glm::radians(45.0f), 2500.0f / 1400.0f, 0.1f, 100.0f);

        float *p = glm::value_ptr(projection);
        for (size_t i = 0; i < 16; i++)
        {
            lua_pushnumber(L, p[i]);
        }

        return 16;
    }

    // Functions exposed to Lua
    static const luaL_reg Module_methods[] = { { "perspective", Perspective },
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
