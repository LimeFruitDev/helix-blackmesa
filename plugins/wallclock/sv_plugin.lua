--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

function PLUGIN:SaveData()
	local data = {}

	for k, v in pairs(ents.FindByClass("bmrp_wallclock")) do
		data[#data + 1] = {
			pos = v:GetPos(),
			angles = v:GetAngles(),
			model = v:GetModel(),
		}
	end

	self:SetData(data)
end

function PLUGIN:LoadData()
	for k, v in pairs(ents.FindByClass("bmrp_wallclock")) do
		v:Remove()
	end

	for k, v in pairs(self:GetData() or {}) do
		local entity = ents.Create("bmrp_wallclock")
		entity:SetPos(v.pos)
		entity:SetAngles(v.angles)
		entity:Spawn()
		entity:SetModel(v.model)
		entity:Activate()

		local phys = entity:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end
end
