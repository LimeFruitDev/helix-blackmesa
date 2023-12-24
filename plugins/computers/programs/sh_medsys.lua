--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local PROGRAM = {}
PROGRAM.order = 0
PROGRAM.name = "MedSYS"
PROGRAM.icon = "icon16/folder_heart.png"
PROGRAM.hide = true
PROGRAM.size = {x = 400, y = 250}
PROGRAM.permission = function()
	local access = false

	if LocalPlayer():GetCharacter():GetFaction() == "FACTION_MEDIC" and LocalPlayer():HasClearances("3") then
		access = true
	elseif LocalPlayer():HasClearances("A") then
		access = true
	end
	
	return access
end
PROGRAM.characters = PROGRAM.characters or {}

if CLIENT then
    function PROGRAM.build()
    end

    PLUGIN:registerProgram(PROGRAM)
end
