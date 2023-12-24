--[[
	This script is part of the Black Mesa Evolved schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2022: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Button Override"
ENT.Author = "Zoephix"

ENT.Editable = false
ENT.Spawnable = false
ENT.AdminOnly = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	-- We do NOT want to execute anything below in this FUNCTION on CLIENT
	if (CLIENT) then return end

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetUseType(SIMPLE_USE)

	local physicsObject = self:GetPhysicsObject()
	
	if ( IsValid(physicsObject) ) then
		physicsObject:Wake()
	end
end

function ENT:Use( activator, caller )
	if (activator:IsPlayer() and activator:GetPos():DistToSqr(self:GetPos()) < 10000) then
		self:GetParent():Fire("Use", "", 0)
	end
end

if (SERVER) then return end -- We do NOT want to execute anything below in this FILE on SERVER

function ENT:Draw()
	-- self:DrawModel()
end
