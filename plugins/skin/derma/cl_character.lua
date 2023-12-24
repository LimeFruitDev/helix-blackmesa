local gradient = surface.GetTextureID("vgui/gradient-d")
local gradient_r = surface.GetTextureID("vgui/gradient-r")
local audioFadeInTime = 2
local animationTime = 0.5
local matrixZScale = Vector(1, 1, 0.0001)

-- character menu panel
DEFINE_BASECLASS("ixSubpanelParentNew")
local PANEL = {}

function PANEL:Init()
	self:SetSize(self:GetParent():GetSize())
	self:SetPos(0, 0)

	self.childPanels = {}
	self.subpanels = {}
	self.activeSubpanel = ""

	self.currentDimAmount = 0
	self.currentY = 0
	self.currentScale = 1
	self.currentAlpha = 255
	self.targetDimAmount = 255
	self.targetScale = 0.9
end

function PANEL:Dim(length, callback)
	length = length or animationTime
	self.currentDimAmount = 0

	self:CreateAnimation(length, {
		target = {
			currentDimAmount = self.targetDimAmount,
			currentScale = self.targetScale
		},
		easing = "outCubic",
		OnComplete = callback
	})

	self:OnDim()
end

function PANEL:Undim(length, callback)
	length = length or animationTime
	self.currentDimAmount = self.targetDimAmount

	self:CreateAnimation(length, {
		target = {
			currentDimAmount = 0,
			currentScale = 1
		},
		easing = "outCubic",
		OnComplete = callback
	})

	self:OnUndim()
end

function PANEL:OnDim()
end

function PANEL:OnUndim()
end

local menu_gradient = Material("vgui/gradient-l.png")
local menu_filler = Material("materials/limefruit/ui/menu_filler.png")
function PANEL:Paint(width, height)
	local amount = self.currentDimAmount
	local bShouldScale = self.currentScale != 1
	local matrix

	-- draw the background
	-- surface.SetDrawColor(ColorAlpha(ix.skin.colors.primary, 50))
	-- surface.SetMaterial(menu_gradient)
	-- surface.DrawTexturedRect(0, 0, width, height)
	-- surface.SetDrawColor(ColorAlpha(color_white, 50))
	-- surface.SetMaterial(menu_filler)
	-- surface.DrawTexturedRect(0, 0, width, height)

	-- draw child panels with scaling if needed
	if (bShouldScale) then
		matrix = Matrix()
		matrix:Scale(matrixZScale * self.currentScale)
		matrix:Translate(Vector(
			ScrW() * 0.5 - (ScrW() * self.currentScale * 0.5),
			ScrH() * 0.5 - (ScrH() * self.currentScale * 0.5),
			1
		))

		cam.PushModelMatrix(matrix)
		self.currentMatrix = matrix
	end

	BaseClass.Paint(self, width, height)

	if (bShouldScale) then
		cam.PopModelMatrix()
		self.currentMatrix = nil
	end

	if (amount > 0) then
		local color = Color(0, 0, 0, amount)

		surface.SetDrawColor(color)
		surface.DrawRect(0, 0, width, height)
	end
end

vgui.Register("ixCharMenuPanel", PANEL, "ixSubpanelParentNew")

-- character menu main button list
PANEL = {}

function PANEL:Init()
	local parent = self:GetParent()
	self:SetSize(parent:GetWide() * 0.25, parent:GetTall())

	self:GetVBar():SetWide(0)
	self:GetVBar():SetVisible(false)
end

function PANEL:Add(name)
	local panel = vgui.Create(name, self)
	panel:Dock(TOP)
	panel:DockMargin(0, 0, 0, 16)

	return panel
end

function PANEL:SizeToContents()
	self:GetCanvas():InvalidateLayout(true)

	-- if the canvas has extra space, forcefully dock to the bottom so it doesn't anchor to the top
	if (self:GetTall() > self:GetCanvas():GetTall()) then
		self:GetCanvas():Dock(BOTTOM)
	else
		self:GetCanvas():Dock(NODOCK)
	end
end

vgui.Register("ixCharMenuButtonList", PANEL, "DScrollPanel")

-- main character menu panel
PANEL = {}

AccessorFunc(PANEL, "bUsingCharacter", "UsingCharacter", FORCE_BOOL)

function PANEL:Init()
	local parent = self:GetParent()
	local padding = self:GetPadding()
	local scrW = ScrW()
	local halfWidth = scrW * 0.5
	local halfPadding = padding * 0.5
	local bHasCharacter = #ix.characters > 0

	self.bUsingCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
	-- self:DockPadding(padding, padding, padding, padding)

	self.logoPanel = self:Add("Panel")
	self.logoPanel:SetSize(ScrW(), 360)
	self.logoPanel.Paint = function(panel, width, height)
		
	end

	-- draw schema logo material instead of text if available
	local logo = Schema.logo and ix.util.GetMaterial(Schema.logo)

	if (logo and !logo:IsError()) then
		local logoImage = self.logoPanel:Add("DImage")
		logoImage:SetMaterial(logo)
		logoImage:SetSize(1724*0.35, 542*0.35)
		-- left side
		-- ScrW() * 0.1, halfPadding
		logoImage:SetPos(halfWidth - logoImage:GetWide() * 0.5, halfPadding)
		logoImage:SetPaintedManually(true)

		self.logoPanel:SetTall(logoImage:GetTall() + padding*1.5)
	else
		local newHeight = padding
		local subtitle = L2("schemaDesc") or Schema.description

		local titleLabel = self.logoPanel:Add("DLabel")
		titleLabel:SetTextColor(color_white)
		titleLabel:SetFont("ixTitleFont")
		titleLabel:SetText(L2("schemaName") or Schema.name or L"unknown")
		titleLabel:SizeToContents()
		titleLabel:SetPos(halfWidth - titleLabel:GetWide() * 0.5, halfPadding)
		titleLabel:SetPaintedManually(true)
		newHeight = newHeight + titleLabel:GetTall()

		if (subtitle) then
			local subtitleLabel = self.logoPanel:Add("DLabel")
			subtitleLabel:SetTextColor(color_white)
			subtitleLabel:SetFont("ixSubTitleFont")
			subtitleLabel:SetText(subtitle)
			subtitleLabel:SizeToContents()
			subtitleLabel:SetPos(halfWidth - subtitleLabel:GetWide() * 0.5, 0)
			subtitleLabel:MoveBelow(titleLabel)
			subtitleLabel:SetPaintedManually(true)
			newHeight = newHeight + subtitleLabel:GetTall()
		end

		self.logoPanel:SetTall(newHeight)
	end

	-- button list
	self.mainButtonList = self:Add("ixCharMenuButtonList")

	-- create character button
	local createButton = self.mainButtonList:Add("limefruitMenuButton")
	createButton:SetText("create")
	createButton:SizeToContents()
	createButton.DoClick = function()
		local maximum = hook.Run("GetMaxPlayerCharacter", LocalPlayer()) or ix.config.Get("maxCharacters", 5)
		-- don't allow creation if we've hit the character limit
		if (#ix.characters >= maximum) then
			self:GetParent():ShowNotice(3, L("maxCharacters"))
			return
		end

		self:Dim()
		parent.newCharacterPanel:SetActiveSubpanel("faction", 0)
		parent.newCharacterPanel:SlideUp()
	end

	-- load character button
	self.loadButton = self.mainButtonList:Add("limefruitMenuButton")
	self.loadButton:SetText(" load ")
	self.loadButton:SizeToContents()
	self.loadButton.DoClick = function()
		self:Dim()
		parent.loadCharacterPanel:SlideUp()
	end

	if (!bHasCharacter) then
		self.loadButton:SetDisabled(true)
	end

	-- community button
	local extraURL = ix.config.Get("communityURL", "")
	local extraText = ix.config.Get("communityText", "@community")

	if (extraURL != "" and extraText != "") then
		if (extraText:sub(1, 1) == "@") then
			extraText = L(extraText:sub(2))
		end

		local extraButton = self.mainButtonList:Add("limefruitMenuButton")
		extraButton:SetText(extraText, true)
		extraButton:SizeToContents()
		extraButton:SetGradientColor(color_white)
		extraButton.DoClick = function()
			gui.OpenURL(extraURL)
		end
	end

	-- leave/return button
	self.returnButton = self.mainButtonList:Add("limefruitMenuButton")
	self:UpdateReturnButton()
	self.returnButton.DoClick = function()
		if (self.bUsingCharacter) then
			parent:Close()
		else
			RunConsoleCommand("disconnect")
		end
	end

	self.mainButtonList:SizeToContents()
	self.mainButtonList:SetWide(scrW <= 1920 and scrW * 0.3 or 575)
end

function PANEL:UpdateReturnButton(bValue)
	if (bValue != nil) then
		self.bUsingCharacter = bValue
	end

	self.returnButton:SetText(self.bUsingCharacter and "return" or " leave ")
	-- self.returnButton:SetGradientColor(self.bUsingCharacter and color_white or Color(255,0,0))
	self.returnButton:SetGradientColor(Color(255,0,0))
	self.returnButton:SizeToContents()
end

function PANEL:OnDim()
	-- disable input on this panel since it will still be in the background while invisible - prone to stray clicks if the
	-- panels overtop slide out of the way
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
end

function PANEL:OnUndim()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)

	-- we may have just deleted a character so update the status of the return button
	self.bUsingCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
	self:UpdateReturnButton()
end

function PANEL:OnClose()
	for _, v in pairs(self:GetChildren()) do
		if (IsValid(v)) then
			v:SetVisible(false)
		end
	end
end

function PANEL:PerformLayout(width, height)
	local padding = self:GetPadding()
	self.mainButtonList:SetPos(width / 2 - (self.mainButtonList:GetWide() / 2), height / 2 - (self.mainButtonList:GetTall() * 0.7) - padding)
	self.logoPanel:SetPos(width / 2 - self.logoPanel:GetWide() / 2, height <= 1080 and height / 2 - self.logoPanel:GetTall() or height / 1.75 - self.logoPanel:GetTall())
end

vgui.Register("ixCharMenuMain", PANEL, "ixCharMenuPanel")

-- container panel
PANEL = {}

function PANEL:Init()
	if (IsValid(ix.gui.loading)) then
		ix.gui.loading:Remove()
	end

	if (IsValid(ix.gui.characterMenu)) then
		if (IsValid(ix.gui.characterMenu.channel)) then
			ix.gui.characterMenu.channel:Stop()
		end

		ix.gui.characterMenu:Remove()
	end

	self:SetSize(ScrW(), ScrH())
	self:SetPos(0, 0)

	-- main menu panel
	self.mainPanel = self:Add("ixCharMenuMain")

	-- new character panel
	self.newCharacterPanel = self:Add("ixCharMenuNew")
	self.newCharacterPanel:SlideDown(0)

	-- load character panel
	self.loadCharacterPanel = self:Add("ixCharMenuLoad")
	self.loadCharacterPanel:SlideDown(0)

	-- notice bar
	self.notice = self:Add("ixNoticeBar")

	-- finalization
	self:MakePopup()
	self.currentAlpha = 255
	self.volume = 0

	ix.gui.characterMenu = self

	if (!IsValid(ix.gui.intro)) then
		self:PlayMusic()
	end

	hook.Run("OnCharacterMenuCreated", self)
end

function PANEL:PlayMusic()
	local path = "sound/" .. ix.config.Get("music")
	local url = path:match("http[s]?://.+")
	local play = url and sound.PlayURL or sound.PlayFile
	path = url and url or path

	play(path, "noplay", function(channel, error, message)
		if (!IsValid(self) or !IsValid(channel)) then
			return
		end

		channel:SetVolume(self.volume or 0)
		channel:Play()

		self.channel = channel

		self:CreateAnimation(audioFadeInTime, {
			index = 10,
			target = {volume = 1},

			Think = function(animation, panel)
				if (IsValid(panel.channel)) then
					panel.channel:SetVolume(self.volume * 0.5)
				end
			end
		})
	end)
end

function PANEL:ShowNotice(type, text)
	self.notice:SetType(type)
	self.notice:SetText(text)
	self.notice:Show()
end

function PANEL:HideNotice()
	if (IsValid(self.notice) and !self.notice:GetHidden()) then
		self.notice:Slide("up", 0.5, true)
	end
end

function PANEL:OnCharacterDeleted(character)
	if (#ix.characters == 0) then
		self.mainPanel.loadButton:SetDisabled(true)
		self.mainPanel:Undim() -- undim since the load panel will slide down
	else
		self.mainPanel.loadButton:SetDisabled(false)
	end

	self.loadCharacterPanel:OnCharacterDeleted(character)
end

function PANEL:OnCharacterLoadFailed(error)
	self.loadCharacterPanel:SetMouseInputEnabled(true)
	self.loadCharacterPanel:SlideUp()
	self:ShowNotice(3, error)
end

function PANEL:IsClosing()
	return self.bClosing
end

function PANEL:Close(bFromMenu)
	self.bClosing = true
	self.bFromMenu = bFromMenu

	local fadeOutTime = animationTime * 8

	self:CreateAnimation(fadeOutTime, {
		index = 1,
		target = {currentAlpha = 0},

		Think = function(animation, panel)
			panel:SetAlpha(panel.currentAlpha)
		end,

		OnComplete = function(animation, panel)
			panel:Remove()
		end
	})

	self:CreateAnimation(fadeOutTime - 0.1, {
		index = 10,
		target = {volume = 0},

		Think = function(animation, panel)
			if (IsValid(panel.channel)) then
				panel.channel:SetVolume(self.volume * 0.5)
			end
		end,

		OnComplete = function(animation, panel)
			if (IsValid(panel.channel)) then
				panel.channel:Stop()
				panel.channel = nil
			end
		end
	})

	-- hide children if we're already dimmed
	if (bFromMenu) then
		for _, v in pairs(self:GetChildren()) do
			if (IsValid(v)) then
				v:SetVisible(false)
			end
		end
	else
		-- fade out the main panel quicker because it significantly blocks the screen
		self.mainPanel.currentAlpha = 255

		self.mainPanel:CreateAnimation(animationTime * 2, {
			target = {currentAlpha = 0},
			easing = "outQuint",

			Think = function(animation, panel)
				panel:SetAlpha(panel.currentAlpha)
			end,

			OnComplete = function(animation, panel)
				panel:SetVisible(false)
			end
		})
	end

	-- relinquish mouse control
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	gui.EnableScreenClicker(false)
end

local skipAlpha = 0
local skipAlphaDir = 1

function PANEL:Paint(width, height)
	ix.util.DrawBlur(self)
	surface.SetDrawColor(0, 0, 0, 50)
	surface.DrawRect(0, 0, width, height)

	-- draw panel
	local panelTall = 45
	ix.util.DrawBlurAt(0, height-panelTall, width, panelTall)
	surface.SetDrawColor(Color(32, 32, 32, 240))
	surface.DrawRect(0, height-panelTall, width, panelTall)
	surface.SetDrawColor(Schema.color)
    surface.DrawRect(0, height-panelTall-8, width, 8)

	-- schema version
	-- skipAlpha = skipAlpha + (0.25 * skipAlphaDir)

	-- if skipAlpha <= 50 then skipAlphaDir = 1
	-- elseif skipAlpha >= 255 then skipAlphaDir = -1 end

	-- draw.DrawText(Schema.version, "LimeFruit.Fonts.SmallFont", ScrW()-20, ScrH()-30, Color(240, 240, 240, skipAlpha), TEXT_ALIGN_RIGHT)
end

function PANEL:PaintOver(width, height)
	if (self.bClosing and self.bFromMenu) then
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, width, height)
	end
end

function PANEL:OnRemove()
	if (self.channel) then
		self.channel:Stop()
		self.channel = nil
	end
end

vgui.Register("ixCharMenu", PANEL, "EditablePanel")

if (IsValid(ix.gui.characterMenu)) then
	ix.gui.characterMenu:Remove()

	--TODO: REMOVE ME
	ix.gui.characterMenu = vgui.Create("ixCharMenu")
end
