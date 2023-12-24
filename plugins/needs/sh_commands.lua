
local PLUGIN = PLUGIN

ix.command.Add("CharSetNeeds", {
	description = "Set a player's Hunger and Thirst level (default: 0).",
	adminOnly = true,
	arguments = {
        ix.type.character,
        bit.bor(ix.type.number, ix.type.optional)
    },
    OnRun = function(self, client, target, level)
    	if (target) then
			local amount = level
			if (!amount) then
				amount = 0
			else
				amount = math.Clamp(tonumber(amount), 0, 100)
			end

			target:SetData("hunger", amount)
			target:SetData("thirst", amount)

			if (client != target:GetPlayer())	then
				target:GetPlayer():Notify(client:Name().." has set your needs to "..amount..".")
				client:Notify("You have set "..target:Name().."'s needs to "..amount..".")
			else
				client:Notify("You have set your own needs to "..amount..".")
			end
		else
			client:Notify(target.." is not a valid player!")
		end
	end
})

ix.command.Add("CharSetThirst", {
	description = "Set a player's Thirst level (default: 0).",
	adminOnly = true,
	arguments = {
        ix.type.character,
        bit.bor(ix.type.number, ix.type.optional)
    },
    OnRun = function(self, client, target, level)
    	if (target) then
			local amount = level
			if (!amount) then
				amount = 0
			else
				amount = math.Clamp(tonumber(amount), 0, 100)
			end

			target:SetData("thirst", amount)

			if (client != target:GetPlayer())	then
				target:GetPlayer():Notify(client:Name().." has set your thirst to "..amount..".")
				client:Notify("You have set "..target:Name().."'s thirst to "..amount..".")
			else
				client:Notify("You have set your own thirst to "..amount..".")
			end
		else
			client:Notify(target.." is not a valid player!")
		end
	end
})

ix.command.Add("CharSetHunger", {
	description = "Set a player's Hunger level (default: 0).",
	adminOnly = true,
	arguments = {
        ix.type.character,
        bit.bor(ix.type.number, ix.type.optional)
    },
    OnRun = function(self, client, target, level)
    	if (target) then
			local amount = level
			if (!amount) then
				amount = 0
			else
				amount = math.Clamp(tonumber(amount), 0, 100)
			end

			target:SetData("hunger", amount)

			if (client != target:GetPlayer())	then
				target:GetPlayer():Notify(client:Name().." has set your hunger to "..amount..".")
				client:Notify("You have set "..target:Name().."'s hunger to "..amount..".")
			else
				client:Notify("You have set your own hunger to "..amount..".")
			end
		else
			client:Notify(target.." is not a valid player!")
		end
	end
})
