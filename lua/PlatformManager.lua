core:module("PlatformManager")

local CustomDiscordStatus = _G.CustomDiscordStatus
local set_rich_presence_discord_original = WinPlatformManager.set_rich_presence_discord
local update_discord_heist_original = WinPlatformManager.update_discord_heist

function WinPlatformManager:set_rich_presence_discord(name)
    set_rich_presence_discord_original(self, name)

    if CustomDiscordStatus:GetOption("custom_strings") then
        if name == "Idle" then
            Discord:set_status("Note: This option won't be added xD", "SydneyHUD will be update soon...")
        elseif name == "MPLobby" then
            local peers = CustomDiscordStatus:Peers()

            if CustomDiscordStatus:GetOption("show_host") and CustomDiscordStatus:GetOption("show_member") then
                local base_str = "Host: " .. peers[1]:name() .. ", Member: " .. peers[1]:name()

                for i = 2, #peers do
                    base_str = base_str .. ", " .. peers[i]:name()
                end

                Discord:set_status(base_str, "Lobby")
            end
        end
    end
end

function WinPlatformManager:update_discord_heist()
    update_discord_heist_original(self)

    if CustomDiscordStatus:GetOption("custom_strings") then
        if name == "MPLobby" then
            local peers = CustomDiscordStatus:Peers()

            if CustomDiscordStatus:GetOption("show_host") and CustomDiscordStatus:GetOption("show_member") then
                local base_str = "Host: " .. peers[1]:name() .. ", Member: " .. peers[1]:name()

                for i = 2, #peers do
                    base_str = base_str .. ", " .. peers[i]:name()
                end

                Discord:set_status(base_str, "Lobby")
            end
        end
    end
end