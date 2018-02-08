if not Steam then
    return
end

CustomDiscordStatus = CustomDiscordStatus or {}

if not CustomDiscordStatus._setup then
    CustomDiscordStatus._path = ModPath
    CustomDiscordStatus._data = {}
    CustomDiscordStatus._data_path = SavePath .. "CustomDiscordStatus.json"
    CustomDiscordStatus._hooks = {
        ["lib/managers/platformmanager"] = "PlatformManager.lua"
        ["lib/managers/menumanager"] = "MenuManager.lua"
    }
    CustomDiscordStatus._menus = {
        "customdiscordstatus_options.json"
        "customdiscordstatus_core.json"
    }
    CustomDiscordStatus._mod_files = {
        ["strings"] = "strings.json"
    }
    CustomDiscordStatus._language = {
        [1] = "english",
        [2] = "japanese"
    }

    function CustomDiscordStatus:doScript(script)
        local baseScript = script:lower()
        if self._hooks[baseScript] then
            local file_name = self._path .. "lua/" .. self._hooks[baseScript]
            if io.file_is_readable(file_name) then
                log("[Info] CustomDiscordStatus was succeessfully loaded!")
                dofile(file_name)
            else
                log("[Error] BLT could not open script '" .. file_name .. "'.")
            end
        elseif self._mod_file[baseScript] then
            log("pass")
        else
            log("[Error] Unregistered script called: " .. baseScript)
        end
    end

    function CustomDiscordStatus:Save()
        local file = io.open(self._data_path, "w+")

        if file then
            file:write(json.encode(self._data))
            file:close()
        end
    end

    function CustomDiscordStatus:Load()
        self:LoadDefault()

        local file = io.open(self._data_path, "r")

        if file then
            local cfg = json.decode(file:read("*a"))
            file:close()
            for k, v in pairs(cfg) do
                self._data[k] = v
            end
        end

        self:Save()
    end

    function CustomDiscordStatus:LoadDefault()
        local default_file = io.open(self._path .. "menu/customdiscordstatus_default.json")
        self._data = json.decode(default_file:read("*a"))
        default_file:close()
    end

    function CustomDiscordStatus:InitAllMenus()
    end

    function CustomDiscordStatus:GetOption(id)
        return self._data[id]
    end

    function CustomDiscordStatus:Session()
        return managers.network:session()
    end

    function CustomDiscordStatus:Peers()
        return self:Session():all_peers()
    end

    CustomDiscordStatus._setup = true
end

if RequiredScript then
    CustomDiscordStatus:doScript(RequiredScript)
end

--[[
    TODO:
    Write MenuManager.lua - High
    Write menus - High
    Write InitAllMenus() method - High
    Write PlatformManager.lua - Middle
    Write realtime update - Low
]]