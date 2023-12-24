--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

PLUGIN.name = "Welcome"
PLUGIN.description = "Warm welcome from the administration."
PLUGIN.author = "Zoephix"

local factions = {FACTION_MEDIC, FACTION_MAINTENANCE, FACTION_SCIENTIST, FACTION_SECURITY, FACTION_ADMINISTRATION}

if SERVER then
	function PLUGIN:OnCharacterCreated(ply, char)
		if not table.HasValue(factions, char:GetFaction()) then return end

		ix.chat.PrintChat(player.GetAll(), Color(218, 19, 192), "Speakers: <:: The Black Mesa administration would personally welcome '" .. char:GetName() .. "' it's their first day at the facility. ::>")
	end
end
