return {
	run = function()
		fassert(rawget(_G, "new_mod"), "Clock must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Clock", {
			mod_script       = "scripts/mods/Clock/Clock",
			mod_data         = "scripts/mods/Clock/Clock_data",
			mod_localization = "scripts/mods/Clock/Clock_localization"
		})
	end,
	packages = {
		"resource_packages/Clock/Clock"
	}
}
