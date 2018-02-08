Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_CustomDiscordStatus", function(lang)
	for _, filename in pairs(file.GetFiles(CustomDiscordStatus._path .. "lang/")) do
		local str = filename:match('^(.*).json$')
		local langid = CustomDiscordStatus:GetOption("language")
		if str == CustomDiscordStatus._language[langid] then
			lang:load_localization_file(CustomDiscordStatus._path .. "lang/" .. filename)
			log("[CustomDiscordStatus Info] Selected language: " .. str)
			break
		end
	end
	
	lang:load_localization_file(CustomDiscordStatus._path .. "lang/english.json", false)
	
end)

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_CustomDiscordStatus", function(menu_manager)
end)