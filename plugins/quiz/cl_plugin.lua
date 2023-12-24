--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

ix.quiz = {}

function PLUGIN:CharacterLoaded()
end

function PLUGIN:OnCharacterCreated()
end

function ix.quiz.start()
end

function ix.quiz.finish()
end

netstream.Hook("ixQuizFinished", function()
end)
