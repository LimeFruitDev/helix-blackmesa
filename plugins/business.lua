--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

PLUGIN.name = "Restrict Business Menu"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Removes access from the business menu."

ix.flag.Add("B", "Access to the business menu.")

if CLIENT then
	function PLUGIN:BuildBusinessMenu()
		if not LocalPlayer():GetCharacter():HasFlags("B") then
			return false
		end
	end
else
	function PLUGIN:CanPlayerUseBusiness(ply)
		if not ply:GetCharacter():HasFlags("B") then
			return false
		end
	end
end
