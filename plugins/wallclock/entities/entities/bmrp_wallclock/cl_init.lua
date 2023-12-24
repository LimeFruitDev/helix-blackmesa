--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

surface.CreateFont( "ClockFont", {
	font = "Roboto Black",
	size = 65,
	weight = 1000,
	antialias = true
} )

surface.CreateFont( "Main", {
	font = "Roboto",
	size = 40,
	weight = 1000,
	antialias = true
} )

ENT.DisplayVector = Vector( 0, 1.5, 13 )
ENT.DisplayScale = .5
ENT.DisplayAngle = Angle( -90, 0, 90 )

local year = year or os.date("%Y")

function ENT:DrawTranslucent()
	if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) > 1500000 then
		return
	end

	local ang = self:GetAngles()
	local pos = self:GetPos() + self:GetUp() * self.DisplayVector.z + self:GetRight() * self.DisplayVector.x + self:GetForward() * self.DisplayVector.y
	ang:RotateAroundAxis( self:GetRight(), self.DisplayAngle.pitch ) -- pitch
	ang:RotateAroundAxis( self:GetUp(),  self.DisplayAngle.yaw )-- yaw
	ang:RotateAroundAxis( self:GetForward(), self.DisplayAngle.roll )-- roll

	local splitter
	local timestamp = CurTime()

	cam.Start3D2D(pos, ang, .2)
	local date = (os.date("%d") .. " " .. os.date("%b") .. " " .. ix.config.Get("year"))

	if (CurTime() > timestamp) then
		if (first) then
			splitter = ":"
			first = false
			timestamp = CurTime() + 1
		else
			splitter = " "
			first = true
			timestamp = CurTime() + 1
		end
	end

	local time = ix.date.GetFormatted("%H:%M:%S")

	markupObject = markup.Parse(
		"<font=ClockFont><colour=0,0,0,255>" .. time .. "\n</colour></font>"
	)

	markupObjectnew = markup.Parse(
		"<font=Main><colour=0,0,0,255> ".. date .. "\n</colour></font>"
	)

	draw.RoundedBox( 8, -140, 0, 280, 125, Color(255, 255, 255,alpha))

	render.PushFilterMin(TEXFILTER.ANISOTROPIC)
	render.PushFilterMag(TEXFILTER.ANISOTROPIC)
			markupObject:Draw(0, 5, 1, nil, alpha)
			markupObjectnew:Draw(0, 85, 1, nil, alpha)
	render.PopFilterMag()
	render.PopFilterMin()
	cam.End3D2D()
end
