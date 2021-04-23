local M = {}

-- Print errors in the release build of the game (HTML5 only)
function M.error_catching_init()
    local is_release_build = not sys.get_engine_info().is_debug
    if html5 and is_release_build then
        sys.set_error_handler(function(source, message, traceback)
            local s = source:gsub("'", "\\'"):gsub("\n", "\\n"):gsub("\r", "\\r")
            local m = message:gsub("'", "\\'"):gsub("\n", "\\n"):gsub("\r", "\\r")
            local t = traceback:gsub("'", "\\'"):gsub("\n", "\\n"):gsub("\r", "\\r")

            local pstatus, perr = pcall(html5.run, "console.warn('ERROR: (" .. s .. ")\\n" .. m .. "\\n" .. t .. "')")
            if not pstatus then
                print("FATAL: html5.run(..) failed: " .. perr)
            end
        end)
    end
end

function M.random_init()
    math.random = splitmix64.random
    math.randomseed = splitmix64.randomseed
    math.randomseed((socket.gettime() % 1) * 100000)
end

return M