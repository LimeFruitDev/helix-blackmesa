function EFFECT:Init(eData)
	if (eData.GetMaterialIndex) then -- Temp Fix, GetMaterialIndex is removed on 64 bit
		self.Data = Fireworks:GetEffectData(eData:GetMaterialIndex())
	else
		self.Data = Fireworks:GetEffectData(eData:GetFlags())
	end
	self.Color = self.Data.color
	self.Pos = self.Data.location
	self.Emitter = ParticleEmitter(self.Pos, false)
	local len = Vector(self.Data.direction.x, self.Data.direction.y, 0):Length()
	local p = len * 90
	local y = math.deg(math.atan2(-self.Data.direction.y, self.Data.direction.x))
	self.Data.Angles = Angle(p, y, 0)
end

local function LaserThink(particle)
	particle:SetNextThink(CurTime())
	particle:SetPos(particle.Data.location)
	particle:SetVelocity(particle.Data.Angles:Up() * 0.01)
	local col = particle.Data.color
	particle:SetColor(col.r, col.g, col.b)
end

function EFFECT:Think()
	if (self.Emitted) then
		self.Emitter:Finish()
		return false
	end
	local particle = self.Emitter:Add("effects/laser_citadel1", self.Pos)
	if (particle) then
		particle:SetVelocity(self.Data.Angles:Up() * 0.01)
		particle:SetDieTime(self.Data.lifetime)
		particle:SetStartAlpha(255)
		local col = self.Data.color
		particle:SetColor(col.r, col.g, col.b)
		particle:SetStartSize(self.Data.width)
		particle:SetEndSize(self.Data.width)
		particle:SetStartLength(5000)
		particle:SetEndLength(5000)
		particle:SetRoll(360)
		particle:SetRollDelta(1)
		particle:SetNextThink(CurTime())
		particle:SetThinkFunction(LaserThink)
		particle.Data = self.Data
	end
	self.Emitted = true
	return true
end



function EFFECT:Render()
end
