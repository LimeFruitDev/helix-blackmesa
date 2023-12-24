DEFINE_BASECLASS("base_gmodentity")

ENT.PrintName = "Snack Machine"
ENT.Author = "Zoephix"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "BMRP"
ENT.RenderGroup = RENDERGROUP_BOTH

-- A function to get the entity's stock.
function ENT:GetStock()
	return self:GetDTInt(0)
end

-- Called when the datatables are setup.
function ENT:SetupDataTables()
	self:DTVar("Int", 0, "stock")
	self:DTVar("Bool", 0, "action")
	self:DTVar("Float", 0, "flash")
end