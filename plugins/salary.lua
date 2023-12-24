--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

PLUGIN.name = "Salary"
PLUGIN.description = "Adds custom salary."
PLUGIN.author = "Zoephix"

ix.config.Add("salaryPercentage", 100, "The percentage amount of salary to pay out.", nil, {
	data = {min = 0, max = 200},
	category = "characters"
})

ix.config.Add("salaryTimer", 300, "Interval between payouts.", nil, {
	data = {min = 60, max = 3600},
	category = "characters"
})

function PLUGIN:GetSalaryAmount(ply, faction)
    local character = ply:GetCharacter()
    local class = character:GetClass()

	local pay = class and ix.class.list[class].pay or faction.pay and faction.pay or 0

    return pay > 0 and pay/100*ix.config.Get("salaryPercentage", 100) or 0
end

local function createSalaryTimer(client, character, lastChar)
	local faction = ix.faction.indices[character:GetFaction()]
	local uniqueID = "ixCustomSalary" .. client:UniqueID()

	local pay = hook.Run("GetSalaryAmount", client, faction) or 0

	if (pay > 0) then
		timer.Create(uniqueID, ix.config.Get("salaryTimer", 300), 0, function()
			if (IsValid(client)) then
				if (hook.Run("CanPlayerEarnSalary", client, faction) != false) then
					character:GiveMoney(pay)
					client:NotifyLocalized("salary", ix.currency.Get(pay))
				end
			else
				timer.Remove(uniqueID)
			end
		end)
	elseif (timer.Exists(uniqueID)) then
		timer.Remove(uniqueID)
	end
end

function PLUGIN:PlayerLoadedCharacter(client, character, lastChar)
	timer.Simple(2.5, function()
		createSalaryTimer(client, character, lastChar)
	end)
end
