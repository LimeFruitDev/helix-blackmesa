--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

PLUGIN.name = "Events"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Automated map and coded events."

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_commands.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/events", true)
