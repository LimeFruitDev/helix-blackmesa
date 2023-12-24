--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local PROGRAM = {}
PROGRAM.order = 0
PROGRAM.name = "Popup"
PROGRAM.icon = "icon16/information.png"
PROGRAM.hide = true
PROGRAM.size = {x = 400, y = 125}

if CLIENT then
	function PROGRAM.build(...)
        local args = {...}

		if Schema.christmas then
			surface.PlaySound("limefruit/ohohohoh.wav")
		else
			surface.PlaySound("plats/elevbell1.wav")
		end

		local program = desktop:Add("DFrame")
        program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
        program:SetTitle(args[1] or "Unknown")
        program:SetIcon(PROGRAM.icon)
        program:RequestFocus()
		program:Center()

		local infoLabel = program:Add("DLabel")
        infoLabel:SetSize(PROGRAM.size.x - 36, PROGRAM.size.y)
        infoLabel:SetPos(20, 0)
        infoLabel:SetText(args[2] or "Unknown")
        -- infoLabel:SetContentAlignment(5)
		-- infoLabel:SizeToContents()
        infoLabel:SetWrap(true)

        local okButton = vgui.Create("DButton", program)
		okButton:SetSize(70, 25)
		okButton:SetPos(program:GetWide()/2-okButton:GetWide()/2, 95)
		okButton:SetText("OK")
		okButton.DoClick = function()
			program:Remove()
		end
    end

	PLUGIN:registerProgram(PROGRAM)
end
