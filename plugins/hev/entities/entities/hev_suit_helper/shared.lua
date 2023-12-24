ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Spawnable = false

function ENT:SetupDataTables() self:NetworkVar("Entity",0,"Suit") end

