SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
	["ValveBiped.weapon_bone"] = { scale = Vector(1, 1, 1), pos = Vector(-0.094, -0.281, -0.253), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-50.612, 60.873, 0) },
	["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-23.928, 131.072, 0) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-8.646, -4.264, 162.735) }
}
SWEP.VElements = {
}
SWEP.WElements = {
	["baton"] = { type = "Model", model = "models/weapons/melee/w_tonfa.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.851, 1.213, -1.433), angle = Angle(-4.601, -85.235, 180), size = Vector(1.054, 1.054, 1.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.PrintName = "Baton"
    
SWEP.Author = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "BMRP"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/melee/v_tonfa.mdl" 
SWEP.WorldModel = "models/weapons/melee/w_tonfa.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.Slot = 0
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.HoldType = "melee" 

SWEP.FiresUnderwater = true

SWEP.DrawCrosshair = true

SWEP.DrawAmmo = true

SWEP.ReloadSound = ""

SWEP.Base = "weapon_base"

SWEP.Primary.Sound = Sound("") 
SWEP.Primary.Damage = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = -1 
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Spread = 0.1
SWEP.Primary.NumberofShots = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.1
SWEP.Primary.Delay = 0.5
SWEP.Primary.Force = 3

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.CSMuzzleFlashes = false

function SWEP:Initialize()
util.PrecacheSound(self.Primary.Sound) 
util.PrecacheSound(self.ReloadSound) 
        self:SetWeaponHoldType("melee")
end 
function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
	timer.Simple(0.98,function() self:SendWeaponAnim( ACT_VM_IDLE ) end)
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )

	return true
end 
function SWEP:PrimaryAttack()

self.Weapon:SetNextPrimaryFire(CurTime() + 0.8)
self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
timer.Simple(0.7,function()
	if IsValid(self.Weapon) then
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
	end
end)

local trace = self.Owner:GetEyeTrace()

if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 62 then
	bullet = {}
	bullet.Num    = 1
	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector(0, 0, 0)
	bullet.Tracer = 0
	bullet.Force  = 1
	bullet.Damage = 3
        self.Owner:FireBullets(bullet)
        self.Owner:SetAnimation( PLAYER_ATTACK1 );
		self.Weapon:EmitSound("weapons/tonfa/tonfa_swing_miss"..math.random(1,2)..".wav", 60, 100, 1, 0)
		self.Weapon:EmitSound("weapons/tonfa/melee_tonfa_"..math.random(1,2)..".wav", 60, 100, 1, 0)
		if (trace.Entity:IsPlayer()) then
			if SERVER then
				trace.Entity:SetRagdolled(true, 10, 10)
			end
			--[[ trace.Entity:SetNWBool("DrawBlurEffects", true)
			if (SERVER) then
				trace.Entity:SetWalkSpeed(30)
			end
			
			timer.Simple(10, function()
				trace.Entity:SetNWBool("DrawBlurEffects", false)
				if (SERVER) then
					trace.Entity:SetWalkSpeed(90)
				end
			end) ]]
		end
else
	self.Weapon:EmitSound("weapons/tonfa/tonfa_swing_miss"..math.random(1,2)..".wav", 60, 100, 1, 0)
self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
self.Owner:SetAnimation( PLAYER_ATTACK1 )

end

end
function SWEP:SecondaryAttack()
self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
timer.Simple(0.9,function() self.Weapon:SendWeaponAnim(ACT_VM_IDLE) end)
self.Weapon:SetNextSecondaryFire(CurTime() + 0.8)
local trace = self.Owner:GetEyeTrace()
	if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 62 then
		if SERVER then
			-- trace.Entity:TakeDamage(math.random(5,10),self.Owner)

			if trace.Entity:IsNPC() or trace.Entity:IsPlayer() then
				trace.Entity:SetVelocity(self.Owner:GetForward()*1200)
			end
		end
		self:EmitSound(Sound("player/survivor/swing/swish_weaponswing_swipe5.wav")) 
		self.Weapon:EmitSound("player/survivor/hit/rifle_swing_hit_survivor"..math.random(1,2)..".wav", 100,math.random(90,110), 1, 0)
		self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND);
	else
		self:EmitSound(Sound("player/survivor/swing/swish_weaponswing_swipe5.wav")) 
		self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND)
	end
end
function SWEP:Initialize()

	--other initialize code goes here

	if CLIENT then
		self:SetWeaponHoldType( self.HoldType )
		--Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) --create viewmodels
		self:CreateModels(self.WElements) --create worldmodels
		
		--init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				--Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					--we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					--^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					--however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end

end

function SWEP:Holster()
	
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		local vm = self.Owner:GetViewModel()

		if !IsValid(vm) then
			return
		end
		
		if (!self.VElements) then
			return
		end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			-- we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			-- when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			--Technically, if there exists an element with the same name as a bone
			--you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r --Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		-- Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDERGROUP_OTHER)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				--make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			--!! WORKAROUND !! //
			--We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			--!! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				--!! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				--!! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	/**************************
		Global utility code
	**************************/

	--Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	--Does not copy entities of course, only copies their reference.
	--WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) --recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end
