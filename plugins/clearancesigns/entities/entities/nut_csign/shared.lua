ENT.Type 	  = "anim"
ENT.PrintName = "Clearance Sign"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category  = "BMRP"

function ENT:Draw()
	self:DrawModel()

	if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) < 500000 then
		self:DrawTranslucent()
	end
end

ENT.DisplayScale = .25
ENT.DisplayVector = Vector(26, 1, 14)
ENT.DisplayAngle = Angle(-90, 0, 90)

function ENT:DrawTranslucent()
	local pos = self:GetPos() + self:GetUp() * self.DisplayVector.z + self:GetRight() * self.DisplayVector.x + self:GetForward() * self.DisplayVector.y
	local ang = self:GetAngles()

	ang:RotateAroundAxis(self:GetRight(), self.DisplayAngle.pitch)
	ang:RotateAroundAxis(self:GetUp(),  self.DisplayAngle.yaw)
	ang:RotateAroundAxis(self:GetForward(), self.DisplayAngle.roll)

	local clearance = self:GetNetVar("clearance")

	cam.Start3D2D(pos, ang, self.DisplayScale)
		draw.RoundedBox(0, 0, 0, 216, 108, Color(0, 0, 0))

		draw.SimpleText("CLEARANCE", "clearanceTitle", 10.5, 16, Color(255, 0, 0), 0, 0)
		draw.SimpleText("LEVEL " .. clearance, "clearanceLevel", string.len(clearance) == 1 and 54 or 46, 72, Color(255, 0, 0))
	cam.End3D2D()
end
