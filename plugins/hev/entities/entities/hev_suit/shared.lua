ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "HEV Suit"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "BMRP"

function ENT:SetupDataTables()

	self:NetworkVar("Bool", 0, "Used")
	self:NetworkVar("Entity",0,"Suit")

end

