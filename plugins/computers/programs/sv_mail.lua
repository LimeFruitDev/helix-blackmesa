--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local path = "limefruit/bmrp/computers/mail"
if not file.Exists(path, "DATA") then
	file.CreateDir(path)
end

function PLUGIN:SendMail(plySpeaker, audienceChar, audienceName, audienceFaction, mailSubject, mailText)
	local speakerChar = plySpeaker:GetCharacter():GetID()

	local speakerFilePath = path .. "/" .. speakerChar .. ".txt"
	local audienceFilePath = path .. "/" .. audienceChar .. ".txt"

	local tblMail = {speakerChar=speakerChar, speakerName=plySpeaker:GetName(), audienceChar=audienceChar, audienceName=audienceName, audienceFaction=audienceFaction, mailSubject=mailSubject, mailText=mailText, mailTime=os.time()}

	if file.Exists(speakerFilePath, "DATA") then
		local speakerMail = file.Read(speakerFilePath)
		speakerMail = util.JSONToTable(speakerMail)
		if istable(speakerMail) then
			speakerMail[#speakerMail + 1] = tblMail
		else
			speakerMail = {tblMail}
		end
		speakerMail = util.TableToJSON(speakerMail)
		file.Write(speakerFilePath, speakerMail)
	else
		file.Write(speakerFilePath, util.TableToJSON({tblMail}))
	end

	if file.Exists(audienceFilePath, "DATA") then
		local audienceMail = file.Read(audienceFilePath)
		audienceMail = util.JSONToTable(audienceMail)
		if istable(audienceMail) then
			audienceMail[#audienceMail + 1] = tblMail
		else
			audienceMail = {tblMail}
		end
		audienceMail = util.TableToJSON(audienceMail)
		file.Write(audienceFilePath, audienceMail)
	else
		file.Write(audienceFilePath, util.TableToJSON({tblMail}))
	end
end

netstream.Hook("computerSendMail", function(plySpeaker, audienceChar, audienceName, audienceFaction, mailSubject, mailText)
	if plySpeaker.computerSendMailWait and CurTime() < plySpeaker.computerSendMailWait then return end
	plySpeaker.computerSendMailWait = CurTime() + 60

	PLUGIN:SendMail(plySpeaker, audienceChar, audienceName, audienceFaction, mailSubject, mailText)
end)

netstream.Hook("computerSendMultiMail", function(plySpeaker, tblLines, mailSubject, mailText)
	if #tblLines > 3 and not plySpeaker:HasClearances("A") then return end

	if plySpeaker.computerSendMailWait and CurTime() < plySpeaker.computerSendMailWait then return end
	plySpeaker.computerSendMailWait = CurTime() + 60

	for _, line in pairs(tblLines) do
		PLUGIN:SendMail(plySpeaker, line.char, line.name, line.faction, mailSubject, mailText)
	end
end)

netstream.Hook("computerSendFactionMail", function(plySpeaker, mailSubject, mailText)
	if not plySpeaker:HasClearances("A") then return end

	if plySpeaker.computerSendMailWait and CurTime() < plySpeaker.computerSendMailWait then return end
	plySpeaker.computerSendMailWait = CurTime() + 60

	local id = plySpeaker:GetCharacter():GetID()
	local faction = plySpeaker:GetCharacter().vars.faction
	for _, char in pairs(PLUGIN.characters) do
		if char.faction == faction and char.id ~= id then
			PLUGIN:SendMail(plySpeaker, char.id, char.name, char.faction, mailSubject, mailText)
		end
	end
end)

netstream.Hook("computerSendFacilityMail", function(plySpeaker, mailSubject, mailText)
	if not plySpeaker:HasClearances("A") then return end

	if plySpeaker.computerSendMailWait and CurTime() < plySpeaker.computerSendMailWait then return end
	plySpeaker.computerSendMailWait = CurTime() + 60

	local id = plySpeaker:GetCharacter():GetID()
	for _, char in pairs(PLUGIN.characters) do
		if char.id ~= id then
			PLUGIN:SendMail(plySpeaker, char.id, char.name, char.faction, mailSubject, mailText)
		end
	end
end)

netstream.Hook("computerRemoveMail", function(ply, id)
	local filePath = path .. "/" .. ply:GetCharacter():GetID() .. ".txt"
	if not file.Exists(filePath, "DATA") then return end

	local mail = file.Read(filePath)
	mail = util.JSONToTable(mail)
	mail[id] = nil
	mail = util.TableToJSON(mail)
	file.Write(filePath, mail)
end)

netstream.Hook("computerGetMail", function(ply)
	local filePath = path .. "/" .. ply:GetCharacter():GetID() .. ".txt"

	if file.Exists(filePath, "DATA") then
		local mail = file.Read(filePath)
		mail = util.JSONToTable(mail)
		netstream.Start(ply, "computerGetMail", istable(mail) and mail or {})
	end
end)
