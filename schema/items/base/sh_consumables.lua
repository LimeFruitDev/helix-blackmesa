ITEM.name = "consumable"
ITEM.description = "A Consumable Item."
ITEM.category = "Consumables"
ITEM.model = "models/props_junk/watermelon01.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.Consume = {
	name = "Consume",
	tip = "consumeTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		if item.hunger > 0 then
			item.player:EmitSound("foodmod/eating.wav")
		elseif item.thirst > 0 then
			item.player:EmitSound("foodmod/slurp.wav")
		end

		if SERVER then
			local character = item.player:GetCharacter()

			local newHunger = character:GetData("hunger", 0) - item.hunger
			local newThirst = character:GetData("thirst", 0) - item.thirst

			newHunger = newHunger > 0 and newHunger or 0
			newThirst = newThirst > 0 and newThirst or 0

			character:SetData("hunger", newHunger)
			character:SetData("thirst", newThirst)
		end

		return true
	end
}
