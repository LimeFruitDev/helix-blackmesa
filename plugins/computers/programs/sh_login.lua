--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local PROGRAM = {}
PROGRAM.order = 0
PROGRAM.name = "Login"
PROGRAM.icon = "icon16/key.png"
PROGRAM.hide = true
PROGRAM.size = {x = 400, y = 200}

if CLIENT then
	function PROGRAM.build()
		background:SetImage("limefruit/bmrp/computers/login2.png")

		local program = monitor:Add("DFrame")
		program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
		program:SetIcon(PROGRAM.icon)
		program:SetTitle(PROGRAM.name)
		program:ShowCloseButton(false)
		program:RequestFocus()
		program:Center()
		program.Think = function()
			PLUGIN.detectFocus(program)
		end

		local usernameLabel = program:Add("DLabel")
		usernameLabel:SetPos(20, 60)
		usernameLabel:SetText("Username")
		usernameLabel:SetFont("LimeFruit.Computers.Small")
		usernameLabel:SizeToContents()

		local usernameInput = program:Add("DTextEntry")
		usernameInput:SetSize(PROGRAM.size.x * 0.5, 25)
		usernameInput:SetPos(PROGRAM.size.x * 0.5 - (usernameInput:GetWide() * 0.5), 55)
		usernameInput:SetFont("LimeFruit.Computers.Small")
		usernameInput:SetValue(LocalPlayer():GetUsername())
		usernameInput:SetEditable(false)

		local passwordLabel = program:Add("DLabel")
		passwordLabel:SetPos(20, 100)
		passwordLabel:SetFont("LimeFruit.Computers.Small")
		passwordLabel:SetText("Password")
		passwordLabel:SizeToContents()

		local passwordInput = program:Add("DTextEntry")
		passwordInput:SetSize(PROGRAM.size.x * 0.5, 25)
		passwordInput:SetPos(PROGRAM.size.x * 0.5 - (passwordInput:GetWide() * 0.5), 95)
		passwordInput:SetFont("LimeFruit.Computers.Small")
		passwordInput:SetValue("********")
		passwordInput:SetEditable(false)

		local loginButton = program:Add("DButton")
		loginButton:SetSize(PROGRAM.size.x * 0.5, 30)
		loginButton:SetPos(PROGRAM.size.x * 0.5 - (loginButton:GetWide() * 0.5), 135)
		loginButton:SetTall(30)
		loginButton:SetFont("LimeFruit.Computers.Small")
		loginButton:SetText("Login")
		loginButton.DoClick = function(this)
			netstream.Start("computerAuthorize", LocalPlayer())
			program:Remove()
			PLUGIN:buildDesktop()
			PLUGIN:runProgram("popup", "Login", "Welcome, " .. LocalPlayer():GetName() .. ".\n\n" .. (Schema.christmas and "Happy holidays!" or "Have a very safe, and productive day!"))
		end
	end

	PLUGIN:registerProgram(PROGRAM)
end
