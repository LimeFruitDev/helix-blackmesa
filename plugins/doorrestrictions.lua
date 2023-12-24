PLUGIN.name = "Door Restrictions"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Restricts certain door commands."

local PLUGIN = PLUGIN

function PLUGIN:InitializedPlugins()
	ix.command.Add("DoorSell", {
		description = "@cmdDoorSell",
		OnRun = function(self, client, arguments)
			-- Get the entity 96 units infront of the player.
			local data = {}
				data.start = client:GetShootPos()
				data.endpos = data.start + client:GetAimVector() * 96
				data.filter = client
			local trace = util.TraceLine(data)
			local entity = trace.Entity

			-- Check if the entity is a valid door.
			if (IsValid(entity) and entity:IsDoor() and !entity:GetNetVar("disabled")) then
				-- Validate whether the door does not belong to a dormitory
				if not entity:GetNetVar("ownable") then
					return "This door cannot be sold."
				end

				-- Check if the player owners the door.
				if (client == entity:GetDTEntity(0)) then
					entity = IsValid(entity.ixParent) and entity.ixParent or entity

					-- Get the price that the door is sold for.
					local price = math.Round(entity:GetNetVar("price", ix.config.Get("doorCost")) * ix.config.Get("doorSellRatio"))
					local character = client:GetCharacter()

					-- Remove old door information.
					entity:RemoveDoorAccessData()

					local doors = character:GetVar("doors") or {}

					for k, v in ipairs(doors) do
						if (v == entity) then
							table.remove(doors, k)
						end
					end

					character:SetVar("doors", doors, true)

					-- Take their money and notify them.
					character:GiveMoney(price)
					hook.Run("OnPlayerPurchaseDoor", client, entity, false, PLUGIN.CallOnDoorChildren)

					ix.log.Add(client, "selldoor")
					return "@dSold", ix.currency.Get(price)
				else
					-- Otherwise tell them they can not.
					return "@notOwner"
				end
			else
				-- Tell the player the door isn't valid.
				return "@dNotValid"
			end
		end
	})
end
