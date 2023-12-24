DEFINE_BASECLASS("base_gmodentity")

ENT.PrintName = "Computer"
ENT.Author = "Zoephix"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.Category = "BMRP"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:GetUser()
    return self:GetNetVar("user", nil)
end

function ENT:IsAuthorized()
    return self:GetNetVar("authorized", false)
end

function ENT:IsActive()
    return self:GetNetVar("active", false)
end

function ENT:IsBluescreened()
    return self:GetSkin() == 4
end
