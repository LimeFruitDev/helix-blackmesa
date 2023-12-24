include("shared.lua")

	NULL.GetSuit = function() return NULL end
	NULL.GetUsed = function() return true end

function ENT:Draw()
	
	if not self:GetSuit() then return end

	if not self:GetSuit():GetUsed() then 
	self:DrawModel()
	end


end