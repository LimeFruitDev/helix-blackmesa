AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Bodygroup Changer"
ENT.Category = "BMRP"
ENT.Spawnable = true
ENT.AdminOnly = true

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_c17/lockers001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local physicsObject = self:GetPhysicsObject()

    if ( IsValid(physicsObject) ) then
      physicsObject:Wake()
    end
	end

	function ENT:Use(activator)
		net.Start("ixBodygroupView")
			net.WriteEntity(activator)
		net.Send(activator)
	end

	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
	end
else
	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(container)
		local text = container:AddRow("name")
		text:SetImportant()
		text:SetText("Locker")
		text:SizeToContents()

    local description = container:AddRow("description")
		description:SetText("A locker that contains various clothing.")
		description:SizeToContents()
	end
end
