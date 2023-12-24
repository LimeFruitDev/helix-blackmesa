local PLUGIN = PLUGIN

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

	util.AddNetworkString("hevsuit_send")
	local mhevmdl

function ENT:Initialize()
	self:SetModel("models/props_wasteland/controlroom_filecabinet002a.mdl")
    self:SetSolid(SOLID_VPHYSICS)
    self:DrawShadow(false)
    self.busy = false
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
 
 	hevmdl = ents.Create("hev_suit_helper")
 	hevmdl:SetPos(self:GetPos() - Vector(0,0,35))
 	hevmdl:Spawn()

	self:SetSuit(hevmdl)
	hevmdl:SetSuit(self)

 	hevmdl.Think = function() 

 	if IsValid(hevmdl) and IsValid(hevmdl:GetSuit()) then 
 	hevmdl:SetPos(hevmdl:GetSuit():GetPos() - Vector(0,0,35))
 	hevmdl:SetAngles(hevmdl:GetSuit():GetAngles())
 	end
 	end


	timer.Create("hevsuit_update_"..self:EntIndex(),PLUGIN.RestoreTime,0,function() if IsValid(self) then self:SetUsed(false) end end)
	timer.Create("hevsuit_updateent"..self:EntIndex(),5,0,function()  self.busy = false end)

end	

function ENT:SpawnFunction(ply, trace)
	
	local ent = ents.Create("hev_suit")
	ent:SetPos(trace.HitPos + trace.HitNormal * 35)
	ent:Spawn()
	ent:Activate()
	return ent

end

function ENT:OnRemove() self:GetSuit():Remove() end

function ENT:OnTakeDamage() return end

function ENT:Touch(activator, ply) 

	if self.busy then return end
	if not IsValid(activator) then return end

	self.busy = true

	if self:GetUsed() or activator.IsHEV then 
		activator:ChatPrint("You returned the suit.") 
		activator:SendLua("HEV_RestoreDefaults()")
		self:SetUsed(false)
		activator.IsHEV = false
		activator:SetModel(activator.OldModel)
		activator:SetHands(activator.OldHands)
	return end
	
	self:SetUsed(true)

	if not activator.IsHEV then 
	activator.OldModel = activator:GetModel()
	activator.OldHands = activator:GetHands()
	net.Start("hevsuit_send")
	net.Send(activator)
	activator:ChatPrint("You obtained the hazard suit.")
	activator.IsHEV = true
	activator:SetModel("models/limefruit/hev/male.mdl")
	end

	local hands = ents.Create( "gmod_hands" )
			if ( IsValid( hands ) ) then 
			activator:SetHands( hands )
			hands:SetOwner( ply )
			local cl_playermodel = activator:GetInfo( "cl_playermodel" )
			local info = player_manager.TranslatePlayerHands( cl_playermodel )
			if ( info ) then
			hands:SetModel( "models/hevarms/bms/c_arms_bms_hev.mdl")
			end
			local vm = activator:GetViewModel( 0 )
			hands:AttachToViewmodel( vm )

			vm:DeleteOnRemove( hands )
			activator:DeleteOnRemove( hands )
			hands:Spawn()

			hook.Add("inSuit.UpdateHands","inSuit",function(tab)  handsmodel = tab.model end)
	end

end

	hook.Add("PlayerDeath","inSuit.Restore",function(ply)

	ply:SendLua("HEV_RestoreDefaults()")

	end)
