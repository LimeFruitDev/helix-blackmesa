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

local function getLocation(type)
	if (type == 1) then
		return AngleRand():Right():GetNormal()
	elseif (type == 2) then
		return VectorRand()
	elseif (type == 3) then
		local angle = AngleRand()
		return Vector(math.sin(angle.p), math.cos(angle.y), 0):GetNormal()
	elseif (type == 4) then
		local angle = AngleRand()
		return Vector(math.sin(angle.p), 0, math.cos(angle.r)):GetNormal()
	elseif (type == 5) then
		local angle = AngleRand()
		return Vector(0, math.sin(angle.y), math.cos(angle.r)):GetNormal()
	end
end

function EFFECT:Init(eData)
	if (eData.GetMaterialIndex) then -- Temp Fix, GetMaterialIndex is removed on 64 bit
		self.Data = Fireworks:GetEffectData(eData:GetMaterialIndex())
	else
		self.Data = Fireworks:GetEffectData(eData:GetFlags())
	end
	local col = self.Data.color
	local rand = self.Data.size
	if (rand == 1) then
		LargeEffect(self.Data, col)
	elseif (rand == 2) then
		MediumEffect(self.Data, col)
	else
		SmallEffect(self.Data, col)
	end
	local light = DynamicLight(0)

	if (light) then
		light.Pos = self.Data.location
		light.r = col.r
		light.g = col.g
		light.b = col.b
		light.Brightness = 8
		light.Size = Either(rand == 1, 6000, Either(rand == 2, 4000, 2000))
		light.Decay = 2500
		light.DieTime = CurTime() + 2
	end

	local emitter = ParticleEmitter(self.Data.location)
	for i = 1, 3 do
		local particle = emitter:Add("particles/smokey", self.Data.location + VectorRand() * 50)
		if (!particle) then continue end
		particle:SetVelocity(Vector(0.8, 0.5, -0.1) * math.random(50, 100))
		particle:SetLifeTime(0)
		particle:SetDieTime(math.Rand(5, 10))
		particle:SetStartAlpha(5)
		particle:SetEndAlpha(0)
		particle:SetStartSize(70)
		particle:SetEndSize(150)
		particle:SetColor(190, 190, 190)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetLighting(true)
	end
	local size = Either(rand == 1, 2000, Either(rand == 2, 1350, 900))
	self.particle2 = emitter:Add(mat, self.Data.location)
	self.particle2:SetVelocity(Vector(0, 0, 0))
	self.particle2:SetLifeTime(0)
	self.particle2:SetDieTime(0.3)
	self.particle2:SetAirResistance(30)
	self.particle2:SetGravity(Vector(0, 0, 0))
	self.particle2:SetStartAlpha(255)
	self.particle2:SetEndAlpha(100)
	self.particle2:SetStartSize(size)
	self.particle2:SetEndSize(0)
	self.particle2:SetColor(col.r, col.g, col.b)
	self.particle2:SetLighting(false)

	self.particle = emitter:Add(mat, self.Data.location)
	self.particle:SetVelocity(Vector(0, 0, 0))
	self.particle:SetLifeTime(0)
	self.particle:SetDieTime(0.3)
	self.particle:SetAirResistance(30)
	self.particle:SetGravity(Vector(0, 0, 0))
	self.particle:SetStartAlpha(255)
	self.particle:SetEndAlpha(100)
	self.particle:SetStartSize(size/2)
	self.particle:SetEndSize(0)
	self.particle:SetColor(255, 255, 255)
	self.particle:SetLighting(false)

	emitter:Finish()
end

function LargeEffect(data, col)
	local NumParticles = 145
	local vOffset = data.location
	local type = data.type
	-- local Distance = LocalPlayer():GetPos():Distance(vOffset)
	
	-- if (Distance < 5000) then
		--timer.Simple(Distance/767/5, function()
		SoundPlay("limefruit/new_year/fireworks/firework_big_" .. math.random(1, 7) .. ".wav", vOffset, 100, nil, 3)
		if (math.random(1, 5) != 1) then
			timer.Simple(0.5, function()
				SoundPlay("limefruit/new_year/fireworks/firework_rain_3.wav", vOffset, 100)
			end)
		end
		--end)
	-- end

	local emitter = ParticleEmitter(vOffset)
	for i = 0, NumParticles do
		particle = emitter:Add(mat, vOffset)

		if (particle) then
			local dietime = math.Rand(0.6, 1.75)
			local location = getLocation(type)
			local Vec = location and location * math.random(1000, 1450) or Vector(0, 0, 0)
			local brightness = emitter:Add(mat, vOffset)
			particle:SetVelocity(Vec)
			particle:SetLifeTime(0)
			particle:SetDieTime(dietime)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(50)
			local size = math.Rand(85, 100)
			particle:SetStartSize(size)
			particle:SetEndSize(0)
			particle:SetColor(col.r, col.g, col.b)
			particle:SetAirResistance(150)
			particle:SetGravity(Vector(0, 0, -100))
			particle:SetCollide(true)
			particle:SetBounce(0.3)
			if(brightness) then
				brightness:SetVelocity(Vec)
				brightness:SetLifeTime(0)
				brightness:SetDieTime(dietime)
				brightness:SetStartAlpha(255)
				brightness:SetEndAlpha(50)
				brightness:SetStartSize(size/2)
				brightness:SetEndSize(0)
				brightness:SetColor(255, 255, 255)
				brightness:SetAirResistance(150)
				brightness:SetGravity(Vector(0, 0, -100))
				brightness:SetCollide(true)
				brightness:SetBounce(0.3)
			end
			if (data.sparks) then
				trace = emitter:Add("effects/spark", vOffset)
				trace:SetVelocity(Vec:GetNormal())

				trace:SetLifeTime(0)
				trace:SetDieTime(dietime / 4)

				trace:SetStartAlpha(255)
				trace:SetEndAlpha(255)
				trace:SetColor(col.r, col.g, col.b)
				trace:SetStartLength(20)
				trace:SetStartSize(20)
				trace:SetEndSize(20)
				trace:SetEndLength(Vec:Length() * dietime / 3)


				trace:SetAirResistance(50)

				trace:SetCollide(true)
				trace:SetBounce(0.3)
			end
		end
	end
	emitter:Finish()
end

function SmallEffect(data, col)
	local NumParticles = 25
	local vOffset = data.location
	local type = data.type
	local Distance = LocalPlayer():GetPos():Distance(vOffset)
	if (Distance < 2500) then
		--timer.Simple(Distance/767/5, function()
		SoundPlay("limefruit/new_year/fireworks/firework_small_" .. math.random(1, 7) .. ".wav", vOffset, 95, nil, 2)
		if (math.random(1, 20) != 1) then
			timer.Simple(0.5, function()
				SoundPlay("limefruit/new_year/fireworks/firework_rain_3.wav", vOffset, 90)
			end)
		end
		--end)
	end
	local emitter = ParticleEmitter(vOffset)
	for i = 0, NumParticles do
		local particle = emitter:Add(mat, vOffset)

		if (particle) then
			local dietime = math.Rand(0.6, 1.75)
			local location = getLocation(type)
			local Vec = location and location * math.random(350, 600) or Vector(0, 0, 0)
			local brightness = emitter:Add(mat, vOffset)
			particle:SetVelocity(Vec)
			particle:SetLifeTime(0)
			particle:SetDieTime(dietime)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(50)
			local size = math.Rand(65, 80)
			particle:SetStartSize(size)
			particle:SetEndSize(0)
			particle:SetColor(col.r, col.g, col.b)
			particle:SetAirResistance(150)
			particle:SetGravity(Vector(0, 0, -100))
			particle:SetCollide(true)
			particle:SetBounce(0.3)
			if(brightness) then
				brightness:SetVelocity(Vec)
				brightness:SetLifeTime(0)
				brightness:SetDieTime(dietime)
				brightness:SetStartAlpha(255)
				brightness:SetEndAlpha(50)
				brightness:SetStartSize(size/2)
				brightness:SetEndSize(0)
				brightness:SetColor(255, 255, 255)
				brightness:SetAirResistance(150)
				brightness:SetGravity(Vector(0, 0, -100))
				brightness:SetCollide(true)
				brightness:SetBounce(0.3)
			end
			if (data.sparks) then
				trace = emitter:Add("effects/spark", vOffset)
				trace:SetVelocity(Vec:GetNormal())

				trace:SetLifeTime(0)
				trace:SetDieTime(dietime / 8)

				trace:SetStartAlpha(255)
				trace:SetEndAlpha(255)
				trace:SetColor(col.r, col.g, col.b)
				trace:SetStartLength(20)
				trace:SetStartSize(20)
				trace:SetEndSize(20)
				trace:SetEndLength(Vec:Length() * dietime / 3)


				//trace:SetAirResistance( 50 )

				trace:SetCollide(true)
				trace:SetBounce(0.3)
			end
		end
	end
	emitter:Finish()
end

function MediumEffect(data, col)
	local NumParticles = 70
	local vOffset = data.location
	local type = data.type
	local Distance = LocalPlayer():GetPos():Distance(vOffset)
	if (Distance < 4000) then
		--timer.Simple(Distance/767/5, function()
		SoundPlay("limefruit/new_year/fireworks/firework_medium_" .. math.random(1, 7) .. ".wav", vOffset, 95, nil, 2)
		if (math.random(1, 10) != 1) then
			timer.Simple(0.5, function()
				SoundPlay("limefruit/new_year/fireworks/firework_rain_3.wav", vOffset, 95)
			end)
		end
		--end)
	end
	local emitter = ParticleEmitter(vOffset)
	for i = 0, NumParticles do
		particle = emitter:Add(mat, vOffset)

		if (particle) then
			local dietime = math.Rand(0.6, 1.75)
			local location = getLocation(type)
			local Vec = location and location * math.random(550, 900) or Vector(0, 0, 0)
			local brightness = emitter:Add(mat, vOffset)
			particle:SetVelocity(Vec)
			particle:SetLifeTime(0)
			particle:SetDieTime(dietime)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(50)
			local size = math.Rand(75, 90)
			particle:SetStartSize(size)
			particle:SetEndSize(0)
			particle:SetColor(col.r, col.g, col.b)
			particle:SetAirResistance(150)
			particle:SetGravity(Vector(0, 0, -100))
			particle:SetCollide(true)
			particle:SetBounce(0.3)
			if(brightness) then
				brightness:SetVelocity(Vec)
				brightness:SetLifeTime(0)
				brightness:SetDieTime(dietime)
				brightness:SetStartAlpha(255)
				brightness:SetEndAlpha(50)
				brightness:SetStartSize(size/2)
				brightness:SetEndSize(0)
				brightness:SetColor(255, 255, 255)
				brightness:SetAirResistance(150)
				brightness:SetGravity(Vector(0, 0, -100))
				brightness:SetCollide(true)
				brightness:SetBounce(0.3)
			end
			if (data.sparks) then
				trace = emitter:Add("effects/spark", vOffset)
				trace:SetVelocity(Vec:GetNormal())

				trace:SetLifeTime(0)
				trace:SetDieTime(dietime / 8)

				trace:SetStartAlpha(255)
				trace:SetEndAlpha(255)
				trace:SetColor(col.r, col.g, col.b)
				trace:SetStartLength(20)
				trace:SetStartSize(20)
				trace:SetEndSize(20)
				trace:SetEndLength(Vec:Length() * dietime / 3)


				//trace:SetAirResistance( 50 )

				trace:SetCollide(true)
				trace:SetBounce(0.3)
			end
		end
	end
	emitter:Finish()
end

--[[ ---------------------------------------------------------
THINK
--------------------------------------------------------- ]]
function EFFECT:Think()
	return false
end

function ParticleThink(part)
	part:SetNextThink(CurTime() + 0.1)
end

--[[ ---------------------------------------------------------
Draw the effect
--------------------------------------------------------- ]]
function EFFECT:Render()
end
