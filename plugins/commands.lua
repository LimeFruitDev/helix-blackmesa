--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

PLUGIN.name = "Custom Commands"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Custom commands we felt the schema or framework was missing."

if (CLIENT) then
	concommand.Add("ix_toggleclassicthirdperson", function()
		local bEnabled = !ix.option.Get("thirdpersonClassic", false)
		ix.option.Set("thirdpersonClassic", bEnabled)
	end)
end

-- Show ID
ix.command.Add("ShowID", {
	OnRun = function(self, client)
		local item
		
		client.found = false
		for k, v in pairs( client:GetCharacter():GetInv():GetItems() ) do
			if ( v.uniqueID == "keycard" ) then
				client.found = true
				item = v
			end
		end
		
		if not client.found then
			client:Notify( "You must have a keycard to show your identification." )
			return
		end
		
		local job = ix.class.list[client:GetCharacter():GetClass()].name
		if not client:GetCharacter():GetClass() then
			job = team.GetName(character:GetFaction())
		end
		
		local clearances = client:GetCharacter():GetData("clearances")
		if not clearances then
			clearances = "0"
		end
		
		local final = " | " .. job .. " | Levels: " .. clearances
		local target = client:GetEyeTrace().Entity
		
		if not IsValid(target) then
			client:Notify("You must face a player!")
		else
			ix.chat.Send(client, "showid", final, false, {client, target})
			client:ConCommand("say /me shows their ID.")
		end
	end
})

ix.chat.Register("ShowID", {
	format = "[ID CARD] %s %s",
	color = Color(255, 93, 0),
	filter = "showid",
	deadCanChat = true
})

-- Speakers
ix.chat.Register("Speakers", {
	prefix = {"/s", "/Speakers"},
	CanSay = function(self, speaker, text)
        if not (speaker:IsStaff() or speaker:HasClearances("A")) then
            speaker:Notify("Only Administration can use the speakers!")
            return false
        end
    end,
	OnChatAdd = function(self, speaker, text)
		chat.AddText(Color(220, 0, 255), "Speakers: <:: \"" .. text .. "\" ::>")
	end
})

-- Allows players to communicate via the pager
ix.command.Add("Page", {
	description = "@cmdPM",
	arguments = {
		ix.type.player,
		ix.type.text
	},
	CanSay = function(self, speaker, text)
		if GetGlobalBool("ComFailed") then
			speaker:ChatPrint("[PAGER] Error: Server connection lost.")
			return false
		end
	end,
	OnRun = function(self, client, target, text)
		if ((client.ixNextPM or 0) < CurTime()) then
			ix.chat.Send(client, "page", text, false, {client, target})
			
			client.ixNextPM = CurTime() + 0.5
			target.ixLastPM = client
			
			target:EmitSound("HL1/fvox/beep.wav", 70, 100)
		end
	end
})

ix.chat.Register("page", {
	format = "[PAGER] %s: %s",
	color = Color(64, 127, 250),
	filter = "page",
	deadCanChat = false
})

-- Alarms
ix.command.Add("Alarms", {
	description = "Trigger facility alarms.",
	OnCheckAccess = function(self, client)
		return client:IsStaff() or client:HasClearances("A")
	end,
	OnRun = function(self, client)
		SetGlobalBool("alarm", !GetGlobalBool("alarm"), false)
		ents.FindByName("alarm_toggle")[1]:Fire("Trigger", "", 0)
		ents.FindByName("rotate_alarm")[1]:Fire(GetGlobalBool("alarm", false) and "FireUser1" or "FireUser2", "", 0.1)
		client:Notify("You have triggered the alarms.")
	end
})

-- Fire Alarms
ix.command.Add("FireAlarms", {
	description = "Trigger fire alarms.",
	OnCheckAccess = function(self, client)
		return client:IsStaff() or client:HasClearances("A") or false
	end,
	OnRun = function(self, client)
		SetGlobalBool("fireAlarm", !GetGlobalBool("fireAlarm", false))
		local alarmActive = GetGlobalBool("fireAlarm")

		ents.FindByName("firealarm_toggle")[1]:Fire(alarmActive and "FireUser1" or "FireUser2", "", 0)

		for _, alarm in pairs(ents.FindByName("firealarm_indicator_default")) do
			if (alarmActive) then
				alarm:EmitSound("bms_objects/alarms/alarm5.wav")
			else
				alarm:StopSound("bms_objects/alarms/alarm5.wav")
			end
		end

		client:Notify("You have triggered the alarms.")
	end
})

-- Medical Containment
ix.command.Add("MedContainment", {
	description = "Toggle medical containment.",
	OnCheckAccess = function(self, client)
		return client:IsStaff() or client:HasClearances("A")
	end,
	OnRun = function(self, client)
		ents.FindByName("clinical_containment_toggle")[1]:Fire("Trigger", "", 0)
		client:Notify("You have toggled the medical containment.")
	end
})

-- Fire Doors
local firedoors = {[1] = "frdr_lvl1", [2] = "frdr_lvl2", [3] = "frdr_lvl3"}

ix.command.Add("FireDoor", {
	description = "Trigger a fire door.",
	arguments = {
		ix.type.string
	},
	OnCheckAccess = function(self, client)
		return client:IsStaff() or client:HasClearances("A") or false
	end,
	OnRun = function(self, client, doorNumber)
		if doorNumber == "all" then
			for k,v in pairs(ents.FindByName("frdr_*")) do
				v:Fire("toggle", "", 0)
			end
		elseif not tonumber(doorNumber) or tonumber(doorNumber) > 3 then
			client:Notify("Arguments required number door 1 - 3 or all.")
		else
			ents.FindByName(firedoors[tonumber(doorNumber)])[1]:Fire("toggle", "", 0)
		end
	end
})

-- Manage Portal Stages
ix.command.Add("PortalStage", {
	staffOnly = true,
	description = "Trigger a portal stage.",
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, stage)
        if stage == "stop" then
            ents.FindByName("portal_stop")[1]:Fire("Trigger", "", 0)
        else
            ents.FindByName("portal_stage" .. stage)[1]:Fire("Trigger", "", 0)
		end
	end
})

-- Remove Item
ix.command.Add("RemoveItem", {
	adminOnly = true,
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, itemName)
		local inv = client:GetCharacter():GetInv()
		
		if (inv) then
			local itemRemoved = false
			
			for _, item in pairs(inv:GetItems(true)) do
				if (not itemRemoved and string.find(string.lower(item.name), string.lower(itemName))) then
					item:remove()
					itemRemoved = true
					
					client:Notify("Removed " .. item.name .. " from your inventory.")
				end
			end
		end
	end
})

-- Force Save Data
ix.command.Add("ForceSave", {
	superAdminOnly = true,
	OnRun = function(self, client)
		if SERVER then
			hook.Run("SaveData")
			
			for k, v in ipairs(player.GetAll()) do
				if v:GetCharacter() then
					v:GetCharacter():Save()
				end
			end
			
			client:Notify("You've force-saved all data and plugins.")
			ix.log.AddRaw(client:Name().." ("..client:SteamName()..") has force-saved all data and plugins.", true, FLAG_WARNING)
		end
	end
})

-- Searching for handcuffed characters
ix.command.Add("Search", {
	description = "Search People who are restrained.",
	OnRun = function(self, client, target)
		local data = {}
		data.start = client:GetShootPos()
		data.endpos = data.start + client:GetAimVector() * 96
		data.filter = client
		
		local target = util.TraceLine(data).Entity
		
		if (IsValid(target) and target:IsPlayer() and target:IsRestricted() and client:Team() == FACTION_SECURITY) then
			if (!client:IsRestricted()) then
				Schema:SearchPlayer(client, target)
			else
				return "You cannot do this right now!"
			end
		end
	end
})

-- Door kicking
ix.command.Add("DoorKick", {
	description = "Kick a door open.",
	OnRun = function(self, client)
		if (client:Team() == FACTION_SECURITY) then
            local aimVector = client:GetAimVector()
			
            local data = {}
                data.start = client:GetShootPos()
                data.endpos = data.start + aimVector*96
                data.filter = client
            local entity = util.TraceLine(data).Entity
			
            if (IsValid(entity) and entity:GetClass() == "prop_door_rotating") then
                if (client:ForceSequence("doorBracer_BustThru")) then
                    timer.Simple(0.75, function()
                        if (IsValid(client) and IsValid(entity)) then
                            entity:EmitSound("physics/wood/wood_crate_break"..math.random(1, 5)..".wav", 150)
                            entity:BlastDoor(aimVector * (360 + client:GetCharacter():GetAttribute("str", 0)*5))
                        end
                    end)
                end
            else
                return "@dNotValid"
            end
        else
            return "@mustBeSecurity"
        end
	end
})

-- Plays a sound from the P.A announcement locations
local announcerSoundLocations = ix.plugin.list["announcer"].SoundLocations

ix.command.Add("PASound", {
	staffOnly = true,
	description = "Plays a sound from the P.A announcement locations.",
	arguments = bit.bor(ix.type.text),
	OnRun = function(self, client, text)
		for _, location in pairs(announcerSoundLocations) do
			sound.Play(text, location, 100, 100, 1)
		end
		
		client:Notify("You have played a sound!")
	end
})

-- VOX sounds
local sl = string.lower

ix.command.Add("VOXSound", {
	staffOnly = true,
	description = "Plays text-to-speech VOX from the P.A announcement locations.",
	arguments = bit.bor(ix.type.text),
	OnRun = function(self, client, text)
		local time = 0
		for k, v in ipairs(string.Explode(" ", text)) do
			v = sl(v)

			local sndDir = "vox_overhead_voicelines/" .. v .. ".wav"

			if (k != 1) then
				time = time + SoundDuration(sndDir) + .1
			end

			timer.Simple(time, function()
				for _, location in pairs(announcerSoundLocations) do
					sound.Play(sndDir, location, 100, 100, 1)
				end
			end)
		end

		client:Notify("You have played a sound!")
	end
})

-- Forums
ix.command.Add("Forums", {
	OnRun = function(self, client)
		client:SendLua([[gui.OpenURL("https://forums.limefruit.net")]])
	end
})

-- Discord
ix.command.Add("Discord", {
	OnRun = function(self, client)
		client:SendLua([[gui.OpenURL("https://discord.gg/DKfDfut4wm")]])
	end
})

-- Content
ix.command.Add("Content", {
	OnRun = function(self, client)
		client:SendLua([[gui.OpenURL("https://steamcommunity.com/workshop/filedetails/?id=2876769554")]])
	end
})

-- Dev Commands
concommand.Add("dev_GetEntPos", function( ply, command, arguments )
	if (ply:IsSuperAdmin()) then
		print(LocalPlayer():GetEyeTrace().Entity:GetPos().x, LocalPlayer():GetEyeTrace().Entity:GetPos().y, LocalPlayer():GetEyeTrace().Entity:GetPos().z)
	end
end)

concommand.Add("dev_GetEntAngles", function( ply, command, arguments )
	if (ply:IsSuperAdmin()) then
		print(math.ceil(LocalPlayer():GetEyeTrace().Entity:GetAngles().x) .. ", " .. math.ceil(LocalPlayer():GetEyeTrace().Entity:GetAngles().y) .. ", " .. math.ceil(LocalPlayer():GetEyeTrace().Entity:GetAngles().z ))
	end
end)

concommand.Add("dev_GetRoundEntPos", function( ply, command, arguments )
	if (ply:IsSuperAdmin()) then
		print(math.ceil(LocalPlayer():GetEyeTrace().Entity:GetPos().x) .. ", " .. math.ceil(LocalPlayer():GetEyeTrace().Entity:GetPos().y) .. ", " .. math.ceil(LocalPlayer():GetEyeTrace().Entity:GetPos().z))
	end
end)

concommand.Add("dev_GetPos", function( ply, command, arguments )
	if (ply:IsSuperAdmin()) then
		print(math.ceil(LocalPlayer():GetPos().x) .. ", " .. math.ceil(LocalPlayer():GetPos().y) .. ", " .. math.ceil(LocalPlayer():GetPos().z))
	end
end)

concommand.Add("dev_GetCameraOrigin", function( ply, command, arguments )
	if (ply:IsSuperAdmin()) then
		print("origin = (" .. math.ceil(LocalPlayer():GetPos().x) .. ", " .. math.ceil(LocalPlayer():GetPos().y) .. ", " .. math.ceil(LocalPlayer():GetPos().z) .. ")")
		print("angles = (" .. math.ceil(LocalPlayer():GetAngles().x) .. ", " .. math.ceil(LocalPlayer():GetAngles().y) .. ", " .. math.ceil(LocalPlayer():GetAngles().z) .. ")")
	end
end)
