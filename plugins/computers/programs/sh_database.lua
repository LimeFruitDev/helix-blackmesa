--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local PROGRAM = {}
PROGRAM.order = 8
PROGRAM.name = "Database"
PROGRAM.icon = "icon16/folder_user.png"
PROGRAM.size = {x = 500, y = 600}
PROGRAM.permission = function() return LocalPlayer():HasClearances("A") end

PROGRAM.licenses = {"HEV", "Taser", "Firearms"}
PROGRAM.clearances = {["A"] = "Administration", ["B"] = "Biology", ["P"] = "Physics", ["S"] = "Security", ["X"] = "Xenian", ["1"] = "Level 1", ["2"] = "Level 2", ["3"] = "Level 3", ["4"] = "Level 4", ["5"] = "Level 5"}

if CLIENT then
	local program, journalLabel, searchButton, editor, closeJournalBtn, removeJournalBtn, journals, journalSelected, accessRows, logs

	local function IsAdministration()
		local faction = LocalPlayer():GetCharacter():GetFaction()
		return (faction == FACTION_ADMINISTRATION or faction == FACTION_DIRECTOR) or false
	end

	function PROGRAM.build(...)
        PLUGIN:runProgram("search", PROGRAM.view)
    end

    function PROGRAM.view(char, name, faction)
		journalSelected = nil

		program = desktop:Add("DFrame")
		program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
		program:Center()
		program:RequestFocus()
		program:SetIcon(PROGRAM.icon)
		program:SetTitle(" " .. name)
		program.Think = function(this)
			PLUGIN.detectFocus(this)
		end

		local sheet = program:Add("DPropertySheet")
		sheet:Dock(FILL)

		-- Journal.
		local journal = sheet:Add("DPanel")
		sheet:AddSheet("Journal", journal, "icon16/report.png")

		-- Subject box.
		journalLabel = journal:Add("DLabel")
		journalLabel:SetText("Entry: None")
		journalLabel:SizeToContents()
		journalLabel:SetPos(8, 6)

		searchButton = journal:Add("DButton")
		searchButton:SetPos(PROGRAM.size.x*0.745, 2)
		searchButton:SetSize(100, 22)
		searchButton:SetText("Search Archive")
		searchButton:SetDisabled(true)
		searchButton.DoClick = function()
			PLUGIN:runProgram("search", function(id, text, time)
				editor:SetText(text)
				journalSelected = id
				journalLabel:SetText("Entry: #" .. id)
				closeJournalBtn:SetVisible(true)
				removeJournalBtn:SetVisible(true)
			end, false, journals)
		end

		-- Editor.
		editor = journal:Add("DTextEntry")
		editor:Dock(FILL)
		editor:DockMargin(0, 25, 0, 0)
		editor:SetMultiline(true)
		editor:SetEditable(true)
		editor:SetPlaceholderText("Blank journal, start writing here...")

		local function updateJournalProgram()
			netstream.Start("computerGetJournals", char)
			editor:SetText("Blank journal, start writing here...")
			journalLabel:SetText("Entry: None")
			closeJournalBtn:SetVisible(false)
			removeJournalBtn:SetVisible(false)
			journalSelected = nil
		end

		local saveJournalBtn = journal:Add("DButton")
		saveJournalBtn:Dock(BOTTOM)
		saveJournalBtn:SetText("Save Entry")
		saveJournalBtn:DockMargin(0, 2, 0, 0)
		saveJournalBtn.DoClick = function()
			if not journalSelected then
				netstream.Start("computerCreateJournal", char, editor:GetValue())
				PLUGIN:runProgram("popup", "Journals", "Journal created.")
				updateJournalProgram()
			else
				netstream.Start("computerSetJournal", char, journalSelected, editor:GetValue())
				PLUGIN:runProgram("popup", "Journals", "Journal saved.")
				editor:SetText("Blank journal, start writing here...")
				updateJournalProgram()
			end
		end

		
		closeJournalBtn = journal:Add("DButton")
		closeJournalBtn:SetPos(PROGRAM.size.x*0.5425, 2)
		closeJournalBtn:SetSize(100, 22)
		closeJournalBtn:SetText("Close Entry")
		closeJournalBtn:DockMargin(0, 2, 0, 0)
		closeJournalBtn:SetVisible(false)
		closeJournalBtn.DoClick = function()
			updateJournalProgram()
		end

		removeJournalBtn = journal:Add("DButton")
		removeJournalBtn:SetPos(PROGRAM.size.x*0.34, 2)
		removeJournalBtn:SetSize(100, 22)
		removeJournalBtn:SetText("Delete Entry")
		removeJournalBtn:DockMargin(0, 2, 0, 0)
		removeJournalBtn:SetVisible(false)
		removeJournalBtn.DoClick = function()
			netstream.Start("computerRemoveJournal", char, journalSelected)
			PLUGIN:runProgram("popup", "Journals", "Journal erased.")
			updateJournalProgram()
		end

		-- Access.
		local access = sheet:Add("DPanel")
		sheet:AddSheet("Access", access, "icon16/folder_add.png")

	 	accessRows = access:Add("DProperties")
		accessRows:Dock(FILL)

		-- Logs.
		logs = sheet:Add("DListView")
		sheet:AddSheet("Logs", logs, "icon16/table.png")

		logs:AddColumn("Name")
		logs:AddColumn("Event")
		logs:AddColumn("Date")

		-- Save
		local saveBtn = accessRows:Add("DButton")
		saveBtn:SetText("Save")
		saveBtn:SetSize(0, 25)
		saveBtn:Dock(BOTTOM)
		saveBtn:DockMargin(2, 0, 2, 2)
		saveBtn.DoClick = function()
			program:Remove()
			netstream.Start("computerSetLicenses", char, PROGRAM.userLicenses)
			netstream.Start("computerSetClearances", char, PROGRAM.userData, PROGRAM.userClearances)
			PLUGIN:runProgram("popup", name, "Data saved.")
		end

		netstream.Start("computerGetLogs", char)
		netstream.Start("computerGetJournals", char)
		netstream.Start("computerGetLicenses", char)
		netstream.Start("computerGetData", char)
	end

	netstream.Hook("computerGetLogs", function(data)
		for _, log in SortedPairsByMemberValue(data, "time", true) do
			logs:AddLine(log.name, log.event, string.NiceTime(os.time() - log.time) .. " ago")
		end
	end)

	netstream.Hook("computerGetJournals", function(data)
		journals = data
		if #data > 0 then
			searchButton:SetDisabled(false)
		end
	end)

	netstream.Hook("computerGetLicenses", function(data)
		PROGRAM.userLicenses = data

		for _, license in pairs(PROGRAM.licenses) do
			local gotLicense = data[license] and data[license] or false
			PROGRAM.userLicenses[license] = gotLicense

			local row = accessRows:CreateRow("Licenses", license)
			row:Setup("Boolean")
			row:SetValue(gotLicense)
			row.DataChanged = function(_, checked)
				PROGRAM.userLicenses[license] = (checked == 1 and true or false)
			end
		end
	end)

	netstream.Hook("computerGetData", function(data, plyTarget)
		PROGRAM.userData = data
		PROGRAM.userClearances = {}

		for clearance, displayName in SortedPairs(PROGRAM.clearances) do
			local gotClearance = string.find(data.clearances, clearance)

			local row = accessRows:CreateRow("Clearances", "[" .. clearance .. "] " .. displayName)
			row:Setup("Boolean")
			row:SetValue(gotClearance)
			row.DataChanged = function(_, checked)
				PROGRAM.userClearances[clearance] = (checked == 1 and true or false)
			end

			PROGRAM.userClearances[clearance] = gotClearance and true or false
		end
	end)

	PLUGIN:registerProgram(PROGRAM)
end
