local PLUGIN = PLUGIN
ITEM.name = "Zip Tie"
ITEM.description = "An orange zip-tie used to restrict people."
ITEM.price = 8
ITEM.model = "models/items/crossbowrounds.mdl"
ITEM.functions.Use = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer() and target:GetCharacter()
		and !target:GetNetVar("tying") and !target:IsRestricted()) then
			local angDiff = math.AngleDifference(client:GetAngles().y, target:GetAngles().y)
			if not (angDiff > - 45 and angDiff < 45) then client:Notify("You must be facing the back of this player.") return false end

			itemTable.bBeingUsed = true

			client:SetAction("tying", PLUGIN.time)

			client:DoStaredAction(target, function()
				target:SetCuffAnim(true)
				target:SetRestricted(true)
				target:SetNetVar("tying")
				target:NotifyLocalized("fTiedUp")

				if (target:IsCombine()) then
					Schema:AddCombineDisplayMessage("@cLosingContact", Color(255, 255, 255, 255))
					Schema:AddCombineDisplayMessage("@cLostContact", Color(255, 0, 0, 255))
				end

				itemTable:Remove()
			end, PLUGIN.time, function()
				client:SetAction()

				target:SetAction()
				target:SetNetVar("tying")

				itemTable.bBeingUsed = false
			end)

			target:SetNetVar("tying", true)
			target:SetAction("being tied", PLUGIN.time)
		else
			itemTable.player:NotifyLocalized("plyNotValid")
		end

		return false
	end,
	OnCanRun = function(itemTable)
		return !IsValid(itemTable.entity) or itemTable.bBeingUsed
	end
}

function ITEM:CanTransfer(inventory, newInventory)
	return !self.bBeingUsed
end
