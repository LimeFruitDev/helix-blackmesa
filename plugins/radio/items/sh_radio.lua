ITEM.name = "Radio"
ITEM.model = "models/deadbodies/dead_male_civilian_radio.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Miscellaneous"
ITEM.price = 150
ITEM.permit = "elec"
ITEM.exRender = true
ITEM.iconCam = {
	pos = Vector(150, 127.63716125488, 103),
	ang = Angle(25, 220, 0),
	entAng = Angle(0, 0, 0),
	fov = 4.5798989704988,
}

function ITEM:GetDescription()
	local str

	if (!self.entity or !IsValid(self.entity)) then
		str = "A radio that allows you to send a signal to other characters in distance.\nPower: %s\nFrequency: %s"
		return Format(str, (self:GetData("power") and "On" or "Off"), self:GetData("freq", "000.0"))
	else
		local data = self.entity:GetData()

		str = "A Functional Radio. Power: %s Frequency: %s"
		return Format(str, (self.entity:GetData("power") and "On" or "Off"), self.entity:GetData("freq", "000.0"))
	end
end

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("power", false)) then
			surface.SetDrawColor(110, 255, 110, 100)
		else
			surface.SetDrawColor(255, 110, 110, 100)
		end

		surface.DrawRect(w - 14, h - 14, 8, 8)
	end

	local GLOW_MATERIAL = Material("sprites/glow04_noz.vmt")
	local COLOR_ACTIVE = Color(0, 255, 0)
	local COLOR_INACTIVE = Color(255, 0, 0)

	function ITEM:DrawEntity(entity, item)
		entity:DrawModel()
		local rt = RealTime()*100
		local position = entity:GetPos() + entity:GetForward() * 0 + entity:GetUp() * 2 + entity:GetRight() * 0

		if (entity:GetData("power", false) == true and math.ceil(rt/14)%10 == 0) then
			render.SetMaterial(GLOW_MATERIAL)
			render.DrawSprite(position, rt % 14, rt % 14, entity:GetData("power", false) and COLOR_ACTIVE or COLOR_INACTIVE)
		end
	end
end

-- On player unequipped the item, Removes a weapon from the player and keep the ammo in the item.

ITEM.functions.toggle = { -- sorry, for name order.
	name = "Toggle",
	tip = "useTip",
	icon = "icon16/connect.png",
	OnRun = function(item)
		item:SetData("power", !item:GetData("power", false), player.GetAll(), false, true)
		item.player:EmitSound("buttons/button14.wav", 70, 150)

		return false
	end
}

ITEM.functions.use = {
	name = "Freq",
	tip = "useTip",
	icon = "icon16/wrench.png",
	OnRun = function(item)
		Default = "000.0"

		netstream.Start(item.player, "radioAdjust", item:GetData("freq", Default), item.id)

		return false
	end,
}
