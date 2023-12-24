AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/props_am/am_sign_2.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	if not self:GetNetVar("clearance") then
		self:SetNetVar("clearance", "")
	end

	local physicsObject = self:GetPhysicsObject()

	if IsValid(physicsObject) then
		physicsObject:Wake()
	end
end
