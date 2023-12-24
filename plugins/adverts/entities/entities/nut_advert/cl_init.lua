include( "shared.lua" )

function ENT:Draw()
	self:DrawModel()
end

function ENT:CreateHTML(width, height)
    self.panel = vgui.Create("HTML")
    self.panel:SetSize(width, height)
    self.panel:SetPos(0, 0)
    self.panel:SetPaintedManually(true)
    self.panel:SetMouseInputEnabled(false)
end

ENT.DisplayVector = Vector(28, 6.5, 35.25)
ENT.DisplayAngle = Angle(-90, 0, 90)
ENT.DisplayScale = .035

function ENT:DrawTranslucent()
	local pos = self:GetPos() + self:GetUp() * self.DisplayVector.z + self:GetRight() * self.DisplayVector.x + self:GetForward() * self.DisplayVector.y
	local ang = self:GetAngles() 
	ang:RotateAroundAxis(self:GetRight(), self.DisplayAngle.pitch) -- pitch
	ang:RotateAroundAxis(self:GetUp(),  self.DisplayAngle.yaw)-- yaw
	ang:RotateAroundAxis(self:GetForward(), self.DisplayAngle.roll)-- roll
	cam.Start3D2D(pos, ang, self.DisplayScale)
		if self:GetPos():DistToSqr( LocalPlayer():GetPos()) < 250000 then
            if (not IsValid(self.panel)) then
                self:CreateHTML(1600, 925)
                netstream.Start("advertsGet")
            end

			self.panel:PaintManual()
		end
	cam.End3D2D()
end
