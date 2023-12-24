--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

-- Create clientside particle systems
netstream.Hook("eventSpawnParticleSystem", function(name, pos)
	local client = LocalPlayer()
	if (!client.particles) then client.particles = {} end

	local ghostModel = ents.CreateClientProp()
	ghostModel:SetPos(pos)
	ghostModel:SetModel("models/props_junk/popcan01a.mdl")
	ghostModel:SetNoDraw(true)
	ghostModel:Spawn()

	PrecacheParticleSystem(name)
	ghostModel.particles = CreateParticleSystem(ghostModel, name, PATTACH_WORLDORIGIN, 0, Vector(0, 0, 0))
	client.particles[name] = ghostModel
end)

-- Remove clientside particle systems
netstream.Hook("eventRemoveParticleSystem", function(name)
	local client = LocalPlayer()
	if (!client.particles) then return end

	for particleSystemName, ghostModel in pairs(client.particles) do
		if (particleSystemName == name) then
			ghostModel.particles:StopEmission(false, true, false)
			client.particles[particleSystemName] = nil
			break
		end
	end
end)

-- Modify screen colors
netstream.Hook("eventColorModify", function(tab)
	LocalPlayer().colorModify = {
		[ "$pp_colour_addr" ] = 0,
		[ "$pp_colour_addg" ] = 0.15,
		[ "$pp_colour_addb" ] = 0,
		[ "$pp_colour_brightness" ] = 0,
		[ "$pp_colour_contrast" ] = 1.5,
		[ "$pp_colour_colour" ] = 1,
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0.1
	}
end)

netstream.Hook("eventColorModifyRemove", function()
	LocalPlayer().colorModify = nil
end)

hook.Add("RenderScreenspaceEffects", "color_modify_example", function()
	if (!LocalPlayer().colorModify) then return end
	DrawColorModify(LocalPlayer().colorModify)
	DrawSunbeams( 0.3, 0.12, 1, 1.2, 1.2 )
	DrawToyTown(2, ScrH() / 2)
	DrawBloom( 0.65, 2, 9, 9, 1, 1, 1, 1, 1 )
end)

-- Communication servers
local pos, material = Vector(-78, 1119, 6791), Material("sprites/glow04_noz")

function PLUGIN:RenderScreenspaceEffects()
	local color = Color(0,255,0,255)

	if GetGlobalBool("comFailed") then
		color = Color(255,0,0,255)
	end

	cam.Start3D(EyePos(),EyeAngles())
		render.SetMaterial(material)
		render.DrawSprite(pos, 16, 16, color)
	cam.End3D()
end
