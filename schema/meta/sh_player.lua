
local PLAYER = FindMetaTable("Player")

function PLAYER:Puke()
	self:ViewPunch(Angle(20, 0, 0))

	local edata = EffectData()
	edata:SetOrigin(self:EyePos())
	edata:SetEntity(self)

	util.Effect("puke", edata, true, true)
end

function PLAYER:IsNoclipped()
	if (self:GetMoveType() == MOVETYPE_NOCLIP and !self:InVehicle()) then
		return true
	end

	return false
end

-- BACKWARDS COMP ADDED 07/12/2023
function PLAYER:IsStaff()
	return self:IsAdmin()
end
