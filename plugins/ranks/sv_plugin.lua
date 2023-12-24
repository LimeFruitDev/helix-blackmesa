--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN
PLUGIN.ranks = PLUGIN.ranks or {}

function PLUGIN:InitPostEntity()
	for _, class in SortedPairsByMemberValue(ix.class.list) do
		if (!self.ranks[class.faction]) then
			self.ranks[class.faction] = {}
		end

		self.ranks[class.faction][class.rankOrder] = class.index
	end
end

function PLUGIN:PlayerLoadedCharacter(client, character, currentChar)
	local className = character:GetData("class", nil)

	if (className) then
		for _, class in pairs(ix.class.list) do
			if (class.faction != character:GetFaction()) then continue end

			if (class.name == className) then
				timer.Simple(1, function()
					character:SetClass(class.index)
				end)

				break
			end
		end
	end
end

function PLUGIN:OnCharacterCreated(client, character)
	local faction = character:GetFaction()

	if (!self.ranks[faction]) then return end

	timer.Simple(1, function()
		character:SetClass(self.ranks[faction][1])
	end)
end
