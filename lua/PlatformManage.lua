core:module("PlatformManager")

local set_rich_presence_discord_original = WinPlatformManager.set_rich_presence_discord
local update_discord_heist_original = WinPlatformManager.update_discord_heist

function WinPlatformManager:set_rich_presence_discord(name)
    set_rich_presence_discord_original(self, name)

    if name == "Idle" then
        Discord:set_status("ドリップコーヒー", "香風智乃のおパンツ")
    elseif name == "MPLobby" then
        local peers = CustomDiscordStatus:Peers()
        local base_str = "Host: " .. peers[1]:name() .. ", Member: " .. peers[1]:name()

        if #peers == 1 then
            Discord:set_status(base_str, "Lobby")
        elseif #peers == 2 then
            local member = peers[2]:name()
            Discord:set_status(base_str .. ", " .. member, "Lobby")
        elseif #peers == 3 then
            local member = peers[2]:name() .. ", " .. peers[3]:name()
            Discord:set_status(base_str .. ", " .. member, "Lobby")
        elseif #peers == 4 then
            local member = peers[2]:name() .. ", " .. peers[3]:name() .. ", " .. peers[4]:name()
            Discord:set_status(base_str .. ", " .. member, "Lobby")
        end
	end
end

function WinPlatformManager:update_discord_heist()
    update_discord_heist_original(self)

    if name == "MPLobby" then
        local peers = CustomDiscordStatus:Peers()
        local base_str = "Host: " .. peers[1]:name() .. ", Member: " .. peers[1]:name()

        if #peers == 1 then
            Discord:set_status(base_str, "Lobby")
        elseif #peers == 2 then
            local member = peers[2]:name()
            Discord:set_status(base_str .. ", " .. member, "Lobby")
        elseif #peers == 3 then
            local member = peers[2]:name() .. ", " .. peers[3]:name()
            Discord:set_status(base_str .. ", " .. member, "Lobby")
        elseif #peers == 4 then
            local member = peers[2]:name() .. ", " .. peers[3]:name() .. ", " .. peers[4]:name()
            Discord:set_status(base_str .. ", " .. member, "Lobby")
        end
    end
end