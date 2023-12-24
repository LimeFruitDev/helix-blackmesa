PLUGIN.name = "Needs"
PLUGIN.author = "Gr4ss"
PLUGIN.description = "Adds hunger and thirst."

ix.util.Include("cl_hooks.lua")
ix.util.Include("cl_plugin.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("sv_hooks.lua")

ix.config.Add("killOnMaxNeeds", false, "Enable players being killed when reaching max hunger or thirst.", nil, {
	category = "Needs"
})

ix.config.Add("hungerHours", 6, "How many hours it takes for a player to gain 60 hunger.", nil, {
	data = {min = 1, max = 24},
	category = "Needs"
})

ix.config.Add("thirstHours", 4, "How many hours it takes for a player to gain 60 thirst.", nil, {
	data = {min = 1, max = 24},
	category = "Needs"
})

ix.config.Add("needsTickTime", 4, "How many seconds between each time a player's needs are calculated.", nil, {
	data = {min = 1, max = 128},
	category = "Needs"
})
