
local PLUGIN = PLUGIN

ITEM.name = "Notepad"
ITEM.fixdesc = "A notepad that has been written on."
ITEM.description = "A notepad that you can write on."
ITEM.price = 3
ITEM.model = Model("models/props_office/notepad_office.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.bAllowMultiCharacterInteraction = true

function ITEM:GetDescription()
	return self:GetData("owner", 0) == 0
		and self.description
		or self.fixdesc
end

function ITEM:SetText(text, character)
	text = tostring(text):sub(1, PLUGIN.maxLength)

	self:SetData("text", text, false, false, true)
	self:SetData("owner", character and character:GetID() or 0)
end

ITEM.functions.View = {
	OnRun = function(item)
		netstream.Start(item.player, "ixViewPaper", item:GetID(), item:GetData("text", ""), 0, 0)
		return false
	end,

	OnCanRun = function(item)
		local owner = item:GetData("owner", 0)

		return owner != 0
	end
}

ITEM.functions.Edit = {
	OnRun = function(item)
		netstream.Start(item.player, "ixViewPaper", item:GetID(), item:GetData("text", ""), 1, 0)
		return false
	end,

	OnCanRun = function(item)
		local owner = item:GetData("owner", 0)
		return owner == 0 or owner == item.player:GetCharacter():GetID()
	end
}

ITEM.functions.take.OnCanRun = function(item)
	local owner = item:GetData("owner", 0)

	return IsValid(item.entity) and (owner == 0 or owner == item.player:GetCharacter():GetID())
end
