--[[ ---------------------------------------------------------
Initializes the effect.The data is a table of data
which was passed from the server.
--------------------------------------------------------- ]]
local matdata = {
	["$nocull"] = 1,
	["$additive"] = 1,
	["$basetexture"] = "sprites/light_glow01",
	["$ignorez"] = 0,
	["$vertexalpha"] = 1,
	["$vertexcolor"] = 1,
}
local mat = CreateMaterial("Firework", "UnLitGeneric", matdata)

local startsizebig = 40
local maxsizebig = 170
function EFFECT:Init(eData)
	--LocalPlayer():Notify(data:GetColor())
	local dataIndex
	if (eData.GetMaterialIndex) then -- Temp Fix, GetMaterialIndex is removed on 64 bit
		dataIndex = eData:GetMaterialIndex()
	else
		dataIndex = eData:GetFlags()
	end

	local data = Fireworks:GetEffectData(dataIndex)
	local vOffset = data.location
	self.Emitter = ParticleEmitter(vOffset, false)
	self.data = data
	self.particle = self.Emitter:Add(mat, vOffset)
	local col = self.data.color
	local len = Vector(data.direction.x, data.direction.y,0):Length()
	local z = math.cos(len * math.pi / 2)
	local velo = Vector(data.direction.x, -data.direction.y, z) * data.height
	velo = velo + Vector(0, 0, (3.5) * (160))
	local dietime = data.lifetime
	local light = DynamicLight(0)
	if (light) then
		light.Pos = vOffset
		light.r = data.color.r
		light.g = data.color.g
		light.b = data.color.b
		light.Brightness = 5
		light.Size = startsizebig*6
		light.Decay = 0
		light.DieTime = CurTime()+dietime
	end
	self.particle:SetVelocity(velo)
	self.particle:SetLifeTime(0)
	self.particle:SetDieTime(dietime)
	self.particle:SetGravity(Vector(0, 0, -80))
	self.particle:SetAirResistance(30)
	self.particle:SetStartAlpha(255)
	self.particle:SetEndAlpha(255)
	self.particle:SetRoll(math.Rand(0,math.pi*2))
	local dir = math.random(-1,1)
	dir = Either(dir==0, 1, -1)
	self.particle:SetRollDelta((math.Rand(0,2)+1)*dir)
	self.particle:SetStartSize(startsizebig)
	self.particle:SetEndSize(startsizebig)
	self.particle:SetColor(col.r, col.g, col.b)
	self.particle.light = light
	self.particle2 = self.Emitter:Add(mat, vOffset)
	self.particle2:SetVelocity(velo)
	self.particle2:SetLifeTime(0)
	self.particle2:SetDieTime(dietime)
	self.particle2:SetAirResistance(30)
	self.particle2:SetGravity(Vector(0, 0, -80))
	self.particle2:SetStartAlpha(255)
	self.particle2:SetEndAlpha(255)
	self.particle2:SetRoll(self.particle:GetRoll()*2)
	self.particle2:SetRollDelta(self.particle:GetRollDelta()*-1)
	self.particle2:SetStartSize(startsizebig/2)
	self.particle2:SetEndSize(startsizebig/2)
	self.particle2:SetColor(255, 255, 255)
	self.StartTime = CurTime()
	self.EndTime = CurTime() + dietime
	self.ShrinkStartTime = self.EndTime - 2.5
	--if(data:GetMaterialIndex() == 1) then
end

--[[ -------------------------------
--------------------------
THINK
--------------------------------------------------------- ]]
function EFFECT:Think()
	if (self.EndTime && self.EndTime < CurTime()) then
		self.Emitter:Finish()
		return false
	end
	local col = self.data.color
	if (CurTime() > self.ShrinkStartTime) then
		local ratio = math.pow((self.EndTime - CurTime()) / (self.EndTime - self.ShrinkStartTime), 2)
		local size = ratio * maxsizebig
		self.particle:SetStartSize(size)
		self.particle:SetEndSize(size)
		size = size/2
		self.particle2:SetStartSize(size)
		self.particle2:SetEndSize(size)
	else
		local ratio = 1 - (self.ShrinkStartTime - CurTime()) / (self.ShrinkStartTime - self.StartTime)
		local size = ratio * (maxsizebig - startsizebig) + startsizebig
		self.particle:SetStartSize(size)
		self.particle:SetEndSize(size)
		size = size/2
		self.particle2:SetStartSize(size)
		self.particle2:SetEndSize(size)
	end
	if (self.particle.light) then
		self.particle.light.Pos = self.particle:GetPos()
		self.particle.light.Brightness = 5
		self.particle.light.Size = self.particle:GetStartSize() * 6
		--LocalPlayer():Notify(self.particle.light)
	end
	if (!self.data.sparks) then return true end
	local Smoke = self.Emitter:Add("particle/smokesprites_000" .. math.random(1, 9), self.particle:GetPos())
	if (Smoke) then
		Smoke:SetVelocity(self.particle:GetVelocity() / 5 + Vector(math.Rand(1, 3), math.Rand(1, 3), 0) * 15)
		Smoke:SetDieTime(math.Rand(2, 5))
		Smoke:SetStartAlpha(math.Rand(30, 40))
		Smoke:SetEndAlpha(0)
		Smoke:SetStartSize(math.Rand(5, 10))
		Smoke:SetEndSize(0)
		Smoke:SetRoll(math.Rand(150, 360))
		Smoke:SetRollDelta(math.Rand(-2, 2))
		Smoke:SetAirResistance(300)
		Smoke:SetGravity(Vector(0, 0, 0))
		Smoke:SetColor(100, 100, 100)
		Smoke:SetLighting(true)
	end
	self.LastSpark = self.LastSpark or CurTime()
	local lifetime = self.particle:GetLifeTime() / self.particle:GetDieTime()
	if (lifetime > 0.2 && lifetime < 0.9) then
		if (self.LastSpark < CurTime()) then
			local particle = self.Emitter:Add("effects/spark", self.particle:GetPos())
			if (particle) then
				particle:SetVelocity(-(self.particle:GetVelocity()) + Vector(math.Rand(1, 3), math.Rand(1, 3), 0) * 15)
				particle:SetDieTime(math.Rand(0.05, 1.5))
				particle:SetStartAlpha(255)
				particle:SetStartSize(math.Rand(5, 10))
				particle:SetEndSize(0)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-5, 5))
				particle:SetAirResistance(40)
				particle:SetGravity(Vector(0, 0, -100))
				particle:SetColor(255, 225, 170)
				particle:SetCollide(true)
				particle:SetBounce(0.05)
			end
			self.LastSpark = CurTime() + 0.01
		end
	end
	return true
end

--[[ ---------------------------------------------------------
Draw the effect
--------------------------------------------------------- ]]
function EFFECT:Render()
end
