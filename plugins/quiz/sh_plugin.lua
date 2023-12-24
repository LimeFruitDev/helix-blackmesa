--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

PLUGIN.name = "Quiz"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Adds a quiz which players must pass to continue."

-- The maximum number of incorrect answers allowed
PLUGIN.maxIncorrectAnswers = 1

ix.util.Include( "cl_plugin.lua" )
ix.util.Include( "sv_plugin.lua" )

PLUGIN.Quiz = {}
