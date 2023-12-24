local PANEL = {}

AccessorFunc(PANEL, "fadeDelay", "FadeDelay", FORCE_NUMBER)
AccessorFunc(PANEL, "fadeDuration", "FadeDuration", FORCE_NUMBER)

local function PaintMarkupOverride(text, font, x, y, color, alignX, alignY, alpha)
	alpha = alpha or 255

	if (ix.option.Get("chatOutline", false)) then
		-- outlined background for even more visibility
		draw.SimpleTextOutlined(text, font, x, y, ColorAlpha(color, alpha), alignX, alignY, 1, Color(0, 0, 0, alpha))
	else
		-- background for easier reading
		surface.SetTextPos(x + 1, y + 1)
		surface.SetTextColor(0, 0, 0, alpha)
		surface.SetFont(font)
		surface.DrawText(text)

		surface.SetTextPos(x, y)
		surface.SetTextColor(color.r, color.g, color.b, alpha)
		surface.SetFont(font)
		surface.DrawText(text)
	end
end

function PANEL:Init()
	self.text = ""
	self.alpha = 255
	self.fadeDelay = 15
	self.fadeDuration = 5
end

function PANEL:SetMarkup(text)
	self.text = text

	self.markup = ix.markup.Parse(self.text, self:GetWide())
	self.markup.onDrawText = PaintMarkupOverride

	self:SetTall(self.markup:GetHeight())
	self:DockMargin(0, 4, 0, 0)

	timer.Simple(self.fadeDelay, function()
		if (!IsValid(self)) then
			return
		end

		self:CreateAnimation(self.fadeDuration, {
			index = 3,
			target = {alpha = 0}
		})
	end)
end

function PANEL:PerformLayout(width, height)
	if ((IsValid(ix.gui.chat) and ix.gui.chat.bSizing) or width == self.markup:GetWidth()) then
		return
	end

	self.markup = ix.markup.Parse(self.text, width)
	self.markup.onDrawText = PaintMarkupOverride

	self:SetTall(self.markup:GetHeight())
end

-- idk why helix hard coded the fucking chat colors rather than defining them in the chat classes themselves
local chatClassesBackgrounds = {
	["announce"] = "0,134,217",
	["event"] = "255,150,0",
	["help"] = "255,255,0", -- response as well
	["pm"] = "255,100,0"
}

function PANEL:Paint(width, height)
	local newAlpha

	-- we'll want to hide the chat while some important menus are open
	if (IsValid(ix.gui.characterMenu)) then
		newAlpha = math.min(255 - ix.gui.characterMenu.currentAlpha, self.alpha)
	elseif (IsValid(ix.gui.menu)) then
		newAlpha = math.min(255 - ix.gui.menu.currentAlpha, self.alpha)
	elseif (ix.gui.chat:GetActive()) then
		newAlpha = math.max(ix.gui.chat.alpha, self.alpha)
	else
		newAlpha = self.alpha
	end

	if (newAlpha < 1) then
		return
	end

	for chatClass, chatColor in pairs(chatClassesBackgrounds) do
		if self.text:find("color="..chatColor) then
			local r, g, b = chatColor:match("([^,]+),([^,]+),([^,]+)")
			surface.SetDrawColor(ColorAlpha(Color(r, g, b), 50))
			surface.DrawRect(0, 0, width, height)
		end
	end

	self.markup:draw(0, 0, nil, nil, newAlpha)
end

vgui.Register("ixChatMessage", PANEL, "Panel")
