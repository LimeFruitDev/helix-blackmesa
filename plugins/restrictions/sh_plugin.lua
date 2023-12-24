--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

PLUGIN.name = "Restrictions"
PLUGIN.description = "Creates restrictions for each player."
PLUGIN.author = "Zoephix"

-- Include the plugin files
ix.util.Include("sh_config.lua")
ix.util.Include("sv_plugin.lua")

function PLUGIN:CanProperty( ply, property, ent )
	local entBlacklisted = self.blacklist[ent:GetClass()]
	-- Restrict properties for everyone on blacklisted entities.
	if (property == "remover" and entBlacklisted) then return false end
	if (property == "drive" and entBlacklisted) then return false end
	if (property == "collision_off" and entBlacklisted) then return false end
	if (property == "collision_on" and entBlacklisted) then return false end

	-- Allow staff to use every other property.
	if (ply:IsStaff()) then return true end

	-- Player property restrictions.
	if (property == "skin" and ent:GetNWBool("Owner", nil) == ply) then return true end
	if (property == "bodygroups" and ent:GetNWBool("Owner", nil) == ply) then return true end
end

function PLUGIN:CanTool( ply, tr, tool )
	if (!ply.toolInterval) then ply.toolInterval = 0 end
	if CurTime() < ply.toolInterval then return false end
	ply.toolInterval = CurTime() + self.toolInterval

	-- Block usage on blacklisted entities.
	if (self.blacklist[tr.Entity:GetClass()]) then
		if CLIENT then
			chat.AddText(Material("icon16/stop.png"), Color(209, 29, 5), "You cannot interact with this!")
		end

		return false
	end

	-- Allow owners to remove their own entities.
	if (!ply:IsStaff() and tool == "remover" and tr.Entity:GetNWBool("Owner", nil) == ply) then
		return true
	end

	-- Only authorize administrators for certain tools.
	if (!ply:IsStaff() and table.HasValue(self.AdminTools, tool)) then
		if CLIENT then
			chat.AddText(Material("icon16/stop.png"), Color(209, 29, 5), "You cannot use this tool!")
		end

		return false
	end
end
