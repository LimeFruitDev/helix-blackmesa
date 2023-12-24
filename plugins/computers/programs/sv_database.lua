--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local path = "limefruit/bmrp/computers/database"
if (!file.Exists(path, "DATA")) then
	file.CreateDir(path)
end

ix.computers.AddLog = function(target, name, event, time)
	local character = target:IsPlayer() and target:GetCharacter():GetID() or target
	local filePath = path .. "/" .. character .. "_logs.txt"
	local data = file.Exists(filePath, "DATA") and util.JSONToTable(file.Read(filePath)) or {}

	data[#data + 1] = {name=name, event=event, time=time}

	file.Write(filePath, util.TableToJSON(data))
end

netstream.Hook("computerGetLogs", function(client, char)
	if (!client:HasClearances("A")) then return end

	local filePath = path .. "/" .. char .. "_logs.txt"
	local data = file.Exists(filePath, "DATA") and util.JSONToTable(file.Read(filePath)) or {}

	if (#data < 1) then return end

	netstream.Start(client, "computerGetLogs", istable(data) and data or {})
end)

netstream.Hook("computerGetData", function(client, char)
	if (!client:HasClearances("A")) then return end

	for k, v in pairs(player.GetAll()) do
		local character = v:GetCharacter()
		if not IsValid(character) then continue end
		if character:GetID() == char then
			netstream.Start(client, "computerGetData", v:GetCharacter():GetData(), v)
			return
		end
	end

	local query = mysql:Select("ix_characters")
	query:Select("data")
	query:Where("schema", Schema.folder)
	query:Where("id", char)
	query:Callback(function(results)
		if istable(results) and #results > 0 then
			netstream.Start(client, "computerGetData", util.JSONToTable(results[1].data))
		end
	end)
	query:Execute()
end)

-- Access.
netstream.Hook("computerSetClearances", function(client, char, data, clearances)
	if (!client:HasClearances("A")) then return end

	local target = nil
	char = tonumber(char)

	for k, v in ix.util.GetCharacters() do
		if v:GetID() != char then continue end
		target = k
		break
	end

	local clearanceString = ""
	for clearance, gotClearance in pairs(clearances) do
		if gotClearance then
			clearanceString = clearanceString .. clearance
		end
	end

	if (IsValid(target)) then
		target:GetCharacter():SetData("clearances", clearanceString)
	else
		data.clearances = clearanceString

		local query = mysql:Update("ix_characters")
		query:Update("data", util.TableToJSON(data))
		query:Where("schema", Schema.folder)
		query:Where("id", char)
		query:Execute()
	end

	ix.computers.AddLog("Clearance Set", clearanceString, os.time())
end)

-- Licenses.
netstream.Hook("computerGetLicenses", function(client, char)
	if (!client:HasClearances("A")) then return end

	local filePath = path .. "/" .. char .. ".txt"
	local data = file.Exists(filePath, "DATA") and util.JSONToTable(file.Read(filePath)) or {}

	if (#data < 1) then return end

	netstream.Start(client, "computerGetLicenses", istable(data) and data or {})
end)

netstream.Hook("computerSetLicenses", function(client, char, tblLicenses)
	if (!client:HasClearances("A")) then return end
	file.Write(path .. "/" .. char .. ".txt", util.TableToJSON(tblLicenses))
end)

-- Journals.
local function getJournals(char)
	local filePath = path .. "/" .. char .. "_journal.txt"
	local data = file.Exists(filePath, "DATA") and util.JSONToTable(file.Read(filePath)) or {}

	return data
end

netstream.Hook("computerGetJournals", function(client, char)
	if (!client:HasClearances("A")) then return end
	local journals = getJournals(char)
	if (#journals < 1) then return end
	netstream.Start(client, "computerGetJournals", istable(journals) and journals or {})
end)

netstream.Hook("computerSetJournal", function(client, char, iJournal, text)
	local author = client:GetCharacter():GetID()

	if not client:HasClearances("A") then return end
	local journals = getJournals(char)
	if not journals[iJournal] or journals[iJournal].author != author then return end

	local filePath = path .. "/" .. char .. "_journal.txt"
	journals[iJournal] = {author=author, text=text, time=os.time()}
	file.Write(filePath, util.TableToJSON(journals))
end)

netstream.Hook("computerCreateJournal", function(client, char, text)
	if (!client:HasClearances("A")) then return end

	local journals = getJournals(char)
	local thisJournal = {author=client:GetCharacter():GetID(), text=text, time=os.time()}
	local filePath = path .. "/" .. char .. "_journal.txt"

	if istable(journals) then
		journals[#journals + 1] = thisJournal
	else
		journals = {thisJournal}
	end

	file.Write(filePath, util.TableToJSON(journals))
end)

netstream.Hook("computerRemoveJournal", function(client, char, iJournal)
	if (!client:HasClearances("A")) then return end
	local journals = getJournals(char)
	if not journals[iJournal] then return end

	local filePath = path .. "/" .. char .. "_journal.txt"
	journals[iJournal] = nil
	file.Write(filePath, util.TableToJSON(journals))
end)
