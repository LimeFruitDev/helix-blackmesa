--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local PROGRAM = {}
PROGRAM.order = 0
PROGRAM.name = "Logout"
PROGRAM.icon = "icon16/key.png"

if CLIENT then
	function PROGRAM.build()
		if IsValid(desktop) then
			netstream.Start("computerAuthorize", false)
			desktop:Remove()
			PLUGIN:runProgram("login")
		end
	end

	PLUGIN:registerProgram(PROGRAM)
end
