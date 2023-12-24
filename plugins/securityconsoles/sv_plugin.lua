--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

-- Adds a new radio log entry.
local validChatTypes = { "radio", "departments", "request", "emergency" }

function PLUGIN:PlayerMessageSend( speaker, chatType, text, anonymous, receivers, rawText )
	if table.HasValue(validChatTypes, chatType) then
		local schar = speaker:GetCharacter()
        local speakerInv = schar:GetInventory()
        local freq

        if (speakerInv) then
            for k, v in pairs(speakerInv:GetItems()) do
                if (freq) then
                    break
                end

                if (v.uniqueID == "radio" and v:GetData("power", false) == true) then
                    freq = v:GetData("freq", "000.0")

                    break
                end
			end
        end

		netstream.Start(player.GetAll(), "securityRadioLog", speaker, chatType, ix.date.GetFormatted("%H:%M:%S"), freq, text)
	end
end

-- Opens door triggered by the console.
netstream.Hook("securityLogDoorOpen", function(ply, door, doorName)
	if (IsValid(ply) and ply:IsPlayer()) then
		local access = false
		for k, v in pairs(ents.FindInSphere(ply:GetPos(), 100)) do
			if (v:GetClass() == "bmrp_securityconsoles_accesslog") then
				access = true
			end
		end

		if access then
			local found = false

			for _, door in ipairs(ents.FindByName(door .. "*")) do
				found = true
				door:Fire( "Open", "", 0 )
			end
			
			if found then
				ply:Notify("Door '" .. doorName .. "' opened.")
			else
				ply:Notify("Door '" .. doorName .. "' failed to open.")
			end
		else
			ply:Notify("You are not close enough to the console.")
		end
	end
end)

-- Adds a new security log.
ix.security.AddDoorLog = function( access, clearance, entName, activator )
    local log = { access = access, clearance = clearance, door = entName, name = activator, time = ix.date.GetFormatted("%H:%M:%S") }
    netstream.Start( player.GetAll(), "securityLog", log )
end

-- Saves the consoles.
function PLUGIN:SaveData()
	local data = {}

	for k, v in pairs(ents.FindByClass("bmrp_securityconsoles*")) do
		data[#data + 1] = {
			pos = v:GetPos(),
			model = v:GetModel(),
			angles = v:GetAngles(),
			class = v:GetClass()
		}
	end
	self:SetData(data)
end

-- Spawns the consoles.
function PLUGIN:LoadData()
	for k, v in pairs(ents.FindByClass("bmrp_securityconsoles*")) do
		v:Remove()
	end

	for k, v in pairs(self:GetData() or {}) do
		local entity = ents.Create(v.class)
		entity:SetPos(v.pos)
		entity:SetAngles(v.angles)
		entity:Spawn()
		entity:Activate()

		local phys = entity:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end
end
