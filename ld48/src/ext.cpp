#include "camera.h"

#include <dmsdk/sdk.h>
#ifdef EMSCRIPTEN
#include <emscripten.h>
#endif

#define GLFW_MOUSE_CURSOR 0x00030001
extern "C"
{
    void glfwDisable(int token);
    void glfwEnable(int token);
}

static int GlfwMouseLock(lua_State* L)
{
    glfwDisable(GLFW_MOUSE_CURSOR);
    return 0;
}

static int GlfwMouseUnlock(lua_State* L)
{
    glfwEnable(GLFW_MOUSE_CURSOR);
    return 0;
}

#ifdef EMSCRIPTEN
static bool m_PointerLocked;

static int Html5PointerLocked(lua_State* L)
{
    DM_LUA_STACK_CHECK(L, 1);
    lua_pushboolean(L, m_PointerLocked);
    return 1;
}

extern "C" void EMSCRIPTEN_KEEPALIVE Html5PointerLockChangeEvent(bool locked)
{
    m_PointerLocked = locked;
}

static void Html5PointerLockInit()
{
    EM_ASM({
        var cb = function()
        {
            _Html5PointerLockChangeEvent((
                                         document.pointerLockElement ||
                                         document.mozPointerLockElement ||
                                         document.webkitPointerLockElement ||
                                         document.msPointerLockElement) == Module.canvas);
        };
        var cb_err = function(e) {
            // console.log(e);
        };
        if ('onpointerlockchange' in document)
        {
            document.addEventListener('pointerlockchange', cb, false);
            document.addEventListener('pointerlockerror', cb_err, false);
        }
        else if ('onmozpointerlockchange' in document)
        {
            document.addEventListener('mozpointerlockchange', cb, false);
            document.addEventListener('mozpointerlockerror', cb_err, false);
        }
        else if ('onwebkitpointerlockchange' in document)
        {
            document.addEventListener('webkitpointerlockchange', cb, false);
            document.addEventListener('webkitpointerlockerror', cb_err, false);
        }
        else if ('onmspointerlockchange' in document)
        {
            document.addEventListener('mspointerlockchange', cb, false);
            document.addEventListener('mspointerlockerror', cb_err, false);
        }
    });
}
#endif

static int Dummy(lua_State* L)
{
    DM_LUA_STACK_CHECK(L, 0);

    dmLogInfo("Hello, world!");

    return 0;
}

// Functions exposed to Lua
static const luaL_reg Module_methods[] = {
    { "glfw_mouse_lock", GlfwMouseLock },
    { "glfw_mouse_unlock", GlfwMouseUnlock },
#ifdef EMSCRIPTEN
    { "html5_pointer_locked", Html5PointerLocked },
#endif
    { "dummy", Dummy },
    /* Sentinel: */
    { NULL, NULL }
};

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
