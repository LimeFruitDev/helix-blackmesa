--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

-- Set prop owner
function PLUGIN:PlayerSpawnedProp( ply, model, ent )
	ent:SetCreator(ply)
	ent:SetNWBool("Owner", ply)
end

-- Prevents players from picking up blocked entities
function PLUGIN:PhysgunPickup( ply, ent )
    if (PLUGIN.blacklist[ent:GetClass()] or !ply:IsStaff() and ent:GetCreator() != ply) then
		return false
	end
end
