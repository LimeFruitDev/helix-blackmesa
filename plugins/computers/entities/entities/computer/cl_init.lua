include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Think()
	if not self:IsActive() then return end
    if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 100000 then return end

	local curSkin = self:GetSkin()
	if curSkin == 0 or curSkin == 5 then return end

	-- add some dynamic light to the screen
	local dlight = DynamicLight(self:EntIndex())

	if dlight then
		dlight.pos = self:GetPos() + (self:GetUp() * 52) + (self:GetForward() * 8)
		dlight.r = 81
		dlight.g = 108
		dlight.b = 150
		dlight.brightness = 2
		dlight.Decay = 0
		dlight.Size = 250
		dlight.DieTime = CurTime() + 1

		if (self:IsBluescreened()) then
			dlight.r = 0
			dlight.g = 0
			dlight.b = 255
		end
	end
end

ENT.DisplayAngle = Angle(-90, 0, 90)
ENT.DisplayScale = 0.0177
ENT.DisplayVector = Vector(17.05, 2.5, 11.8)

function ENT:Draw()
	self:DrawModel()

    if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 100000 then return end
    if self:GetUser() and self:GetUser() ~= LocalPlayer() then return end

    if PLUGIN.computer == self and IsValid(PLUGIN.monitor) then
        local ang = self:GetAngles()
        local pos = self:GetPos() + self:GetUp() * self.DisplayVector.z + self:GetRight() * self.DisplayVector.x + self:GetForward() * self.DisplayVector.y
        ang:RotateAroundAxis( self:GetRight(), self.DisplayAngle.pitch ) -- pitch
        ang:RotateAroundAxis( self:GetUp(),  self.DisplayAngle.yaw )-- yaw
        ang:RotateAroundAxis( self:GetForward(), self.DisplayAngle.roll )-- roll
    end
end
