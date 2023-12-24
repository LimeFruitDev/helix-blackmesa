local PLUGIN = PLUGIN
ITEM.name = "Handcuffs"
ITEM.description = "They comprise two parts, linked together by a rigid bar. Each half has a rotating arm which engages with a ratchet."
ITEM.price = 25
ITEM.model = "models/katharsmodels/handcuffs/handcuffs-1.mdl"
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

			client:SetAction("detaining", PLUGIN.time)

			client:DoStaredAction(target, function()
				target:SetCuffAnim(true)
				target:SetRestricted(true)
				target:SetNetVar("tying")
				target:SetNetVar("cuffs", true)
				target:NotifyLocalized("fTiedUp")

				itemTable:Remove()
			end, PLUGIN.time, function()
				client:SetAction()

				target:SetAction()
				target:SetNetVar("tying")

				itemTable.bBeingUsed = false
			end)

			target:SetNetVar("tying", true)
			target:SetAction("being detained", PLUGIN.time)
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
