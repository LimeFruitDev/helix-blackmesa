AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_blackmesa/securitycamera.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local physicsObject = self:GetPhysicsObject()
	if ( IsValid(physicsObject) ) then
		physicsObject:Wake()
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end