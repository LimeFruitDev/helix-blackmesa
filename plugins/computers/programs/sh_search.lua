--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local PROGRAM = {}
PROGRAM.order = 0
PROGRAM.name = "Search"
PROGRAM.icon = "icon16/magnifier.png"
PROGRAM.hide = true
PROGRAM.size = {x = 400, y = 250}

if CLIENT then
    local characters, searchEntry, resultList

    local function searchArchives(text, journalArchive)
        resultList:Clear()
        for i, journal in pairs(journalArchive) do
            if text == nil or text == "" or string.find(string.lower(journal.text), string.lower(text)) then
                resultList:AddLine(journal.text, string.NiceTime(os.time()-journal.time) .. " ago", i)
            end
        end
    end

    local function searchStaff(text)
        resultList:Clear()

        local curChar = LocalPlayer():GetCharacter():GetID()
        for k, v in pairs(characters) do
            if v.id == curChar then continue end

            if text == nil or text == "" or string.find(string.lower(v.name), string.lower(text)) then
                resultList:AddLine(v.name, string.FirstToUpper(v.faction), v.id)
            end
        end
    end

	function PROGRAM.build(view, allowMultiSelect, journalArchive)
        local program = desktop:Add("DFrame")
        program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
        program:SetIcon(PROGRAM.icon)
        program:SetTitle("Search")
		program:Center()
        program:RequestFocus()

        local searchPanel = program:Add("DPanel")
        searchPanel:Dock(TOP)
        searchPanel:DockMargin(4, 0, 4, 0)
        searchPanel:SetTall(20)
        searchPanel.Paint = function(this, w, h)
        end

		local infoLabel = searchPanel:Add("DLabel")
        infoLabel:Dock(LEFT)
		infoLabel:SetText("Search:")
		infoLabel:SizeToContents()

        local function startSearch()
            if journalArchive then
                searchArchives(searchEntry:GetValue(), journalArchive)
            else
                searchStaff(searchEntry:GetValue())
            end
        end

        searchEntry = searchPanel:Add("DTextEntry")
        searchEntry:Dock(FILL)
        searchEntry:DockMargin(4, 0, 4, 0)
        searchEntry.OnEnter = function()
            startSearch()
        end
        searchEntry.OnChange = function()
            startSearch()
        end

		local searchBtn = searchPanel:Add("DButton")
        searchBtn:Dock(RIGHT)
        searchBtn:SetText("Search")
		searchBtn.DoClick = function()
            startSearch()
		end

		resultList = program:Add("DListView")
        resultList:Dock(FILL)
        resultList:DockMargin(4, 4, 4, 4)
        resultList:SetMultiSelect(allowMultiSelect and true or false)
		resultList:AddColumn("Name")
        if journalArchive then
            resultList:AddColumn("Created"):SetMaxWidth(150)
        else
		    resultList:AddColumn("Division"):SetMaxWidth(150)
        end

		local okButton = program:Add("DButton")
        okButton:Dock(BOTTOM)
        okButton:DockMargin(4, 0, 4, 4)
        okButton:SetText("Select")
		okButton.DoClick = function()
            if allowMultiSelect and #resultList:GetSelected() > 1 then
                local lines = {}
                for line, object in pairs(resultList:GetSelected()) do
                    line = resultList:GetLine(line)
                    lines[#lines + 1] = {char=line:GetColumnText(3), name=line:GetColumnText(1), faction=line:GetColumnText(2)}
                end
                view(lines)

                program:Remove()
            else
                local line = resultList:GetSelectedLine()
                if line then
                    line = resultList:GetLine(line)
                    view(line:GetColumnText(3), line:GetColumnText(1), line:GetColumnText(2))
                    program:Remove()
                end
            end
        end
        okButton.Think = function()
            local line = resultList:GetSelectedLine()
            if line then
                okButton:SetEnabled(true)
            elseif okButton:IsEnabled() then
                okButton:SetEnabled(false)
            end
        end

        if not journalArchive then
            netstream.Start("computerGetCharList")
        else
            startSearch()
        end
    end

    netstream.Hook("computerGetCharList", function(results)
        characters = results
        searchStaff()
    end)

    netstream.Hook("computerUpdateCharList", function(results)
        characters = results
    end)

	PLUGIN:registerProgram(PROGRAM)
end
