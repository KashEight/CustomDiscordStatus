core:module("PlatformManager")

local CustomDiscordStatus = _G.CustomDiscordStatus
local set_rich_presence_discord_original = WinPlatformManager.set_rich_presence_discord
local update_discord_heist_original = WinPlatformManager.update_discord_heist

function WinPlatformManager:set_rich_presence_discord(name)
    set_rich_presence_discord_original(self, name)

    local character = _G.CriminalsManager.convert_old_to_new_character_workname(managers.blackmarket:get_preferred_character())
    local character_name = CustomDiscordStatus._data_string["character"][character] or managers.localization:text("menu_" .. managers.blackmarket:get_preferred_character())
    local small_image = "c_" .. character

    Discord:set_small_image(small_image, character_name)

	local job_data = managers.job:current_job_data()
	local job_name = job_data and managers.localization:text(job_data.name_id) or "No Heist selected"
	local job_id = job_data and job_data.name_id or "no_briefheist"
	local job_difficulty = _G.tweak_data.difficulties[managers.job:current_difficulty_stars() + 2] or 1
	local job_difficulty_text = CustomDiscordStatus._data_string["difficulty"][job_difficulty] or managers.localization:to_upper_text(_G.tweak_data.difficulty_name_ids[job_difficulty])

    if job_data and CustomDiscordStatus._data_string["heist"][job_data.name_id] then
        job_name = CustomDiscordStatus._data_string["heist"][job_data.name_id]
    end

	if job_name == "No Heist selected" then
        job_difficulty_text = CustomDiscordStatus._data_string["difficulty"]["no_selected"] or "-"
	end

	local day_string = ""

	if #(managers.job:current_job_chain_data() or {}) > 1 then
        day_string = managers.localization:text("discord_rp_day_string", {day = tostring(managers.job:current_stage())})
    end
    
    day_string = CustomDiscordStatus._data_string["day"][day_string] or day_string

	if managers.crime_spree and managers.crime_spree:is_active() then
		local level_id = Global.game_settings.level_id
		local name_id = level_id and _G.tweak_data.levels[level_id] and _G.tweak_data.levels[level_id].name_id

		if name_id then
		    job_name = managers.localization:text(name_id) or job_name
		end
	end

	local large_image = job_id

    if CustomDiscordStatus:GetOption("custom_strings") then
        if name == "Idle" then
            Discord:set_status("with CustomDiscordStatus Mod.", "Playing PAYDAY 2")
        elseif name == "MPLobby" then
            local peers = CustomDiscordStatus:Peers()
            local default_under_text = managers.localization:text("discord_rp_lobby")
            local default_up_text = managers.localization:text("discord_rp_lobby_details", {
                heist = job_name,
                difficulty = job_difficulty_text,
                day = day_string
            })

            if CustomDiscordStatus:GetOption("show_host") and CustomDiscordStatus:GetOption("show_member") then
                local base_str = "Host: " .. peers[1]:name() .. ", Member: " .. peers[1]:name()

                for i = 2, #peers do
                    base_str = base_str .. ", " .. peers[i]:name()
                end

                Discord:set_status(default_under_text .. " | " .. base_str, default_up_text)
            elseif CustomDiscordStatus:GetOption("show_member") then
                local base_str = "Member: " .. peers[1]:name()

                for i = 2, #peers do
                    base_str = base_str .. ", " .. peers[i]:name()
                end

                Discord:set_status(default_under_text .. " | " .. base_str, default_up_text)
            elseif CustomDiscordStatus:GetOption("show_host") then
                local base_str = "Host: " .. peers[1]:name()

                Discord:set_status(default_under_text .. " | " .. base_str, default_up_text)
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