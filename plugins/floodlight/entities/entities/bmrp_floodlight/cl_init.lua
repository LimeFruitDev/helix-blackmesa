--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	
	if (self:GetPos():DistToSqr( LocalPlayer():GetPos() ) < 500000 and self:GetNWBool("active", true)) then
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			local r, g, b, a = self:GetColor()
			dlight.Pos = self:GetPos() + Vector(19,0,70)
			dlight.r = 255
			dlight.g = 255
			dlight.b = 150
			dlight.Brightness = 0.6
			dlight.Size = 2800
			dlight.Decay = 5
			dlight.DieTime = CurTime() + 0.1
		end
	end
end
