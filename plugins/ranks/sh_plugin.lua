--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN
PLUGIN.name = "Ranks"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Manage ranks with classes."

ix.util.Include("sv_plugin.lua")

if CLIENT then
    function PLUGIN:PopulateCharacterInfo(client, character, container)
        local color = team.GetColor(client:Team())
        color = Color(color.r, color.g, color.b, 50)
        container:SetArrowColor(color)

        local rank = container:AddRowAfter("name", "rank")
        rank:SetText(character:GetClass() and ix.class.list[character:GetClass()].name or ix.faction.indices[character:GetFaction()].name)
        rank:SetBackgroundColor(color)
        rank:SizeToContents()
    end
end

local function updateClass(client, target, promote)
	local curClass = ix.class.list[target:GetClass()]
	if not curClass then return ix.util.Notify("Target is not in any class", client) end

    if not client:IsStaff() then
        local clientChar = client:GetCharacter()
        local clientClass = ix.class.list[clientChar:GetClass()]

        if target:GetFaction() != clientChar:GetFaction() then return ix.util.Notify("You cannot target this player.", client) end
        if curClass.rankOrder >= clientClass.rankOrder then return ix.util.Notify("You cannot target this player.", client) end
        if promote and (curClass.rankOrder + 1) >= clientClass.rankOrder then return ix.util.Notify("You cannot target this player.", client) end
    end

	local nextClass = ix.class.list[PLUGIN.ranks[curClass.faction][promote and curClass.rankOrder + 1 or curClass.rankOrder - 1]]
    if not nextClass then return ix.util.Notify("Target cannot be " .. (promote and "promoted" or "demoted") .. " any further", client) end

	target:SetClass(nextClass.index)
	target:SetData("class", nextClass.name)

    ix.util.Notify(string.format("%s has " .. (promote and "promoted" or "demoted") .. " '%s' to %s", client:GetName(), target:GetName(), nextClass.name))

    ix.computers.AddLog(target:GetPlayer(), promote and "Promote" or "Demote", nextClass.name, os.time())
end

ix.command.Add("CharPromote", {
    description = "Promotes a character.",
    privilege = "Helix - Manage Ranks",
    arguments = {
        ix.type.character
    },
    OnRun = function(self, client, target)
        updateClass(client, target, true)
    end,
	OnCheckAccess = function(self, client)
		return client:IsStaff() or client:HasClearances("A") or false
	end
})

ix.command.Add("CharDemote", {
    description = "Demotes a character.",
    privilege = "Helix - Manage Ranks",
    arguments = {
        ix.type.character
    },
    OnRun = function(self, client, target)
		updateClass(client, target, false)
    end,
	OnCheckAccess = function(self, client)
		return client:IsStaff() or client:HasClearances("A") or false
	end
})
