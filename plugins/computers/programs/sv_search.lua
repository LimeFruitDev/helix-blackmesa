--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

PLUGIN.initialized_search = false
PLUGIN.characters = PLUGIN.characters or {}

hook.Add("PlayerInitialSpawn", "computerGetCharList", function()
    if PLUGIN.initialized_search then return end
    PLUGIN.initialized_search = false

    local query = mysql:Select("ix_characters")
    query:Select("id")
    query:Select("name")
    query:Select("faction")
    query:Where("schema", Schema.folder)
    query:Callback(function(results)
        if istable(results) and #results > 0 then
            PLUGIN.characters = results
        end
    end)
    query:Execute()
end)

hook.Add("OnCharacterCreated", "computerUpdateCharList", function(ply, character)
    PLUGIN.characters[#PLUGIN.characters + 1] = {id=character.id, name=character:GetName(), faction=character.vars.faction}
    netstream.Start(player.GetAll(), "computerUpdateCharList", PLUGIN.characters)
end)

hook.Add("OnCharacterDeleted", "computerUpdateCharList2", function(character)
    for k, v in pairs(PLUGIN.characters) do
        if v.id == character.id then
            PLUGIN.characters[k] = nil
            netstream.Start(player.GetAll(), "computerUpdateCharList", PLUGIN.characters)
            break
        end
    end
end)

netstream.Hook("computerGetCharList", function(ply)
    local computer = ply:GetComputer()
    if IsValid(computer) and computer:GetUser() == ply and ply:IsUsingComputer() then
        netstream.Start(ply, "computerGetCharList", PLUGIN.characters)
    end
end)
