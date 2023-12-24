--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local PROGRAM = {}
PROGRAM.order = 3
PROGRAM.name = "Notepad"
PROGRAM.icon = "icon16/note.png"
PROGRAM.size = {x = 900, y = 700}

if CLIENT then
    local program, notes

    function PROGRAM.build()
        program = desktop:Add("DFrame")
        program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
        program:SetIcon(PROGRAM.icon)
        program:SetTitle(PROGRAM.name)
		program:Center()
        program:RequestFocus()

        local createNoteBtn = program:Add("DButton")
        createNoteBtn:SetSize(180, 25)
        createNoteBtn:SetPos(5, 28)
        createNoteBtn:SetText("Create New Note")
        createNoteBtn.DoClick = function()
            PROGRAM.CreateNewNote()
        end

        notes = program:Add("DListView")
        notes:Dock(FILL)
        notes:DockMargin(0, 28, 0, 0)
        notes:SetMultiSelect(false)
	    notes:AddColumn("Created"):SetWidth(120)
	    notes:AddColumn("Subject"):SetWidth(180)
	    notes:AddColumn("Message"):SetWidth(400)
        notes.DoDoubleClick = function(self, id, line)
            PROGRAM.ViewNote(line:GetColumnText(2), line:GetColumnText(3), line:GetColumnText(4), line:GetColumnText(5))
        end
        notes.OnRowRightClick = function(self, id, line)
            local menu = DermaMenu()
                local option = menu:AddOption("Delete", function() end)
                option:SetIcon("icon16/delete.png")
            menu:Open()
        end

        netstream.Start("computerGetNotes")
    end

    function PROGRAM.ViewNote(curSubject, curText, id, curTime)
        local program = desktop:Add("DFrame")
        program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
        program:SetIcon("icon16/note.png")
        program:SetTitle("Note: " .. curSubject)
		program:Center()
        program:RequestFocus()

        local subject = program:Add("DTextEntry")
        subject:SetPos(16, 38)
        subject:SetSize(150, 25)
        subject:SetPlaceholderText("Subject")
        subject:SetText(curSubject)

        local text = program:Add("DTextEntry")
        text:Dock(FILL)
        text:DockMargin(0, 45, 0, 0)
        text:SetPlaceholderText("Type text here...")
        text:SetText(curText)
        text:SetMultiline(true)

        local saveBtn = program:Add("DButton")
        saveBtn:SetSize(100, 25)
        saveBtn:SetPos(program:GetWide() - saveBtn:GetWide() - 16, select(2, subject:GetPos()))
        saveBtn:SetText("Save")
        saveBtn.DoClick = function()
            if LocalPlayer().computerCreateNewNoteWait and CurTime() < LocalPlayer().computerCreateNewNoteWait then PLUGIN:runProgram("popup", "Notepad", "Cooldown\n\n" ..  math.floor(LocalPlayer().computerCreateNewNoteWait - CurTime()) .. " second(s) remaining") return end
            LocalPlayer().computerCreateNewNoteWait = CurTime() + 60
            netstream.Start("computerSaveNote", id, subject:GetValue(), text:GetValue(), curTime)
            program:Remove()
            if IsValid(program) then
                program:Remove()
                PROGRAM.build()
            end
            PLUGIN:runProgram("popup", "Notepad", "Saved note")
        end
    end

    function PROGRAM.CreateNewNote()
        local program = desktop:Add("DFrame")
        program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
        program:SetIcon("icon16/note_add.png")
        program:SetTitle("Create Note")
		program:Center()
        program:RequestFocus()

        local subject = program:Add("DTextEntry")
        subject:SetPos(16, 38)
        subject:SetSize(150, 25)
        subject:SetPlaceholderText("Subject")

        local text = program:Add("DTextEntry")
        text:Dock(FILL)
        text:DockMargin(0, 45, 0, 0)
        text:SetPlaceholderText("Type text here...")
        text:SetMultiline(true)

        local createBtn = program:Add("DButton")
        createBtn:SetSize(100, 25)
        createBtn:SetPos(program:GetWide() - createBtn:GetWide() - 16, select(2, subject:GetPos()))
        createBtn:SetText("Create")
        createBtn.DoClick = function()
            if LocalPlayer().computerCreateNewNoteWait and CurTime() < LocalPlayer().computerCreateNewNoteWait then PLUGIN:runProgram("popup", "Notepad", "Cooldown\n\n" ..  math.floor(LocalPlayer().computerCreateNewNoteWait - CurTime()) .. " second(s) remaining") return end
            LocalPlayer().computerCreateNewNoteWait = CurTime() + 60
            netstream.Start("computerCreateNewNote", subject:GetValue(), text:GetValue())
            program:Remove()
            if IsValid(program) then
                program:Remove()
                PROGRAM.build()
            end
            PLUGIN:runProgram("popup", "Notepad", "Created new note")
        end
    end

    netstream.Hook("computerGetNotes", function(tblNotes)
        for id, note in pairs(tblNotes) do
            notes:AddLine(string.NiceTime(os.time() - note.time) .. " ago", note.subject, note.text, id, note.time)
        end
    end)

    PLUGIN:registerProgram(PROGRAM)
end
