--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

PLUGIN.name = "Tying"
PLUGIN.description = "Adds ties and cuffs."
PLUGIN.author = "Zoephix"

ix.util.Include("sv_plugin.lua")

PLUGIN.time = 1

-- remove ties and cuffs
if CLIENT then
    netstream.Hook("spawnPlayerCuffs", function(targetPly, state)
        if IsValid(targetPly.cuffs) then
            targetPly.cuffs:Remove()
        end

        if state then
            local bone = targetPly:LookupBone("ValveBiped.Bip01_L_Hand")
            targetPly.cuffs = ClientsideModel("models/katharsmodels/handcuffs/handcuffs-1.mdl")
            if bone then
                targetPly.cuffs:FollowBone(targetPly, bone)
            else
                targetPly.cuffs:SetParent(targetPly)
            end
            targetPly.cuffs:SetPos(targetPly:GetPos() + Vector(2.5, -3, 2.5))
            targetPly.cuffs:SetAngles(Angle(45, 0, 45))
            targetPly.cuffs:Spawn()
        end
    end)

    function PLUGIN:PlayerDisconnected(ply)
        if IsValid(ply.cuffs) then
            ply.cuffs:Remove()
        end
    end
end

function PLUGIN:PlayerUse(client, entity)
	if (!client:IsRestricted() and entity:IsPlayer() and entity:IsRestricted() and !entity:GetNetVar("untying")) then
        local cuffs = entity:GetNetVar("cuffs")

        entity:SetAction(cuffs and "being undetained" or "being untied", self.time)
		entity:SetNetVar("untying", true)

		client:SetAction(cuffs and "undetaining" or "untying", self.time)

		client:DoStaredAction(entity, function()
            entity:SetCuffAnim(false)
			entity:SetRestricted(false)
			entity:SetNetVar("untying")

            -- only give back cuffs to security, otherwise assume they got broken
            if cuffs and client:GetCharacter():GetFaction() == FACTION_SECURITY then
                client:GetCharacter():GetInventory():Add("handcuffs")
            end
		end, self.time, function()
			if (IsValid(entity)) then
				entity:SetNetVar("untying")
				entity:SetAction()
			end

			if (IsValid(client)) then
				client:SetAction()
			end
		end)
	end
end

-- searching
local function SearchPlayer(client, target)
	if (!target:GetCharacter() or !target:GetCharacter():GetInventory()) then
		return false
	end

	local name = hook.Run("GetDisplayedName", target) or target:Name()
	local inventory = target:GetCharacter():GetInventory()

	ix.storage.Open(client, inventory, {
		entity = target,
		name = name
	})

	return true
end

local COMMAND = {}

function COMMAND:OnRun(client, arguments)
    local data = {}
        data.start = client:GetShootPos()
        data.endpos = data.start + client:GetAimVector() * 96
        data.filter = client
    local target = util.TraceLine(data).Entity

    if (IsValid(target) and target:IsPlayer() and target:IsRestricted()) then
        if (!client:IsRestricted()) then
            SearchPlayer(client, target)
        else
            return "@notNow"
        end
    end
end

ix.command.Add("CharSearch", COMMAND)
