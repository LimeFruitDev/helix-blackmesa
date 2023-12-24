--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

ENT.PrintName = "Flood Light"
ENT.Type = "anim"
ENT.Author = "Zoephix"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "BMRP"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:GetEntityMenu(client)
	local itemTable = ix.item.list["floodlight"]
	local options = {}

	if (!itemTable) then
		return false
	end

	itemTable.player = client
	itemTable.entity = self

	options["take"] = function()
		net.Start("takeFloodlight")
			net.WriteEntity(self)
		net.SendToServer()
	end

	options["Toggle"] = function()
		if (CLIENT) then
			netstream.Start("toggleFloodlight", self)
		end
	end

	for k, v in SortedPairs(itemTable.functions) do
		if (k == "take" or string.lower(k) == "place") then
			continue
		end

		if (v.OnCanRun and v.OnCanRun(itemTable) == false) then
			continue
		end

		options[L(v.name or k)] = function()
			local send = true

			if (v.OnClick) then
				send = v.OnClick(itemTable)
			end

			if (v.sound) then
				surface.PlaySound(v.sound)
			end

			if (send != false) then
				net.Start("ixItemEntityAction")
					net.WriteString(k)
					net.WriteEntity(self)
				net.SendToServer()
			end

			-- don't run callbacks since we're handling it manually
			return false
		end
	end

	itemTable.player = nil
	itemTable.entity = nil

	return options
end

function ENT:OnOptionSelected()
end
