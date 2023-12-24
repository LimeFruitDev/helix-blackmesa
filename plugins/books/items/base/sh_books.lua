--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

ITEM.name = "Book Base"
ITEM.description = "A Base Book."
ITEM.category = "Literature"
ITEM.model = Model("models/props_lab/bindergreenlabel.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.bAllowMultiCharacterInteraction = true

ITEM.functions.View = {
	OnRun = function(item)
		netstream.Start(item.player, "ixLimeFruitViewBook", {name=item.name, bookInformation=item.bookInformation})

		if SERVER then
			hook.Run("PlayerViewBook", item.player)
		end

		return false
	end,
}
