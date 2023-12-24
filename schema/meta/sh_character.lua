local CHAR = ix.meta.character

-- Returns whether the character is in the given faction
function CHAR:IsFaction(faction)
	return self:GetFaction() == faction
end
