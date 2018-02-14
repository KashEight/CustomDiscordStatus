core:module("PlatformManager")

local CustomDiscordStatus = _G.CustomDiscordStatus
local set_rich_presence_discord_original = WinPlatformManager.set_rich_presence_discord
local update_discord_heist_original = WinPlatformManager.update_discord_heist
local update_discord_character_original = WinPlatformManager.update_discord_character

function WinPlatformManager:set_rich_presence_discord(name)
    set_rich_presence_discord_original(self, name)

    if Global.game_settings.permission == "private" then
    
    elseif Global.game_settings.permission == "friends_only" then
    
    else

    end

    if CustomDiscordStatus:GetOption("custom_strings") then
        local character = _G.CriminalsManager.convert_old_to_new_character_workname(managers.blackmarket:get_preferred_character())
        local character_name = CustomDiscordStatus._data_string["character"][character] or managers.localization:text("menu_" .. managers.blackmarket:get_preferred_character())
        local small_image = "c_" .. character
        
        Discord:set_small_image(small_image, character_name)

        local job_data = managers.job:current_job_data()
        local job_name = job_data and managers.localization:text(job_data.name_id) or "No Heist selected"
        local job_id = job_data and job_data.name_id or "no_briefheist"
        local job_difficulty = _G.tweak_data.difficulties[managers.job:current_difficulty_stars() + 2] or 1
        local job_difficulty_text = CustomDiscordStatus._data_string["difficulty"][job_difficulty] or managers.localization:to_upper_text(_G.tweak_data.difficulty_name_ids[job_difficulty])
        local large_image = job_id

        if CustomDiscordStatus._data_string["heist"][job_id] then
            job_name = CustomDiscordStatus._data_string["heist"][job_id]
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

        self:apply_status(name, job_id, job_name, job_difficulty_text, day_string, large_image, small_image, character_name)
    end
end

function WinPlatformManager:update_discord_heist()
    update_discord_heist_original(self)

    if CustomDiscordStatus:GetOption("custom_strings") then
        local name = self._current_rich_presence

        if name == "MPLobby" then
            local job_data = managers.job:current_job_data()
            local job_name = job_data and managers.localization:text(job_data.name_id) or "No Heist selected"
            local job_id = job_data and job_data.name_id or "no_briefheist"
            local job_difficulty = _G.tweak_data.difficulties[managers.job:current_difficulty_stars() + 2] or 1
            local job_difficulty_text = CustomDiscordStatus._data_string["difficulty"][job_difficulty] or managers.localization:to_upper_text(_G.tweak_data.difficulty_name_ids[job_difficulty])
            local large_image = job_id

            if CustomDiscordStatus._data_string["heist"][job_id] then
                job_name = CustomDiscordStatus._data_string["heist"][job_id]
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

            self:apply_status("update_heist", job_id, job_name, job_difficulty_text, day_string, large_image, nil, nil)
        end
    end
end

function WinPlatformManager:update_discord_character()
    update_discord_character_original(self)

    local character = _G.CriminalsManager.convert_old_to_new_character_workname(managers.blackmarket:get_preferred_character())
    local character_name = CustomDiscordStatus._data_string["character"][character] or managers.localization:text("menu_" .. managers.blackmarket:get_preferred_character())
    local small_image = "c_" .. character

    Discord:set_small_image(small_image, character_name)
end  

function WinPlatformManager:apply_status(name, job_id, job_name, job_difficulty_text, day_string, large_image, small_image, character_name)
    if name == "Idle" then
        Discord:set_status("with CustomDiscordStatus Mod.", "Playing PAYDAY 2")
    elseif name == "MPLobby" then
        local default_under_text = managers.localization:text("discord_rp_lobby")
        local default_up_text = managers.localization:text("discord_rp_lobby_details", {
            heist = job_name,
            difficulty = job_difficulty_text,
            day = day_string
        })
        local base_str = self:advance_strings()
        local job_name_image = CustomDiscordStatus._data_string["heist_image"][job_id] or job_name

        Discord:set_status(default_under_text .. base_str, default_up_text)
        Discord:set_large_image(large_image, job_name_image)
        Discord:set_small_image(small_image, character_name)
    elseif name == "SafeHousePlaying" then
        Discord:set_status(managers.localization:text("discord_rp_safehouse"), managers.localization:text("discord_rp_safehouse_details", {heist = job_name}))
    elseif name == "SPPlaying" then
        local job_name_image = CustomDiscordStatus._data_string["heist_image"][job_id] or job_name

        Discord:set_status(managers.localization:text("discord_rp_single_heist"), managers.localization:text("discord_rp_single_heist_details", {
			heist = job_name,
			difficulty = job_difficulty_text,
			day = day_string
        }))
        
        Discord:set_large_image(large_image, job_name_image)
		Discord:set_small_image(small_image, character_name)
    elseif name == "MPPlaying" then
        local default_under_text = managers.localization:text("discord_rp_mp_heist")
        local default_up_text = managers.localization:text("discord_rp_mp_heist_details", {
			heist = job_name,
			difficulty = job_difficulty_text,
			day = day_string
        })
        local base_str = self:advance_strings()
        local job_name_image = CustomDiscordStatus._data_string["heist_image"][job_id] or job_name
        
        Discord:set_status(default_under_text .. base_str, default_up_text)
        Discord:set_large_image(large_image, job_name_image)
		Discord:set_small_image(small_image, character_name)
    elseif name == "SPEnd" then
        local job_name_image = CustomDiscordStatus._data_string["heist_image"][job_id] or job_name

        Discord:set_status(managers.localization:text("discord_rp_single_end"), managers.localization:text("discord_rp_single_end_details", {
			heist = job_name,
			day = day_string
        }))
        Discord:set_large_image(large_image, job_name_image)
		Discord:set_small_image(small_image, character_name)
    elseif name == "MPEnd" then
        local default_under_text = managers.localization:text("discord_rp_mp_end")
        local default_up_text = managers.localization:text("discord_rp_mp_end_details", {
			heist = job_name,
			day = day_string
        })
        local base_str = self:advance_strings()
        local job_name_image = CustomDiscordStatus._data_string["heist_image"][job_id] or job_name

        Discord:set_status(default_under_text .. base_str, default_up_text) 
        Discord:set_large_image(large_image, job_name_image)
        Discord:set_small_image(small_image, character_name)
    elseif name == "update_heist" then
        local default_under_text = managers.localization:text("discord_rp_lobby")
        local default_up_text = managers.localization:text("discord_rp_lobby_details", {
            heist = job_name,
            difficulty = job_difficulty_text,
            day = day_string
        })
        local base_str = self:advance_strings()
        local job_name_image = CustomDiscordStatus._data_string["heist_image"][job_id] or job_name

        Discord:set_status(default_under_text .. base_str, default_up_text)
        Discord:set_large_image(large_image, job_name_image)
    end
end

function WinPlatformManager:advance_strings()
    local base_str = ""
    local peers = CustomDiscordStatus:Peers()

    if CustomDiscordStatus:GetOption("show_host") and CustomDiscordStatus:GetOption("show_member") then
        base_str = " | Host: " .. peers[1]:name() .. ", Member: " .. peers[1]:name()

        for i = 2, #peers do
            base_str = base_str .. ", " .. peers[i]:name()
        end

    elseif CustomDiscordStatus:GetOption("show_member") then
        base_str = " | Member: " .. peers[1]:name()

        for i = 2, #peers do
            base_str = base_str .. ", " .. peers[i]:name()
        end

    elseif CustomDiscordStatus:GetOption("show_host") then
        base_str = " | Host: " .. peers[1]:name()
    end

    return base_str
end