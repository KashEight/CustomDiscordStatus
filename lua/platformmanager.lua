core:module("PlatformManager")

local set_rich_presence_discord_original = WinPlatformManager.set_rich_presence_discord

function WinPlatformManager:set_rich_presence_discord(name)
	set_rich_presence_discord_original(self, name)

    if name == "Idle" then
        Discord:set_status("ドリップコーヒー", "香風智乃のおパンツ")
	end
end