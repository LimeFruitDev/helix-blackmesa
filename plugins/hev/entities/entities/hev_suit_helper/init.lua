AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Items/mhevsuit.mdl")
    self:SetSolid(SOLID_VPHYSICS)
 
end	

	ENT.EndTouch 				= nilfunc
	ENT.GetOverlayText 			= nilfunc
	ENT.KeyValue 				= nilfunc
	ENT.OnRemove 				= nilfunc
	ENT.OnRestore 				= nilfunc
	ENT.OnTakeDamage 			= nilfunc
	ENT.Use 					= nilfunc
	ENT.UpdateTransmitState 	= nilfunc
	ENT.TriggerOutput 			= nilfunc
	ENT.Touch 					= nilfunc
	ENT.Think 					= nilfunc
	ENT.SetPlayer 				= nilfunc
	ENT.PhysicsCollide 			= nilfunc
	ENT.PhysicsUpdate 			= nilfunc
