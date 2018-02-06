core:module("PlatformManager")
core:import("CoreEvent")

WinPlatformManager = WinPlatformManager or class(GenericPlatformManager)
PlatformManager.PLATFORM_CLASS_MAP[_G.Idstring("WIN32"):key()] = WinPlatformManager

function WinPlatformManager:set_rich_presence_discord(name)
	Discord:set_status("", "")
	Discord:set_start_time(0)
	Discord:set_large_image("cover", "PAYDAY 2")
	Discord:set_small_image("", "")
    Discord:set_party_size(0, 0)

	if Global.game_settings.permission == "private" then
		return
	end

	local character = _G.CriminalsManager.convert_old_to_new_character_workname(managers.blackmarket:get_preferred_character())
	local character_name = managers.localization:text("menu_" .. managers.blackmarket:get_preferred_character())
	local small_image = "c_" .. character

	Discord:set_small_image(small_image, character_name)

	local in_lobby = _G.game_state_machine and (_G.game_state_machine:current_state_name() == "ingame_lobby_menu" or _G.game_state_machine:current_state_name() == "menu_main")
	local job_data = managers.job:current_job_data()
	local job_name = job_data and managers.localization:text(job_data.name_id) or "No Heist selected"
	local job_id = job_data and job_data.name_id or "no_briefheist"
	local playing = self._current_presence == "Playing" or false
	local job_difficulty = _G.tweak_data.difficulties[managers.job:current_difficulty_stars() + 2] or 1
	local job_difficulty_text = managers.localization:to_upper_text(_G.tweak_data.difficulty_name_ids[job_difficulty])

	if job_name == "No Heist selected" then
		job_difficulty_text = "-"
	end

	local day_string = ""

	if #(managers.job:current_job_chain_data() or {}) > 1 then
		day_string = managers.localization:text("discord_rp_day_string", {day = tostring(managers.job:current_stage())})
	end

	if managers.crime_spree and managers.crime_spree:is_active() then
		local level_id = Global.game_settings.level_id
		local name_id = level_id and _G.tweak_data.levels[level_id] and _G.tweak_data.levels[level_id].name_id

		if name_id then
			job_name = managers.localization:text(name_id) or job_name
		end
	end

	local large_image = job_id

	print("[Discord] set_rich_presence", name, Application:time())
	print("[Discord] RP data 1/2", self._current_presence, in_lobby, job_name, job_id, day_string)
	print("[Discord] RP data 2/2", large_image, character, character_name, small_image)

	if name == "MPLobby" then
		Discord:set_status(managers.localization:text("discord_rp_lobby"), managers.localization:text("discord_rp_lobby_details", {
			heist = job_name,
			difficulty = job_difficulty_text,
			day = day_string
		}))
		Discord:set_party_size(managers.network:session():amount_of_players(), 4)
		Discord:set_start_time(0)
		Discord:set_large_image(large_image, job_name)
		Discord:set_small_image(small_image, character_name)
	elseif name == "SafeHousePlaying" then
		Discord:set_status(managers.localization:text("discord_rp_safehouse"), managers.localization:text("discord_rp_safehouse_details", {heist = job_name}))

		if playing then
			Discord:set_start_time_relative(0)
		end
	elseif name == "SPPlaying" then
		Discord:set_status(managers.localization:text("discord_rp_single_heist"), managers.localization:text("discord_rp_single_heist_details", {
			heist = job_name,
			difficulty = job_difficulty_text,
			day = day_string
		}))

		if playing then
			Discord:set_start_time_relative(0)
		end

		Discord:set_large_image(large_image, job_name)
		Discord:set_small_image(small_image, character_name)
	elseif name == "MPPlaying" then
		Discord:set_status(managers.localization:text("discord_rp_mp_heist"), managers.localization:text("discord_rp_mp_heist_details", {
			heist = job_name,
			difficulty = job_difficulty_text,
			day = day_string
		}))
		Discord:set_party_size(managers.network:session():amount_of_players(), 4)

		if playing then
			Discord:set_start_time_relative(0)
		end

		Discord:set_large_image(large_image, job_name)
		Discord:set_small_image(small_image, character_name)
	elseif name == "SPEnd" then
		Discord:set_status(managers.localization:text("discord_rp_single_end"), managers.localization:text("discord_rp_single_end_details", {
			heist = job_name,
			day = day_string
		}))
		Discord:set_start_time(0)
		Discord:set_large_image(large_image, job_name)
		Discord:set_small_image(small_image, character_name)
	elseif name == "MPEnd" then
		Discord:set_status(managers.localization:text("discord_rp_mp_end"), managers.localization:text("discord_rp_mp_end_details", {
			heist = job_name,
			day = day_string
		}))
		Discord:set_start_time(0)
		Discord:set_large_image(large_image, job_name)
        Discord:set_small_image(small_image, character_name)
    elseif name == "Idle" then
        Discord:set_status("ドリップコーヒー", "香風智乃のおパンツ")
	end
end