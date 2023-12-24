
ITEM.name = "Cigarette"
ITEM.description = "A cigarette base based on the PAC base."
ITEM.category = "Outfit"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.outfitCategory = "hat"
ITEM.pacData = {}

--[[
ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Angles"] = Angle(12.919322967529, 6.5696062847564e-006, -1.0949343050015e-005),
					["Position"] = Vector(-2.099609375, 0.019973754882813, 1.0180969238281),
					["UniqueID"] = "4249811628",
					["Size"] = 1.25,
					["Bone"] = "eyes",
					["Model"] = "models/Gibs/HGIBS.mdl",
					["ClassName"] = "model",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["UniqueID"] = "907159817",
			["EditorExpand"] = true,
		},
	},
}

-- This will change a player's skin after changing the model. Keep in mind it starts at 0.
ITEM.newSkin = 1
-- This will change a certain part of the model.
ITEM.replacements = {"group01", "group02"}
-- This will change the player's model completely.
ITEM.replacements = "models/manhack.mdl"
-- This will have multiple replacements.
ITEM.replacements = {
	{"male", "female"},
	{"group01", "group02"}
}

-- This will apply body groups.
ITEM.bodyGroups = {
	["blade"] = 1,
	["bladeblur"] = 1
}

--]]

-- Inventory drawing
if (CLIENT) then
	-- Draw camo if it is available.
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("smoking")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

function ITEM:RemovePart(client)
	local char = client:GetCharacter()

	self:SetData("smoking", false)
	client:RemovePart(self.uniqueID)

	if (self.attribBoosts) then
		for k, _ in pairs(self.attribBoosts) do
			char:RemoveBoost(self.uniqueID, k)
		end
	end

	self:OnUnequipped()
end

-- On item is dropped, Remove a weapon from the player and keep the ammo in the item.
ITEM:Hook("drop", function(item)
	if (item:GetData("smoking")) then
		item:RemovePart(item.player)
	end
end)

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.stubOut = { -- sorry, for name order.
	name = "Stub out",
	tip = "stubOut",
	icon = "icon16/cancel.png",
	OnRun = function(item)
		item:RemovePart(item.player)

		return true
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("smoking") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

-- On player eqipped the item, Gives a weapon to player and load the ammo data from the item.
ITEM.functions.Smoke = {
	name = "Smoke",
	tip = "smokeTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		local char = item.player:GetCharacter()
		local items = char:GetInventory():GetItems()

		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if (itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:GetData("smoking")) then
					item.player:Notify("You're smoking right now!")
					return false
				end
			end
		end

		item:SetData("smoking", true)
		item.player:AddPart(item.uniqueID, item)

		if (item.attribBoosts) then
			for k, v in pairs(item.attribBoosts) do
				char:AddBoost(item.uniqueID, k, v)
			end
		end

		item.player:EmitSound("limefruit/bmrp/items/lighter.mp3")
		timer.Create( "SmokeTime2r", 300, 1, function() item:EndSmoke() end )
		return false
	end,
	OnCanRun = function(item)
		local client = item.player
		local inventory = client:GetCharacter():GetInventory()

		if inventory:HasItem("lighter") then
			return !IsValid(item.entity) and IsValid(client) and item:GetData("smoking") != true and hook.Run("CanPlayerEquipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
		end

		client:Notify("You don't own a lighter!")

		return false
	end
}

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory and self:GetData("equip")) then
		return false
	end

	return true
end

function ITEM:OnRemoved()
	local inventory = ix.item.inventories[self.invID]
	local owner = inventory.GetOwner and inventory:GetOwner()

	if (IsValid(owner) and owner:IsPlayer()) then
		if (self:GetData("smoking")) then
			self:RemovePart(owner)
		end
	end
end

function ITEM:OnEquipped()

end

function ITEM:EndSmoke()
	self:Remove()
	self:RemovePart(item.player)
end

function ITEM:OnUnequipped()
end
