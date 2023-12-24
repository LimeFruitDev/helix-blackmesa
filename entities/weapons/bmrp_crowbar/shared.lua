if (SERVER) then
	AddCSLuaFile("shared.lua");
end

if (CLIENT) then
	SWEP.Slot = 5;
	SWEP.SlotPos = 3;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "Crowbar";
	SWEP.DrawCrosshair = true;
end

SWEP.Instructions = "Primary Fire: attempt to jimmy a door.";
SWEP.Contact = "";
SWEP.Purpose = "";
SWEP.Author	= "Zoephix";

SWEP.ViewModel = "models/weapons/c_crowbar.mdl";
SWEP.WorldModel = "models/weapons/w_crowbar.mdl";
SWEP.HoldType = "melee";

SWEP.AdminSpawnable = false;
SWEP.Spawnable = false;
  
SWEP.BatterSound = "doors/door_locked2.wav"

SWEP.Sound = Sound("physics/wood/wood_box_impact_bullet4.wav")

SWEP.Primary.ClipSize = -1      -- Size of a clip
SWEP.Primary.DefaultClip = 0        -- Default number of bullets in a clip
SWEP.Primary.Automatic = false      -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1        -- Size of a clip
SWEP.Secondary.DefaultClip = 0     -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false     -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""

SWEP.NoIronSightFovChange = true;
SWEP.NoIronSightAttack = true;
SWEP.LoweredAngles = Angle(60, 60, 60);
SWEP.IronSightPos = Vector(0, 0, 0);
SWEP.IronSightAng = Vector(0, 0, 0);

function SWEP:Initialize()
    self:SetWeaponHoldType("melee")
end

-- Called when the SWEP is deployed.
function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW);
end;

-- Called when the SWEP is holstered.
function SWEP:Holster(switchingTo)
	self:SendWeaponAnim(ACT_VM_HOLSTER);
	return true;
end;

-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire(CurTime() + 2)

    local trace = self.Owner:GetEyeTrace()
    local e = trace.Entity
    if not IsValid(e) or trace.HitPos:Distance(self.Owner:GetShootPos()) > 100 then
    	return
    end

    if math.Round(math.random(1,2)) == 2 and IsValid(trace.Entity) and trace.Entity.Fire then
		timer.Simple(1, function()
			-- trace.Entity:Fire("unlock", "", .5)
			-- trace.Entity:Fire("open", "", .6)
			-- trace.Entity:Fire("setanimation","open",.6)
			self:EmitSound("physics/wood/wood_panel_break1.wav")
		end)
    end

    self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:SendWeaponAnim(ACT_VM_HOLSTER)
	
    self:EmitSound(self.BatterSound);
	
	if (self.MatType == 87) then
			self:EmitSound("physics/wood/wood_box_break" .. math.random(1, 2) .. ".wav", 80);
		elseif (self.MatType == MAT_GLASS || self.MatType == MAT_CONCRETE) then
			self:EmitSound("physics/glass/glass_impact_bullet" .. math.random(1, 4) .. ".wav", 80);
		else
			self:EmitSound("physics/metal/metal_solid_strain" .. math.random(3, 5) .. ".wav", 80);
		end
	
	self.Weapon:SetNextPrimaryFire(CurTime() + 2)
	self.Weapon:SetNextSecondaryFire(CurTime() + 2)
	
    self.Owner:ViewPunch(Angle(-5, math.random(-2, 2), 0))
end;

-- Called when the player attempts to secondary fire.
function SWEP:SecondaryAttack()
	self:PrimaryAttack();
end