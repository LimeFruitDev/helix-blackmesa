--[[
	This script is part of the Black Mesa Evolved schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

PLUGIN.name = "Character Creation"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Overrides Helix's character creation."

function PLUGIN:LoadFonts()
	surface.CreateFont("ixCustomizeButton", {
		font = "Roboto",
		size = 25,
		weight = 1000,
		antialias = true
	})
end

-- Include additional files
ix.util.Include("derma/cl_charcreate.lua")

-- Nice names
PLUGIN.bodygroupReplacements = PLUGIN.bodygroupReplacements or {
	["body"] = "Body",
	["vest"] = "Vest",
	["helmet"] = "Helmet",
	["glasses"] = "Glasses",
	["hair"] = "Hair",
	["head"] = "Head",
	["beanies"] = "Beanies",
	["torso"] = "Torso",
	["legs"] = "Pants",
	["hands"] = "Hands",
	["model #1"] = "Default",
	["flashlight"] = "Flashlight"
}

-- Blacklisted
PLUGIN.bodygroupBlacklist = PLUGIN.bodygroupBlacklist or {
	"helmet",
	"chest",
	"holster",
	"syringe"
}

-- Allow blacklist for models
PLUGIN.bodygroupBlacklistIgnore = PLUGIN.bodygroupBlacklistIgnore or {
	["models/humansbmce/cwork.mdl"] = {"helmet"},
	["models/humansbmce/engineer.mdl"] = {"helmet"}
}

-- Standard model bodygroups
PLUGIN.standardModelBodygroups = {
	["models/humansbmce/guard.mdl"] = {["helmet"] = 1},
	["models/humansbmce/guard_02.mdl"] = {["helmet"] = 1},
	["models/humansbmce/guard_03.mdl"] = {["helmet"] = 1},
	["models/heartbit_guard_kake_fat.mdl"] = {["helmet"] = 1},
	["models/heartbit_female_guards3.mdl"] = {["helmet"] = 0},
	["models/humansbmce/guard_female.mdl"] = {["helmet"] = 1}
}

-- Allowed data setting
PLUGIN.allowedData = PLUGIN.allowedData or {
	["skin"] = true,
	["groups"] = true
}

-- Function to beautify the bodygroup names
function PLUGIN:N(str)
	if self.bodygroupReplacements[str] then
		return self.bodygroupReplacements[str]
	end

	return str
end

if SERVER then
	function PLUGIN:OnCharacterCreated(client, character)
		character:Setup()
		client:Spawn()
		client:SetNetVar("canSetCreationData", true) -- authorize data changing
		netstream.Start(client, "getCreationData") -- table got to be pulled from the client
	end

	netstream.Hook("setCreationData", function(client, creationData)
		if (creationData and client:GetNetVar("canSetCreationData", false)) then
			client:SetNetVar("canSetCreationData", false)

			for name, data in pairs(creationData) do
				if (PLUGIN.allowedData[name]) then
					client:GetCharacter():SetData(name, data)

					if (name == "skin") then
						client:SetSkin(data)
					elseif (name == "groups") then
						for k, v in pairs(creationData["groups"]) do
							client:SetBodygroup(k, v)
						end
					elseif (name == "head") then
						client:SetHead(data)
					end
				end
			end
		end
	end)
else
	-- client
	netstream.Hook("getCreationData", function()
		if (IsValid(ix.gui.characterMenuNew) and ix.gui.characterMenuNew.creationData) then
			netstream.Start("setCreationData", ix.gui.characterMenuNew.creationData) -- return custom data
			ix.gui.characterMenuNew.creationData = {}
		end
	end)
end
