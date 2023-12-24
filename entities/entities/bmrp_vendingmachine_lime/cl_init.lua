include("shared.lua")

local glowMaterial = Material("sprites/glow04_noz")
local lightColor = Color(0, 212, 107)

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel()

	local r, g, b, a = self:GetColor()
	local flashTime = self:GetDTFloat(0)
	local glowColor = Color(0, 255, 0, a)
	local position = self:GetPos()
	local forward = self:GetForward() * -22
	local curTime = CurTime()
	local right = self:GetRight() * -18
	local up = self:GetUp() * 67.5

	if (self:GetStock() == 0) then
		glowColor = Color(255, 150, 0, a)
	end

	if (flashTime and flashTime >= curTime) then
		if (self:GetDTBool(0)) then
			glowColor = Color(0, 0, 255, a)
		else
			glowColor = Color(255, 0, 0, a)
		end
	end

	local dlight = DynamicLight( self:EntIndex() )
	if dlight then
		dlight.Pos = self:GetPos()
		dlight.r = lightColor.r
		dlight.g = lightColor.g
		dlight.b = lightColor.b
		dlight.Brightness = 1
		dlight.Decay = 1000
		dlight.size = 256
		dlight.DieTime = CurTime() + .1
	end

	cam.Start3D( EyePos(), EyeAngles() )
		render.SetMaterial(glowMaterial)
		render.DrawSprite(position + forward + right + up, 20, 20, glowColor)
	cam.End3D()
end
