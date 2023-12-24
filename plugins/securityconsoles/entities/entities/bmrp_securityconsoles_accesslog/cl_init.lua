--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

include("shared.lua")

surface.CreateFont( "securityLogs", {
	font = "DebugFixed",
	size = 23,
	weight = 900,
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

local mainBG = vgui.Create("DPanel")
mainBG:SetSize(950, 625)

local mainBGX, mainBGY = mainBG:GetSize()
mainBG:SetPos( -( mainBGX/2 ), 300 )
mainBG:SetPaintedManually( true )
mainBG.Paint = function( self, w, h )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 0, 0, w, h )

	surface.SetDrawColor( Color( 0, 0, 0, 150 ) )

	for i=0, 5 - 1 do
		surface.DrawOutlinedRect( -5 + i, -5 + i, w+10 - i * 2, h+10 - i * 2 )
	end
end

local securityLogs = vgui.Create("DPanel", mainBG)

securityLogs:SetSize(mainBGX, mainBGY)
securityLogs:SetPos(1, -10)

securityLogs.Paint = function(self, w, h)
	for amount, log in pairs(ix.security.log) do
		surface.SetFont("securityLogs")

		if (not log.door) then
			log.door = "Unknown"
		end

		local middle = (35/2) - (5/2)
		local colors = ix.security.logcolors

		local accessText = log.access and "Access Granted" or "Access Denied"
		local text = "[" ..log.time.. "] " .. accessText .. " (" .. log.door .. "), " .. log.name

		if ( tonumber( log.clearance ) ) then
			local clearance = tonumber( log.clearance )

			draw.SimpleText( text, "securityLogs", 15, ( 20*amount ) + middle - 10, log.name == "Error" and colors.error or log.access and colors.granted or clearance <= 2 and colors.lowDenied or clearance >= 3 and colors.highDenied )
		else
			draw.SimpleText( text, "securityLogs", 15, ( 20*amount ) + middle - 10, log.name == "Error" and colors.error or log.clearance == "S" and log.access and colors.security or log.access and colors.granted or colors.highDenied )
		end
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

	cam.Start3D2D( pos, ang, self.DisplayScale )
		if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) < 500000 then
			mainBG:PaintManual()
		end
	cam.End3D2D()
end
