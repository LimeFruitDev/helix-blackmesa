--[[
	This script is part of the Black Mesa Evolved schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2022: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local function SpawnButtonOverrides()
	for _, ent in ipairs(ents.FindByName("limefruit_btn_override")) do
		if (!ent:GetParent() || ent:GetParent():GetClass() != "func_button") then continue end

		ent:GetParent():SetKeyValue("spawnflags", "1")
		
		local override = ents.Create("limefruit_btn_override")
		override:SetPos(ent:GetPos())
		override:SetAngles(ent:GetAngles())
		override:SetModelScale(ent:GetModelScale())
		override:SetModel(ent:GetModel())
		override:SetParent(ent:GetParent())
		override:Spawn()

		ent:Remove()
	end
end
hook.Add( "InitPostEntity", "SpawnButtonOverrides", SpawnButtonOverrides )
