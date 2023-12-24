include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:Initialize()
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetNetVar("active", true)
end

function ENT:SetUser(ply)
    self:SetNetVar("user", ply)
end

function ENT:OnRemove()
    local user = self:GetUser()
    if user then
        user:SetNetVar("computer", nil)
    end

    local spawner = self:GetNetVar("spawner", nil)
    if spawner and spawner.computers then
        spawner.computers = spawner.computers - 1
    end
end
