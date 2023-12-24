--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local path = "limefruit/bmrp/computers/notepad"
if not file.Exists(path, "DATA") then
	file.CreateDir(path)
end

netstream.Hook("computerGetNotes", function(ply)
    local filePath = path .. "/" .. ply:GetCharacter():GetID() .. ".txt"

    if file.Exists(filePath, "DATA") then
        local tblNotes = file.Read(filePath)
        tblNotes = util.JSONToTable(tblNotes)
        netstream.Start(ply, "computerGetNotes", tblNotes)
    end
end)

netstream.Hook("computerCreateNewNote", function(ply, subject, text)
    if ply.computerCreateNewNoteWait and CurTime() < ply.computerCreateNewNoteWait then return end
    ply.computerCreateNewNoteWait = CurTime() + 60

    local tblNote = {subject=subject, text=text, time=os.time()}
    local filePath = path .. "/" .. ply:GetCharacter():GetID() .. ".txt"

    if file.Exists(filePath, "DATA") then
        local notes = file.Read(filePath)
        notes = util.JSONToTable(notes)
        if istable(notes) then
            notes[#notes + 1] = tblNote
        else
            notes = {tblNote}
        end
        notes = util.TableToJSON(notes)
        file.Write(filePath, notes)
    else
        file.Write(filePath, util.TableToJSON({tblNote}))
    end
end)

netstream.Hook("computerSaveNote", function(ply, id, subject, text, curTime)
    if ply.computerCreateNewNoteWait and CurTime() < ply.computerCreateNewNoteWait then return end
    ply.computerCreateNewNoteWait = CurTime() + 60

    local tblNote = {subject=subject, text=text, time=curTime}
    local filePath = path .. "/" .. ply:GetCharacter():GetID() .. ".txt"

    if file.Exists(filePath, "DATA") then
        local notes = file.Read(filePath)
        notes = util.JSONToTable(notes)
        if istable(notes) then
            notes[id] = tblNote
        else
            notes = {tblNote}
        end
        notes = util.TableToJSON(notes)
        file.Write(filePath, notes)
    else
        file.Write(filePath, util.TableToJSON({tblNote}))
    end
end)
