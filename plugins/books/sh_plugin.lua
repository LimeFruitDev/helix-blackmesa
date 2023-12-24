--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

PLUGIN.name = "Books"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Adds books to the schema which players can read."

if SERVER then
	function PLUGIN:PlayerViewBook(client)
		client:GetCharacter():UpdateAttrib("int", 0.001)
	end
else
	netstream.Hook("ixLimeFruitViewBook", function(itemTable)
		local panel = vgui.Create("ixLimeFruitViewBook")
		panel:Populate(itemTable)
	end)
end
