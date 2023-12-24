--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local PROGRAM = {}
PROGRAM.order = 5
PROGRAM.name = "Tetris"
PROGRAM.icon = "icon16/bricks.png"
PROGRAM.size = {x = 500, y = 600}

if CLIENT then
	function PROGRAM.build()
        local program = desktop:Add("DFrame")
        program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
        program:SetTitle(PROGRAM.name)
        program:SetIcon(PROGRAM.icon)
        program:RequestFocus()
		program:Center()

        local game = program:Add("DHTML")
        game:Dock(FILL)
        game:OpenURL("https://codeincomplete.com/games/tetris/")
    end

	PLUGIN:registerProgram(PROGRAM)
end
