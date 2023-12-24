--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN
PLUGIN.adverts = PLUGIN.adverts or {}

-- Advert saving
function PLUGIN:SaveData()
	local data = {}
	data.adverts = PLUGIN.adverts
	self:SetData(data)
end

function PLUGIN:LoadData()
	local data = self:GetData() or {}

	if data.adverts then
		PLUGIN.adverts = data.adverts
	end
end

-- Advert fetching
function PLUGIN:UpdateAdverts()
	netstream.Start(player.GetAll(), "advertsGet", self.adverts)
end

netstream.Hook("advertsGet", function(ply)
	netstream.Start(ply, "advertsGet", PLUGIN.adverts)
end)

-- Create advert
netstream.Hook("computerAdvertsCreate", function(ply, advertTitle, advertText, advertImage)
	if not ply:IsUsingComputer() then return end
	if not ply:HasClearances("A") then return end

	PLUGIN.adverts[#PLUGIN.adverts + 1] = {
		char = ply:GetCharacter():GetID(),
		author = ply:GetName(),
		title = advertTitle,
		text = advertText,
		image = advertImage,
		time = os.time()
	}

	PLUGIN:UpdateAdverts()
end)

-- Update advert
netstream.Hook("computerAdvertsUpdate", function(ply, advertID, advertTitle, advertText, advertImage)
	if not ply:IsUsingComputer() then return end
	if not ply:HasClearances("A") then return end

	local faction = ply:GetCharacter():GetFaction()
	if not ply:IsAdmin() and faction ~= FACTION_DIRECTOR and faction ~= FACTION_ADMINISTRATION and PLUGIN.adverts[advertID].char ~= ply:GetCharacter():GetID() then return end

	PLUGIN.adverts[advertID].title = advertTitle
	PLUGIN.adverts[advertID].text = advertText
	PLUGIN.adverts[advertID].image = advertImage

	PLUGIN:UpdateAdverts()
end)

-- Remove advert
netstream.Hook("computerAdvertsRemove", function(ply, advertID)
	if not ply:IsUsingComputer() then return end
	if not ply:HasClearances("A") then return end

	local faction = ply:GetCharacter():GetFaction()
	local isAuthor = PLUGIN.adverts[advertID].char == ply:GetCharacter():GetID()
	if not ply:IsAdmin() and faction ~= FACTION_DIRECTOR and faction ~= FACTION_ADMINISTRATION and not isAuthor then return end

	if not isAuthor then
		ply:ChatPrint("Your actions have been logged.")
		ix.log.AddRaw(ply:GetName() .. " has removed advert from " .. PLUGIN.adverts[advertID].author, FLAG_DANGER)
	end

	PLUGIN.adverts[advertID] = nil

	PLUGIN:UpdateAdverts()
end)
