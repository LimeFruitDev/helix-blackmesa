--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local PROGRAM = {}
PROGRAM.order = 2
PROGRAM.name = "Mail"
PROGRAM.icon = "icon16/email.png"
PROGRAM.size = {x = 900, y = 700}

if CLIENT then
    local program, inbox, outbox

    function PROGRAM.build()
        local program = desktop:Add("DFrame")
        program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
        program:SetIcon(PROGRAM.icon)
        program:SetTitle(PROGRAM.name)
		program:Center()
        program:RequestFocus()

        local bottomDocker = program:Add("DPanel")
        bottomDocker:SetSize(100, 100)
        bottomDocker:SetPos(15, PROGRAM.size.y - bottomDocker:GetTall() - 15)
        bottomDocker:SetZPos(2)
        bottomDocker.Paint = function(this, w, h) return end

        local newMailBtn = bottomDocker:Add("DButton")
        newMailBtn:Dock(BOTTOM)
        newMailBtn:SetText("Compose")
        newMailBtn:SetZPos(3)
        newMailBtn.DoClick = function()
            PLUGIN:runProgram("search", PROGRAM.SendNewMail, true)
        end

        if LocalPlayer():HasClearances("A") then
            local newMailFactionBtn = bottomDocker:Add("DButton")
            newMailFactionBtn:Dock(BOTTOM)
            newMailFactionBtn:DockMargin(0, 2, 0, 0)
            newMailFactionBtn:SetText("Faction Wide")
            newMailFactionBtn:SetZPos(3)
            newMailFactionBtn.DoClick = function()
                PROGRAM.SendNewMail(nil, nil, nil, nil, nil, nil, false)
            end

            local newMailAllBtn = bottomDocker:Add("DButton")
            newMailAllBtn:Dock(BOTTOM)
            newMailAllBtn:DockMargin(0, 2, 0, 0)
            newMailAllBtn:SetText("Facility Wide")
            newMailAllBtn:SetZPos(3)
            newMailAllBtn.DoClick = function()
                PROGRAM.SendNewMail(nil, nil, nil, nil, nil, nil, true)
            end
        end

        local sheet = program:Add("DColumnSheet")
        sheet:Dock(FILL)

        -- inbox
        inbox = sheet:Add("DListView")
        inbox:Dock(FILL)
        inbox:SetMultiSelect(false)
        inbox:AddColumn("Received"):SetWidth(120)
        inbox:AddColumn("From"):SetWidth(220)
        inbox:AddColumn("Subject"):SetWidth(120)
        inbox:AddColumn("Message"):SetWidth(240)
        inbox.DoDoubleClick = function(self, id, line)
            PROGRAM.ViewMail(false, line:GetColumnText(3), line:GetColumnText(4), line:GetColumnText(5), line:GetColumnText(6), line:GetColumnText(7), line:GetColumnText(8), line:GetColumnText(9))
        end
        inbox.OnRowRightClick = function(self, id, line)
            local menu = DermaMenu()
                local option = menu:AddOption("Delete", function() netstream.Start("computerRemoveMail", line:GetColumnText(9)) PROGRAM.rebuild() end)
                option:SetIcon("icon16/delete.png")
            menu:Open()
        end
        sheet:AddSheet("Inbox", inbox, "icon16/email_open.png")

        -- outbox
        outbox = sheet:Add("DListView")
        outbox:Dock(FILL)
        outbox:SetMultiSelect(false)
        outbox:AddColumn("Sent"):SetWidth(120)
        outbox:AddColumn("To"):SetWidth(220)
        outbox:AddColumn("Subject"):SetWidth(120)
        outbox:AddColumn("Message"):SetWidth(240)
        outbox.DoDoubleClick = function(self, id, line)
            PROGRAM.ViewMail(true, line:GetColumnText(3), line:GetColumnText(4), line:GetColumnText(5), line:GetColumnText(6), line:GetColumnText(7), line:GetColumnText(8), line:GetColumnText(9))
        end
        outbox.OnRowRightClick = function(self, id, line)
            local menu = DermaMenu()
                local option = menu:AddOption("Delete", function() netstream.Start("computerRemoveMail", line:GetColumnText(9)) PROGRAM.rebuild() end)
                option:SetIcon("icon16/delete.png")
            menu:Open()
        end
        sheet:AddSheet("Outbox", outbox, "icon16/email_go.png")

        netstream.Start("computerGetMail")
    end

    function PROGRAM.rebuild()
        inbox:Clear()
        outbox:Clear()
        netstream.Start("computerGetMail")
    end

    function PROGRAM.ViewMail(isSpeaker, mailSubject, mailText, targetChar, targetName, targetFaction, mailTime)
        local program = desktop:Add("DFrame")
        program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
        program:SetIcon(PROGRAM.icon)
        program:SetTitle(" " .. mailSubject)
		program:Center()
        program:RequestFocus()

        local person = program:Add("DTextEntry")
        person:SetPos(16, 38)
        person:SetSize(150, 25)
        person:SetText((isSpeaker and "To" or "From") .. ": " .. targetName .. " (" .. PLUGIN:GetUsername(targetName) .. "@bmrf.us)")
        person:SetEnabled(false)

        local subject = program:Add("DTextEntry")
        subject:SetPos(16, 75)
        subject:SetSize(150, 25)
        subject:SetText("Subject: " .. mailSubject)
        subject:SetEnabled(false)

        local text = program:Add("DTextEntry")
        text:Dock(FILL)
        text:DockMargin(0, 85, 0, 0)
        text:SetText("-- " .. (isSpeaker and "Created" or "Received") .. ": " .. string.NiceTime(os.time() - mailTime) .. " ago\n\n" .. mailText)
        text:SetMultiline(true)
        text:SetEnabled(false)

        if not isSpeaker then
            local replyBtn = program:Add("DButton")
            replyBtn:SetSize(100, 25)
            replyBtn:SetPos(program:GetWide() - replyBtn:GetWide() - 16, select(2, person:GetPos()))
            replyBtn:SetText("Reply")
            replyBtn.DoClick = function()
                program:Remove()
                PROGRAM.SendNewMail(targetChar, targetName, targetFaction, mailSubject, mailText, mailTime)
            end
        end
    end

    function PROGRAM.SendNewMail(char, name, faction, mailSubject, mailText, mailTime, isFacilityWide)
        local multiSelect = istable(char)
        local spaceMultiplier = multiSelect and 38*(#char-1) or nil

        local program = desktop:Add("DFrame")
        program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
        program:SetIcon(PROGRAM.icon)
        program:SetTitle(mailText and mailText or " Send Mail")
		program:Center()
        program:RequestFocus()

        local lines
        local person
        if multiSelect then
            -- multiple lines selected
            if #char > 3 and not LocalPlayer():HasClearances("A") then
                PLUGIN:runProgram("popup", "Mail", "You are not allowed to send email to more than 3 staff")
                return
            end

            for amount, line in pairs(char) do
                person = program:Add("DTextEntry")
                person:SetPos(16, 38*amount)
                person:SetSize(150, 25)
                person:SetText(line.name .. " (" .. PLUGIN:GetUsername(line.name) .. "@bmrf.us)")
                person:SetEnabled(false)
            end
        elseif isFacilityWide ~= nil then
            -- facility or faction wide emails
            person = program:Add("DTextEntry")
            person:SetPos(16, 38)
            person:SetSize(150, 25)
            person:SetText(isFacilityWide and "To: All Staff" or "To: " .. team.GetName(LocalPlayer():Team()) .. " Department")
            person:SetEnabled(false)
        else
            person = program:Add("DTextEntry")
            person:SetPos(16, 38)
            person:SetSize(150, 25)
            person:SetText(name .. " (" .. PLUGIN:GetUsername(name) .. "@bmrf.us)")
            person:SetEnabled(false)
        end

        local subject = program:Add("DTextEntry")
        subject:SetPos(16, multiSelect and 75+spaceMultiplier or 75)
        subject:SetSize(150, 25)
        subject:SetPlaceholderText("Subject")
        if mailSubject then
            subject:SetText("RE: " .. mailSubject)
        end

        local text = program:Add("DTextEntry")
        text:Dock(FILL)
        text:DockMargin(0, multiSelect and 85+spaceMultiplier or 85, 0, 0)
        text:SetPlaceholderText("Type text here...")
        text:SetMultiline(true)
        if mailText then
            text:SetText("Type reply here...\n\n\n-- Message from: " .. name .. "\n\n" .. mailText)
        end

        local sendBtn = program:Add("DButton")
        sendBtn:SetSize(100, 25)
        sendBtn:SetPos(program:GetWide() - sendBtn:GetWide() - 16, 38)
        sendBtn:SetText("Send")
        sendBtn.DoClick = function()
            if LocalPlayer().computerSendMailWait and CurTime() < LocalPlayer().computerSendMailWait then PLUGIN:runProgram("popup", "Mail", "Cooldown\n\n" ..  math.floor(LocalPlayer().computerSendMailWait - CurTime()) .. " second(s) remaining") return end
            LocalPlayer().computerSendMailWait = CurTime() + 60

            if multiSelect then
                netstream.Start("computerSendMultiMail", char, subject:GetValue(), text:GetValue())
            elseif isFacilityWide ~= nil then
                netstream.Start(isFacilityWide and "computerSendFacilityMail" or "computerSendFactionMail", subject:GetValue(), text:GetValue())
            else
                netstream.Start("computerSendMail", char, name, faction, subject:GetValue(), text:GetValue())
            end

            if IsValid(program) then
                PROGRAM.rebuild()
            end

			PLUGIN:runProgram("popup", "Mail", "Mail sent")

            program:Remove()
        end
    end

    netstream.Hook("computerGetMail", function(tblMail)
        for id, mail in pairs(tblMail) do
            if tonumber(mail.audienceChar) == LocalPlayer():GetCharacter():GetID() then
                inbox:AddLine(string.NiceTime(os.time() - mail.mailTime) .. " ago", mail.speakerName .. " (" .. PLUGIN:GetUsername(mail.speakerName) .. "@bmrf.us)", mail.mailSubject, mail.mailText, mail.speakerChar, mail.speakerName, mail.speakerFaction, mail.mailTime, id)
            else
                outbox:AddLine(string.NiceTime(os.time() - mail.mailTime) .. " ago", mail.audienceName .. " (" .. PLUGIN:GetUsername(mail.audienceName) .. "@bmrf.us)", mail.mailSubject, mail.mailText, mail.audienceChar, mail.audienceName, mail.audienceFaction, mail.mailTime, id)
            end
        end
    end)

    PLUGIN:registerProgram(PROGRAM)
end
