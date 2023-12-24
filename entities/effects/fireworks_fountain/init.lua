function EFFECT:Init(eData)
	if (eData.GetMaterialIndex) then -- Temp Fix, GetMaterialIndex is removed on 64 bit
		self.Data = Fireworks:GetEffectData(eData:GetMaterialIndex())
	else
		self.Data = Fireworks:GetEffectData(eData:GetFlags())
	end
	local len = Vector(self.Data.direction.x, self.Data.direction.y, 0):Length()
	local p = len * 90
	local y = math.deg(math.atan2(-self.Data.direction.y, self.Data.direction.x))
	self.Angles = Angle(p, y, 0)
	self.Pos = self.Data.location
	self.Emitter = ParticleEmitter(self.Pos, false)
	self.Magnitude = self.Data.magnitude
	self.EndTime = self.Data.lifetime + CurTime()

	local light = DynamicLight(0)
	if (light) then
		light.Pos = self.Pos + Vector(0,0,10)
		local h,s,v = ColorToHSV(self.Data.color)
		local lightcol = HSVToColor(h,math.max(s-0.15,0),v)
		light.r = lightcol.r
		light.g = lightcol.g
		light.b = lightcol.b
		light.Brightness = 4
		light.Size = self.Magnitude / 1.5
		local dietime = self.EndTime + 3
		light.DieTime = dietime
		light.Decay = 0
	end
	self.Light = light
end

function EFFECT:Think()
	if (self.EndTime && self.EndTime < CurTime()) then
		self.Emitter:Finish()
		if (self.Light) then
			self.Light.Decay = 8000
		end
		return false
	end
	for i = 0, self.Magnitude / 500 do
		local particle = self.Emitter:Add("effects/spark", self.Pos)
		if (particle) then
			local col = self.Data.color
			particle:SetColor(col.r, col.g, col.b)
			local h,s,v = ColorToHSV(col)
			local lightcol = HSVToColor(h,math.max(s-0.2,0),v)
			if (self.Light) then
				self.Light.r = lightcol.r
				self.Light.g = lightcol.g
				self.Light.b = lightcol.b
			end

			local dir = self.Angles * 1
			local mathang = math.Rand(0, math.pi * 2)
			local amt = math.Rand(0, self.Data.spread)
			dir:RotateAroundAxis(dir:Forward(), math.sin(mathang) * amt)
			dir:RotateAroundAxis(dir:Right(), math.cos(mathang) * amt)
			particle:SetVelocity(dir:Up() * (self.Magnitude * math.Rand(0.8, 1.2)))
			particle:SetDieTime(math.Rand(0.1, 1) * math.max(1,self.Magnitude / 350))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			particle:SetStartSize(math.Rand(6, 8) * math.min(1, self.Magnitude / 500))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-5, 5))
			particle:SetAirResistance(30)
			particle:SetGravity(Vector(0, 0, -600))
			particle:SetCollide(true)
			particle:SetBounce(0.2)
			local brightness = self.Emitter:Add("effects/spark", self.Pos)
			if (brightness) then
				brightness:SetVelocity(particle:GetVelocity())
				lightcol = HSVToColor(h,0,1)
				brightness:SetColor(lightcol.r, lightcol.g, lightcol.b)
				brightness:SetDieTime(particle:GetDieTime()/1.5)
				brightness:SetStartAlpha(255)
				brightness:SetEndAlpha(255)
				brightness:SetStartSize(particle:GetStartSize() / 2)
				brightness:SetEndSize(0)
				brightness:SetRoll(particle:GetRoll())
				brightness:SetRollDelta(particle:GetRollDelta())
				brightness:SetAirResistance(particle:GetAirResistance())
				brightness:SetGravity(particle:GetGravity())
				brightness:SetCollide(true)
				brightness:SetBounce(particle:GetBounce())
			end
		end
	end
	return true
end

function EFFECT:Render()
end
