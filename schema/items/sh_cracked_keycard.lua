ITEM.name = "Cracked Keycard"
ITEM.description = "A flat piece of plastic with poorly imprinted Black Mesa logo."
ITEM.model = "models/sky/cid.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.noBusiness = true
ITEM.iconCam = {
	pos = Vector( 57.848472595215, 48.591835021973, 35.289249420166 ),
	ang = Angle( 25, 220, 0 ),
	fov = 4.2223741746681,
}

-- Item function which returns the description
function ITEM:GetDescription()
	local description = self.description .. "\nThe keycard belongs to G£N$EC 1337hack0rz."

	return description
end
