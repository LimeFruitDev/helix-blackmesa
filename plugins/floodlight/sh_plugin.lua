--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

PLUGIN.name = "Flood Light"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Adds a flood light to illuminate an area."

if (SERVER) then
	util.AddNetworkString("takeFloodlight")
	net.Receive("takeFloodlight", function(len, client)
		local entity = net.ReadEntity()

		if (!IsValid(entity) or entity:GetClass() != "bmrp_floodlight" or entity:GetPos():DistToSqr(client:GetPos()) > 5000) then
			return
		end

		client:GetCharacter():GetInventory():Add("floodlight")
		entity:Remove()
	end)

	netstream.Hook("toggleFloodlight", function(client, entity)
		if (!IsValid(entity) or entity:GetClass() != "bmrp_floodlight" or entity:GetPos():DistToSqr(client:GetPos()) > 5000) then
			return
		end

		entity:SetNWBool("active", !entity:GetNWBool("active", true))
	end)
end
