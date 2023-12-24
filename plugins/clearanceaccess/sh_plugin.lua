--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

PLUGIN.name = "Clearance Access"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Overrides default door/button settings such as open on touch and makes retinal scanners, readers for it to check the clearance level."

-- Include other plugin files
ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")

-- Configurations
PLUGIN.ReaderModel = PLUGIN.ReaderModel or "models/pg_props/pg_obj/pg_keycard_reader.mdl"
PLUGIN.KeypadModel = PLUGIN.KeypadModel or "models/props_lab/keypad.mdl"

local playerMeta = FindMetaTable("Player")

-- Returns if the player is checked in
function playerMeta:OnDuty()
	return self:GetNWBool("OnDuty")
end

-- Returns the player clearances
function playerMeta:GetClearances()
	return self:GetCharacter():GetData("clearances")
end

-- Returns if the player has the specified clearances
function playerMeta:HasClearances( clearances )
	clearances = tostring(clearances)
	local playerClearances = self:GetCharacter():GetData("clearances", nil)

	-- Make sure the player got any clearances
	if (!playerClearances or string.len(playerClearances) < 1) then
		return false
	end

	-- Extract numbers from string
	local intLevels = ""
	string.gsub(playerClearances,"%d+",function(e)
		intLevels = intLevels .. e
	end)

	-- Get highest clearance
	local curLevel = 0
	for i = 1, #intLevels do
		local clearance = tonumber(string.sub(intLevels, i, i))
		if (clearance > curLevel) then
			curLevel = clearance
		end
	end

	-- Validate clearances
	local validClearances = {}

	for i = 1, #clearances do
		local clearance = string.sub(clearances, i, i)
		local intLevel = tonumber(clearance)

		if (string.find(playerClearances, clearance) or intLevel and intLevel <= curLevel) then
			validClearances[#validClearances + 1] = clearance
		end
	end

	if (#validClearances == #clearances) then
		return true
	end

	return false
end

-- Command to set someones clearances
ix.command.Add("ClearanceSet", {
	description = "@cmdClearanceSet",
	adminOnly = true,
	arguments = {
		ix.type.player,
		ix.type.string
	},
	OnRun = function(self, client, target, clearance)
		target:GetCharacter():SetData("clearances", clearance)
		client:Notify("Clearances updated!")
		ix.computers.AddLog(target, "Clearance Set", clearance, os.time())
	end
})

-- Command to give someone clearances
ix.command.Add("ClearanceGive", {
	description = "@cmdClearanceGive",
	adminOnly = true,
	arguments = {
		ix.type.player,
		ix.type.string
	},
	OnRun = function(self, client, target, clearances)
		local character = target:GetCharacter()

		-- Give the clearances to the player
		for i = 1, #clearances do
			local clearance = string.sub(clearances, i, i);

			if (character:GetData("clearances") and !string.find(character:GetData("clearances"), clearance)) then
				character:SetData("clearances", character:GetData("clearances") .. clearance)
			elseif !character:GetData("clearances") then
				character:SetData("clearances", clearance)
			end
		end

		client:Notify("Added" .. " \"" .. clearances .. "\" " .. "clearance(s) for " .. target:GetName())

		ix.computers.AddLog(target, "Clearance Give", clearances, os.time())
	end
})

-- Command to take someones clearances
ix.command.Add("ClearanceTake", {
	description = "@cmdClearanceTake",
	adminOnly = true,
	arguments = {
		ix.type.player,
		ix.type.string
	},
	OnRun = function(self, client, target, clearances)
		local char = target:GetCharacter()
		local curClearances = char:GetData("clearances")

		-- Take the clearances from the player
		for i = 1, #clearances do
			local clearance = string.sub(clearances, i, i)

			if string.find(curClearances, clearance) then
				local newLevels = string.gsub(curClearances, clearance, "")

				char:SetData("clearances", newLevels)
			end
		end
		
		client:Notify("Taken" .. " \"" .. clearances .. "\" " .. "clearance(s) from " .. target:GetName())

		ix.computers.AddLog(target, "Clearance Take", clearances, os.time())
	end
})
