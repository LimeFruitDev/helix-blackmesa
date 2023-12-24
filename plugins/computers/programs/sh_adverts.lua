--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local PROGRAM = {}
PROGRAM.order = 7
PROGRAM.name = "Adverts"
PROGRAM.icon = "icon16/information.png"
PROGRAM.size = {x = 400, y = 500}
PROGRAM.permission = function() return LocalPlayer():HasClearances("A") end

if CLIENT then
	local program

	function PROGRAM.build()
		program = desktop:Add("DFrame")
		program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
		program:Center()
		program:RequestFocus()
		program:SetIcon(PROGRAM.icon)
		program:SetTitle(PROGRAM.name)

		local adverts = program:Add("DListView")
		adverts:Dock(FILL)
		adverts:AddColumn("Title")
		adverts:AddColumn("Author")
		adverts:AddColumn("Created")

		local faction = LocalPlayer():GetCharacter():GetFaction()
		for advertID, advert in SortedPairsByMemberValue(ix.plugin.list["adverts"].adverts, "time", true) do
			if not LocalPlayer():IsAdmin() and faction ~= FACTION_DIRECTOR and faction ~= FACTION_ADMINISTRATION and advert.char ~= LocalPlayer():GetCharacter():GetID() then continue end
			adverts:AddLine(advert.title, advert.author, string.NiceTime(os.time() - advert.time) .. " ago", advert.text, advert.image, advertID)
		end

		adverts.OnRowSelected = PROGRAM.buildAdvertUpdate

		local createAdvertBtn = program:Add("DButton")
		createAdvertBtn:Dock(BOTTOM)
		createAdvertBtn:SetText("Create Advert")
		createAdvertBtn:DockMargin(0, 2, 0, 0)
		createAdvertBtn.DoClick = PROGRAM.buildAdvertCreate
	end

	function PROGRAM.buildAdvertCreate()
		local program = desktop:Add("DFrame")
		program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
		program:Center()
		program:RequestFocus()
		program:SetIcon(PROGRAM.icon)
		program:SetTitle("Create Advert")

		local advertTitle = program:Add("DTextEntry")
		advertTitle:Dock(TOP)
		advertTitle:SetPlaceholderText("Title")
		advertTitle:SetMultiline(false)

		local advertText = program:Add("DTextEntry")
		advertText:Dock(FILL)
		advertText:DockMargin(0, 2, 0, 0)
		advertText:SetPlaceholderText("Content (max 200 characters)")
		advertText:SetMultiline(true)

		local submit = program:Add("DButton")
		submit:Dock(BOTTOM)
		submit:SetText("Submit")
		submit:DockMargin(0, 2, 0, 0)
		submit.DoClick = function()
			netstream.Start("computerAdvertsCreate", advertTitle:GetValue(), advertText:GetValue(), advertImage:GetValue())
			program:Remove()
			if IsValid(program) then
				program:Remove()
			end
			PLUGIN:runProgram("popup", "Adverts", "Advert created")
		end

		advertImage = program:Add("DTextEntry")
		advertImage:Dock(BOTTOM)
		advertImage:SetPlaceholderText("Image (must be direct link)")
		advertImage:SetMultiline(false)
	end

	function PROGRAM.buildAdvertUpdate(panel, rowIndex, row)
		local program = desktop:Add("DFrame")
		program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
		program:Center()
		program:RequestFocus()
		program:SetIcon(PROGRAM.icon)
		program:SetTitle(row:GetValue(1))

		local advertTitle = program:Add("DTextEntry")
		advertTitle:Dock(TOP)
		advertTitle:SetText(row:GetValue(1))
		advertTitle:SetMultiline(false)

		local advertText = program:Add("DTextEntry")
		advertText:Dock(FILL)
		advertText:DockMargin(0, 2, 0, 0)
		advertText:SetText(row:GetValue(4))
		advertText:SetMultiline(true)

		local remove = program:Add("DButton")
		remove:Dock(BOTTOM)
		remove:SetText("Remove")
		remove:DockMargin(0, 2, 0, 0)
		remove.DoClick = function()
			netstream.Start("computerAdvertsRemove", row:GetValue(6))
			program:Remove()
			if IsValid(program) then
				program:Remove()
			end
			PLUGIN:runProgram("popup", "Adverts", "Advert removed")
		end

		local submit = program:Add("DButton")
		submit:Dock(BOTTOM)
		submit:SetText("Submit")
		submit:DockMargin(0, 2, 0, 0)
		submit.DoClick = function()
			netstream.Start("computerAdvertsUpdate", row:GetValue(6), advertTitle:GetValue(), advertText:GetValue(), advertImage:GetValue())
			program:Remove()
			if IsValid(program) then
				program:Remove()
			end
			PLUGIN:runProgram("popup", "Adverts", "Advert created")
		end

		advertImage = program:Add("DTextEntry")
		advertImage:Dock(BOTTOM)
		advertImage:SetText(row:GetValue(5))
		advertImage:SetMultiline(false)
	end

	PLUGIN:registerProgram(PROGRAM)
end
