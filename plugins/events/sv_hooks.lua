
local PLUGIN = PLUGIN

-- Called when all plugins are initialized
-- @realm server
function PLUGIN:InitializedPlugins()
	timer.Remove("ixRandomEvent")
	timer.Create("ixRandomEvent", 180, 0, function()
		if (#team.GetPlayers(FACTION_MAINTENANCE) == 0) then
			return
		end

		if (math.random(1, 50) == 25) then
			local event = math.random(1, 2)

			if event == 1 then
				ix.event.Run("ReceptionLights")
			elseif event == 2 then
				ix.event.Run("CommsFailed")
			end
		end
	end)
end

-- Called whenever a player pressed a key included within the IN keys
-- @realm server
function PLUGIN:KeyPress(client, key)
	if (key != IN_USE) then return end
	local entity = client:GetEyeTrace().Entity
	if (!IsValid(entity)) then return end
	local character = client:GetCharacter()
	if (!character) then return end

	if (character:GetFaction() == FACTION_MAINTENANCE) then
		if (entity:GetClass() == "prop_dynamic" or entity:GetClass() == "func_button") then
			local entName = entity:GetName()

			if (entity:GetPos() == Vector(-72.000000, 1104.000000, 6792.000000)) then
				SetGlobalBool("comFailed", false)
			elseif (entName == "lights_reception_fix") then
				ix.event.FireMapEntity("light_reception_trigger_stop", "Trigger", "", 0)
			end
		end
	end
end
