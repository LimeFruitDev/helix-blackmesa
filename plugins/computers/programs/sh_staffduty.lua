--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local PROGRAM = {}
PROGRAM.order = 6
PROGRAM.name = "Staff Duty"
PROGRAM.icon = "icon16/group.png"
PROGRAM.size = {x = 400, y = 500}
PROGRAM.permission = function() return (LocalPlayer():HasClearances("A") or LocalPlayer():HasClearances("S")) or false end

if CLIENT then
	local program

	function PROGRAM.build()
		program = desktop:Add("DFrame")
		program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
		program:Center()
		program:RequestFocus()
		program:SetIcon(PROGRAM.icon)
		program:SetTitle(PROGRAM.name)

		local staff = program:Add("DListView")
		staff:Dock(FILL)
		staff:AddColumn("Name")
        staff:AddColumn("Division")

		for k, v in pairs(player.GetAll()) do
			local character = v:GetCharacter()
			if character then
            	local class = v:GetCharacter():GetClass()
				if class then
            		staff:AddLine(v:GetName(), ix.class.list[class].name)
				end
			end
		end
    end

	PLUGIN:registerProgram(PROGRAM)
end
