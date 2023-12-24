--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

include("shared.lua")

surface.CreateFont( "Name", {
	font = "DebugFixed",
	size = 21,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

function draw.OutlinedBox( x, y, w, h, thickness, clr )
	surface.SetDrawColor( clr )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

local mainBG = vgui.Create("DPanel")
mainBG:SetSize(950, 625)

local mainBGX, mainBGY = mainBG:GetSize()
mainBG:SetPos(mainBGX / -2, 300)
mainBG:SetPaintedManually(true)
mainBG.Paint = function(self, w, h)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(0, 0, w, h)
	draw.OutlinedBox( 0 -5, 0 -5, w+10, h+10, 5, Color( 0, 0, 0, 150 ) )
end

surface.CreateFont("Settings", {
	size = 35,
	weight = 1000,
	antialias = false,
	shadow = false,
	font = "Trebuchet MS"
})

local titleStaff = vgui.Create("DPanel", mainBG)
titleStaff:SetSize(mainBGX, 75)
titleStaff.Paint = function(self, w, h)
	surface.SetFont("Settings")

	draw.SimpleText("Staff On Duty", "Settings", 10, 10)
end

local theList = vgui.Create("DPanel", mainBG)
theList:SetSize(mainBGX, mainBGY-75)
theList:SetPos(1, 75)
theList.Paint = function(self, w, h)
	local amount = 0

	for _, char in ix.util.GetCharacters() do
		-- if !(ply:isDefaultFaction()) then continue end
		-- if !ply:OnDuty() then continue end
		local name = char:GetName()

		if (char:GetClass()) then
			class = ix.class.list[char:GetClass()].name
			StaffString = name .. ", " .. class
		elseif (char:GetFaction()) then
			faction = ix.faction.indices[char:GetFaction()].name
			StaffString = name .. ", " .. faction
		else
			StaffString = name .. ", ERROR"
		end

		if (string.len(StaffString) > 35 and string.len(StaffString) ~= 35) then
			StaffString = string.sub(StaffString, 1, 35) .. "..."
		end

		local col = ix.faction.indices[char:GetFaction()].color

		if amount >= 54 then break end

		surface.SetFont("Name")
		local tX, tY = surface.GetTextSize(StaffString)

		if amount >= 54 then -- right side
			--multi = amount - 54
			--draw.SimpleText(StaffString, "Name", mainBGX/1.5, ((35/2) - (tY/2)) + (multi * 20), col)
		elseif amount <= 26 then -- left side
			draw.SimpleText(StaffString, "Name", 5, ((35/2) - (tY/2)) + (amount*20), col)
		else -- middle
			multi = amount - 27
			draw.SimpleText(StaffString, "Name", mainBGX/2, ((35/2) - (tY/2)) + (multi * 20), col)
		end

		amount = amount + 1
	end
end

ENT.DisplayAngle = Angle( -90, 0, 90 )
ENT.DisplayScale = 0.1
ENT.DisplayVector = Vector( 0, -21, 150 )

function ENT:Draw()
	self:DrawModel()

	local ang = self:GetAngles()
	local pos = self:GetPos() + self:GetUp() * self.DisplayVector.z + self:GetRight() * self.DisplayVector.x + self:GetForward() * self.DisplayVector.y
	ang:RotateAroundAxis( self:GetRight(), self.DisplayAngle.pitch ) -- pitch
	ang:RotateAroundAxis( self:GetUp(),  self.DisplayAngle.yaw )-- yaw
	ang:RotateAroundAxis( self:GetForward(), self.DisplayAngle.roll )-- roll

	cam.Start3D2D(pos, ang, self.DisplayScale)
		if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) < 500000 then
			mainBG:PaintManual()
		end
	cam.End3D2D()
end
