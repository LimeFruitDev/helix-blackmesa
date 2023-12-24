--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

-- Interval before players can use the toolgun again
PLUGIN.toolInterval = 0.5

-- Limits to spawning props
PLUGIN.MaxProps = {
	guest = 15,
	donator = 100
}

-- Tools restricted to donator only
PLUGIN.DonatorTools = PLUGIN.DonatorTools or {
	"streamradio",
	"streamradio_gui_color_global",
	"streamradio_gui_color_individual",
	"streamradio_gui_skin"
}

-- Tools restricted to admin only
PLUGIN.AdminTools = PLUGIN.AdminTools or {
	"remover",
	"permaprops",
	"dynamite",
	"energyball",
	"fire",
	"glow",
	"sparks",
	"steam",
	"tesla",
	"smoke",
	"smoke_trail"
}

-- Table with entities that are blacklisted from usage
PLUGIN.blacklist = PLUGIN.blacklist or {
	["func_button"] = true,
	["class C_BaseEntity"] = true,
	["func_brush"] = true,
	["func_tracktrain"] = true,
	["func_door"] = true,
	["func_door_rotating"] = true,
	["prop_door_rotating"] = true,
	["prop_static"] = true,
	["prop_dynamic"] = true,
	["prop_physics_override"] = true,
}
