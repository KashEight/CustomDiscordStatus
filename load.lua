if not Steam then
    return
end

CustomDiscordStatus = CustomDiscordStatus or {}

if not CustomDiscordStatus._setup then
    CustomDiscordStatus._hooks = {
        ["lib/managers/platformmanager"] = "platformmanager.lua"
    }
    CustomDiscordStatus._mod_file = {}

    function CustomDiscordStatus:doScript(script)
        local baseScript = script:lower()
        if self._hooks[baseScript] then
            local file_name = ModPath .. "lua/" .. self._hooks[baseScript]
            if io.file_is_readable(file_name) then
                log("[Info] CustomDiscordStatus was succeessfully loaded!")
                dofile(file_name)
            else
                log("[Error] BLT could not open script '" .. file_name .. "'.")
            end
        elseif self._mod_file[baseScript] then
        end
        else
            log("[Error] Unregistered script called: " .. baseScript)
        end
    end

    CustomDiscordStatus._setup = true
end

if RequiredScript then
    CustomDiscordStatus:doScript(RequiredScript)
end
        