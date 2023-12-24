--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2023 Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local gradient = surface.GetTextureID("vgui/gradient-d")
local gradientUp = surface.GetTextureID("vgui/gradient-u")
local gradientLeft = surface.GetTextureID("vgui/gradient-l")
local gradientRight = surface.GetTextureID("vgui/gradient-r")
local gradientLeftRightCenter = Material("limefruit/vgui/gradient-lrc.png")
local gradientRadial = Material("helix/gui/radial-gradient.png")
local defaultBackgroundColor = Color(30, 30, 30, 200)

local SKIN = derma.GetNamedSkin("helix")

function SKIN:PaintFrame(panel)
	if (!panel.bNoBackgroundBlur) then
		ix.util.DrawBlur(panel, 10)
	end

	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

	if (panel:GetTitle() != "" or panel.btnClose:IsVisible()) then
		surface.SetDrawColor(Schema.color)
		surface.DrawRect(0, 0, panel:GetWide(), 24)

		if (panel.bHighlighted) then
			self:DrawImportantBackground(0, 0, panel:GetWide(), 24, ColorAlpha(color_white, 22))
		end
	end

	-- surface.SetDrawColor(Schema.color)
	-- surface.DrawRect(0, panel:GetTall()-4, panel:GetWide(), 4)

	surface.SetDrawColor(Schema.color)
	surface.DrawOutlinedRect(0, 0, panel:GetWide(), panel:GetTall())
end

function SKIN:PaintInventorySlot(panel, width, height)
	surface.SetDrawColor(35, 35, 35, 85)
	surface.DrawRect(1, 1, width - 2, height - 2)

	-- surface.SetDrawColor(0, 0, 0, 250)
	-- surface.DrawOutlinedRect(1, 1, width - 2, height - 2)
end

function SKIN:PaintCategoryPanel(panel, text, color)
	text = text or ""
	color = color or ix.config.Get("color")

	surface.SetFont(self.fontCategoryBlur)

	local textHeight = select(2, surface.GetTextSize(text)) + 6
	local width, height = panel:GetSize()

	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawRect(0, textHeight, width, height - textHeight)

	self:DrawImportantBackground(0, 0, width, textHeight, color)

	surface.SetTextColor(color_black)
	surface.SetTextPos(4, 4)
	surface.DrawText(text)

	surface.SetFont(self.fontCategory)
	surface.SetTextColor(color_white)
	surface.SetTextPos(4, 4)
	surface.DrawText(text)

	-- surface.SetDrawColor(color)
	-- surface.DrawOutlinedRect(0, 0, width, height)

	return 1, textHeight, 1, 1
end

function SKIN:PaintChatboxTabs(panel, width, height, alpha)	
	-- surface.SetDrawColor(ColorAlpha(Schema.color, 50))
	surface.SetDrawColor(ColorAlpha(defaultBackgroundColor, 255))
	surface.DrawRect(0, 0, width, height)
end

function SKIN:PaintChatboxTabButton(panel, width, height)
	surface.SetDrawColor(Schema.color)
	surface.DrawRect(0, 0, width, height)
end

function SKIN:PaintChatboxBackground(panel, width, height)
	ix.util.DrawBlur(panel, 10)

	-- if (panel:GetActive()) then
	-- 	surface.SetDrawColor(ColorAlpha(ix.config.Get("color"), 120))
	-- 	surface.SetTexture(gradientUp)
	-- 	surface.DrawTexturedRect(0, panel.tabs.buttons:GetTall(), width, height * 0.25)
	-- end

	surface.SetDrawColor(ColorAlpha(color_black, 100))
	surface.DrawRect(0, 0, width, height)
end

function SKIN:PaintChatboxEntry(panel, width, height)
	surface.SetDrawColor(ColorAlpha(color_black, 100))
	surface.DrawRect(0, 0, width, height)

	panel:DrawTextEntryText(color_white, ix.config.Get("color"), color_white)
end

function SKIN:PaintGradientPanel(x, y, width, height, alphaColor, outlineWidth)
	alphaColor = alphaColor or 255
	outlineWidth = outlineWidth or 6
	local halfWidth = width/2
	local centerWidth = halfWidth/4

	-- panel
	surface.SetDrawColor(32, 32, 32, alphaColor*(240/255))
	surface.SetMaterial(gradientLeftRightCenter)
	surface.DrawTexturedRect(x, y, width, height)

	-- outlines
	surface.SetDrawColor(ColorAlpha(Schema.color, alphaColor))
	surface.DrawTexturedRect(x, y, width, outlineWidth)
	surface.DrawTexturedRect(x, y + height - outlineWidth, width, outlineWidth)
end

do
	-- Check if sounds exist, otherwise fall back to default UI sounds
	local bClickRelease = file.Exists("sound/limefruit/ui/buttonclickrelease.wav", "GAME")
	local bRollover = file.Exists("sound/limefruit/ui/buttonrollover.wav", "GAME")

	sound.Add({
		name = "LimeFruit.UI.ClickRelease",
		channel = CHAN_STATIC,
		volume = 1,
		level = 80,
		pitch = 100,
		sound = bClickRelease and "limefruit/ui/buttonclickrelease.wav" or "ui/buttonclickrelease.wav"
	})

	sound.Add({
		name = "LimeFruit.UI.Rollover",
		channel = CHAN_STATIC,
		volume = 1,
		level = 80,
		pitch = 100,
		sound = bRollover and "limefruit/ui/buttonrollover.wav" or "ui/buttonrollover.wav"
	})
end
