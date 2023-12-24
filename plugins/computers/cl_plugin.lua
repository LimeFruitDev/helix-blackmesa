--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

// = = = = = = = = = = = = = = = = = = = = = = = =
// 
//	Functions
//
// = = = = = = = = = = = = = = = = = = = = = = = =

function PLUGIN:buildLogin(computer, shouldBuildLogin)
	if !computer:IsActive() or !computer:IsAuthorized() or shouldBuildLogin then
		self:runProgram("login")
	else
		self:buildDesktop()
	end
end

function PLUGIN:buildComputer(computer)
	local w, h = (ScrW() >= 1100 and 1100 or ScrW()), (ScrH() >= 848 and 848 or ScrH())
	self.size = {x = w, y = h}

	local frame = vgui.Create("DImage")
	frame:SetSize(w, h) -- 1100 848
	frame:Center()
	frame:SetImage("limefruit/bmrp/computers/screenbg.png")
	self.frame = frame

	local window = frame:Add("CFrame")
	window:SetSize(w - 75, h - 50) -- 1034 798
	window:SetPos(ScrW()/2 - (window:GetWide()/2), ScrH()/2 - (window:GetTall()/2) - 7.5)
	window:SetSkin("ComputerSkin")
	window:MakePopup()
	window.OnClose = function()
		frame:Remove()
		netstream.Start("computerLeave", computer)
	end

	monitor = window:Add("DPanel")
	monitor.size = {x = window:GetWide(), y = window:GetTall() - 10}
	monitor:SetSize(monitor.size.x, monitor.size.y)
	monitor.Paint = function(this, w, h)
		surface.SetDrawColor(((self.login and self.login:IsVisible() or desktop and desktop:IsVisible()) and Color(0, 128, 128, 255)) or Color(0, 0, 0, 255))
		surface.DrawRect(0, 25, w, h - 25)
	end

	background = monitor:Add("DImage")
	background.size = {x = window:GetWide(), y = window:GetTall() - 35}
	background:SetSize(background.size.x, background.size.y)
	background:SetPos(0, 25)

	local btnClose = monitor:Add("DButton")
	btnClose:SetText( "X" )
	btnClose:SetPos( monitor:GetWide() - 25, 0 )
	btnClose:SetSize( 20, 15 )
	btnClose.DoClick = function(button) window:Close() end

	-- create login
	self:buildLogin(computer)

	-- startup when not activate
	if not computer:IsActive() then
		self.login:SetVisible(false)
		self:startupComputer()
	end
end

if IsValid(PLUGIN.frame) then
	PLUGIN.frame:Remove()
end

function PLUGIN:buildDesktop()
	background:SetImage("limefruit/bmrp/computers/desktop.png")

	-- christmas
	if self.config.Christmas then
		-- update desktop background
		background:SetImage("limefruit/bmrp/computers/christmas-desktop.jpg")
	end

	desktop = monitor:Add("DPanel")
	desktop:SetSize(background.size.x, background.size.y)
	desktop:SetPos(0, 25)
	desktop.Paint = function(this, w, h) end

	-- version
	local version = desktop:Add("DLabel")
	version:SetPos(desktop:GetWide() - 80, 30)
	version:SetText("MesaOS Beta")
	version:SetTextColor(Color(255, 255, 255, 200))
	version:SizeToContents()
	version:SetContentAlignment(6)

	-- current user
	local user = desktop:Add("DLabel")
	user:SetText("Welcome back, " .. LocalPlayer():GetName())
	user:SetTextColor(Color(255, 255, 255, 200))
	user:SizeToContents()
	user:SetPos(desktop:GetWide() - user:GetWide() - 13, 15)
	user:SetContentAlignment(6)

	-- time
	local time = desktop:Add("DLabel")
	time:SetPos(desktop:GetWide() - 75, desktop:GetTall() - 40)
	time:SetFont("CloseCaption_Bold")
	time:SetText("12:00")
	time:SetTextColor(Color(255, 255, 255, 200))
	time.nextThink = CurTime() + 1
	time.Think = function()
		if CurTime() > time.nextThink then
			time:SetText(ix.date.GetFormatted("%H:%M"))
			time.nextThink = CurTime() + 1
		end
	end

	--============================
	-- program shortcuts
	--============================
	local shortcuts = {}
	local curRow = 0
	local curProgram = 0
	for _, program in SortedPairsByMemberValue(self.programs, "order") do
		if program.size then
			program.size.x = ScrW() <= program.size.x and background.size.x or program.size.x
			program.size.y = ScrH() <= program.size.y and background.size.y or program.size.y
		end

		if program.hide then continue end
		if program.permission ~= nil and !program.permission() then continue end

		-- 8 = margin
		-- 58 = icon size
		if (8 + (58 / desktop:GetTall() * 100) * (curProgram + 1) > 100) then
			curProgram = 0
			curRow = curRow + 1
		end

		local new = desktop:Add("DButton")
		new:SetPos(8 + (64 * curRow), 8 + (58 * curProgram)) -- 63 fixes modern resolutions
		new:SetSize(54, 58) -- 48 58
		new:SetText("")
		new.Paint = function(this, w, h)
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.SetMaterial(Material(program.icon))
			surface.DrawTexturedRect(w/2 - 16, h/2 - 28, 32, 32)

			-- draw program text
			surface.SetFont("LimeFruit.Computers.Small")
			surface.SetTextColor(Color(255, 255, 255, 255))

			local text = program.name
			textSize = surface.GetTextSize(text)

			-- draw program active state
			if this.active then
				surface.SetDrawColor(0, 0, 128)
				surface.DrawRect(w/2 - textSize/2, h - (h*0.35), textSize, h*0.3)
			end

			-- draw program text
			surface.SetTextPos(w/2 - textSize/2, h * 0.675)
			surface.DrawText(text)
		end
		new.DoClick = function()
			if new.active then
				new.active = false
				program.build()
			else
				for _, program in pairs(shortcuts) do
					program.active = false
				end
				new.active = true
			end
		end

		shortcuts[#shortcuts + 1] = new
		curProgram = curProgram + 1
	end
end

// = = = = = = = = = = = = = = = = = = = = = = = =
// 
//	Programs
//
// = = = = = = = = = = = = = = = = = = = = = = = =

function PLUGIN:runProgram(program, ...)
	local program = self.programs[program]

	if program then
		program.build(...)
	end
end

-- when a program is pressed while hovered make focused
PLUGIN.FocusProgram = nil
function PLUGIN.detectFocus(this)
	if (this:IsHovered()) then
		PLUGIN.FocusProgram = this
	end
end

function PLUGIN:CreateMove()
	-- mouse use sounds
	if input.WasMousePressed(MOUSE_LEFT) or input.WasMousePressed(MOUSE_RIGHT) then
		netstream.Start("computerMouse")
	end

	-- focus a program
	if self.FocusProgram and IsValid(self.FocusProgram) and input.WasMousePressed(MOUSE_LEFT) then
		self.FocusProgram:RequestFocus()
	end
end

-- register programs
PLUGIN.programs = {}
function PLUGIN:registerProgram(program)
	PLUGIN.programs[string.lower(program.name)] = program
end

// = = = = = = = = = = = = = = = = = = = = = = = =
// 
//	Client hooks
//
// = = = = = = = = = = = = = = = = = = = = = = = =

netstream.Hook("computerUse", function(computer)
	PLUGIN:buildComputer(computer)
end)
