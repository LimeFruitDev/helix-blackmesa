--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local path = "limefruit/bmrp/computers"
if not file.Exists(path, "DATA") then
	file.CreateDir(path)
end

netstream.Hook("computerScheduleAgendaItem", function(ply, title, text, time)
	if not ply:HasClearances("A") then return end

	local filePath = path .. "/agenda.txt"
	local tblAgendaItem = {char=ply:GetCharacter():GetID(), author=ply:GetName(), title=title, text=text, time=string.Replace(time, "T", " ")}

	if file.Exists(filePath, "DATA") then
		local tblAgenda = file.Read(filePath)
		tblAgenda = util.JSONToTable(tblAgenda)
		if istable(tblAgenda) then
			tblAgenda[#tblAgenda + 1] = tblAgendaItem
		else
			tblAgenda = {tblAgendaItem}
		end
		tblAgenda = util.TableToJSON(tblAgenda)
		file.Write(filePath, tblAgenda)
	else
		file.Write(filePath, util.TableToJSON({tblAgendaItem}))
	end

	netstream.Start(ply, "computerScheduleAgendaItem")
end)

netstream.Hook("computerGetAgenda", function(ply)
	local filePath = path .. "/agenda.txt"

	if file.Exists(filePath, "DATA") then
		local tblAgenda = file.Read(filePath)
		tblAgenda = util.JSONToTable(tblAgenda)
		netstream.Start(ply, "computerGetAgenda", istable(tblAgenda) and tblAgenda or {})
	end
end)

netstream.Hook("computerRemoveAgendaItem", function(ply, id)
	if not ply:HasClearances("A") then return end

	local filePath = path .. "/agenda.txt"

	if file.Exists(filePath, "DATA") then
		local tblAgenda = file.Read(filePath)
		tblAgenda = util.JSONToTable(tblAgenda)
		if istable(tblAgenda) and tblAgenda[id].char == ply:GetCharacter():GetID() then
			tblAgenda[id] = nil
			tblAgenda = util.TableToJSON(tblAgenda)
			file.Write(filePath, tblAgenda)
			netstream.Start(ply, "computerRemoveAgendaItem")
		end
	end
end)
