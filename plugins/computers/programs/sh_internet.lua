--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local PROGRAM = {}
PROGRAM.order = 1
PROGRAM.name = "Internet"
PROGRAM.icon = "icon16/world.png"
PROGRAM.size = {x = 800, y = 600}

if CLIENT then
	function PROGRAM.build()
		local program = desktop:Add("DFrame")
		program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
		program:Center()
		program:RequestFocus()
		program:SetTitle("")
		program.Think = function(this)
			PLUGIN.detectFocus(this)
		end

		local internet = program:Add("DHTML")
		internet:Dock(FILL)
		internet:SetPos(0, 20)
		internet:SetHTML [[
			<style>
				body {
					background-color: white;
				}
			</style>

			<span>Internet browsing has been disabled to increase productivity.</span>
		]]

		local options = program:Add("DHTMLControls")
		options:Dock(TOP)
		options:SetHTML(internet)

		local removeInput = program:Add("DPanel")
		removeInput:SetPos(0, 25)
		removeInput:SetSize(PROGRAM.size.x, 40)
	end

	PLUGIN:registerProgram(PROGRAM)
end
