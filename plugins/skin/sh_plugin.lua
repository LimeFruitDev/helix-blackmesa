--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

PLUGIN.name = "Skin"
PLUGIN.description = "Overwrites the Helix skin."
PLUGIN.author = "Zoephix"

PLUGIN.BackgroundColor = Color(30, 30, 30, 250)
PLUGIN.BorderRadius = 25

function PLUGIN:LoadFonts(font, genericFont)
	surface.CreateFont("LimeFruit.Fonts.SmallFont", {
		font = "Roboto",
		size = 18,
		weight = 400
	})
	surface.CreateFont("LimeFruit.Fonts.SmallTitleFont", {
		font = "Roboto Bold",
		size = 32,
		weight = 1000
	})
	surface.CreateFont("LimeFruit.Fonts.MenuButton", {
		font = "Exo Regular",
		size = 38,
		weight = 400
	})
	surface.CreateFont("LimeFruit.Fonts.TabButton", {
		font = "Roboto Condensed",
		size = 38,
		weight = 700
	})
end


ix.option.Add("enableChatSound", ix.type.bool, true, {
	category = "Chat",
	OnChanged = function(oldValue, value)
		chat.enableSound = value
	end
})

ix.lang.AddTable("english", {
	optEnableChatSound = "Enable chat sound",
	optdEnableChatSound = "Plays a sound when a new message is sent."
})

ix.util.Include("cl_chat.lua")

if CLIENT then
	function PLUGIN:PopulateCharacterInfo(client, character, container)
		-- TODO: more efficient way?
		GAMEMODE.PopulateCharacterInfo = nil

		-- description
		local descriptionText = character:GetDescription()
		descriptionText = (descriptionText:utf8len() > 1028 and
			string.format("%s...", descriptionText:utf8sub(1, 1028)) or
			descriptionText)
	
		if (descriptionText != "") then
			local description = container:AddRow("description")
			description:SetText(descriptionText)
			description:SizeToContents()
		end
	end
end
