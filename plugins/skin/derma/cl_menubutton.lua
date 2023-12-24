local animationTime = 0.25
local animationTimeHalf = animationTime/2

-- base menu button
DEFINE_BASECLASS("DButton")
local PANEL = {}

AccessorFunc(PANEL, "backgroundColor", "BackgroundColor")
AccessorFunc(PANEL, "backgroundAlpha", "BackgroundAlpha")

function PANEL:Init()
	self:SetFont("LimeFruit.Fonts.MenuButton")
	self:SetTextColor(color_white)
	self:SetPaintBackground(false)
	self:SetContentAlignment(5) -- 4 = left, 5 = center

	self.padding = {32, 8, 32, 8} -- left, top, right, bottom
	self.backgroundColor = Color(0, 0, 0, 150)
	self.backgroundAlpha = 255
	self.currentBackgroundAlpha = 0

	self.textInsetWidth = 0
	self.textInsetHeight = 2
	self.currentTextInsetWidth = self.textInsetWidth
	self.currentTextInsetHeight = self.textInsetHeight
	self:SetTextInset(self.textInsetWidth, self.textInsetHeight)

	self.gradientColor_original = Color( 0, 212, 107, 200 )
	self.gradientColor = Color( 0, 212, 107, 0 )
end

function PANEL:GetPadding()
	return self.padding
end

function PANEL:SetPadding(left, top, right, bottom)
	self.padding = {
		left or self.padding[1],
		top or self.padding[2],
		right or self.padding[3],
		bottom or self.padding[4]
	}
end

function PANEL:SetText(text, noTranslation, noUppercase)
	BaseClass.SetText(self, noUppercase and text or noTranslation and text:utf8upper() or L(text):utf8upper())
end

function PANEL:SizeToContents()
	BaseClass.SizeToContents(self)

	local width, height = self:GetSize()
	self:SetSize(width + self.padding[1] + self.padding[3], height + self.padding[2] + self.padding[4])
end

function PANEL:PaintBackground(width, height)
	-- ix.skin.PaintGradientBackground(width, height, self.currentBackgroundAlpha * 0.5)

	ix.util.DrawBlur(self)
	surface.SetDrawColor(self.backgroundColor)
	surface.DrawRect(0, 0, width, height)

	-- surface.SetDrawColor(0, 0, 0, 200)
	-- surface.DrawRect(0, height*0.9, width, height*0.1)

	if ( self.CursorIsOn ) then
		self.gradientColor.r = Lerp( 0.05, self.gradientColor.r, self.gradientColor_original.r )
		self.gradientColor.g = Lerp( 0.05, self.gradientColor.g, self.gradientColor_original.g )
		self.gradientColor.b = Lerp( 0.05, self.gradientColor.b, self.gradientColor_original.b )
		self.gradientColor.a = Lerp( 0.05, self.gradientColor.a, self.gradientColor_original.a )
	else
		self.gradientColor.a = Lerp( 0.05, self.gradientColor.a, 0 )
	end

	surface.SetDrawColor( self.gradientColor.r, self.gradientColor.g, self.gradientColor.b, self.gradientColor.a )
	surface.SetMaterial( Material( "gui/center_gradient" ) )
	surface.DrawTexturedRect( 0, height - 1, width, 1 )
end

function PANEL:SetGradientColor( col )
	if IsColor(col) then
		self.gradientColor_original = col
		self.gradientColor = Color( col.r, col.g, col.b, 0 )
	end
end

function PANEL:Paint(width, height)
	self:PaintBackground(width, height)
	BaseClass.Paint(self, width, height)
end

function PANEL:SetTextColorInternal(color)
	BaseClass.SetTextColor(self, color)
	self:SetFGColor(color)
end

function PANEL:SetTextColor(color)
	self:SetTextColorInternal(color)
	self.color = color
end

function PANEL:SetDisabled(bValue)
	local color = self.color

	if (bValue) then
		self:SetTextColorInternal(Color(math.max(color.r - 60, 0), math.max(color.g - 60, 0), math.max(color.b - 60, 0)))
	else
		self:SetTextColorInternal(color)
	end

	BaseClass.SetDisabled(self, bValue)
end

function PANEL:OnCursorEntered()
	if (self:GetDisabled()) then
		return
	end

	self.CursorIsOn = true

	local color = self:GetTextColor()
	self:SetTextColorInternal(Color(math.max(color.r - 25, 0), math.max(color.g - 25, 0), math.max(color.b - 25, 0)))

	self:CreateAnimation(animationTimeHalf, {
		target = {
			currentBackgroundAlpha = self.backgroundAlpha,
			currentTextInsetHeight = self.textInsetHeight - 4
		},
		Think = function(animation, panel)
			panel:SetTextInset(panel.currentTextInsetWidth, panel.currentTextInsetHeight)
		end,
	})

	LocalPlayer():EmitSound("LimeFruit.UI.Rollover")
end

function PANEL:OnCursorExited()
	if (self:GetDisabled()) then
		return
	end

	self.CursorIsOn = false

	if (self.color) then
		self:SetTextColor(self.color)
	else
		self:SetTextColor(color_white)
	end

	self:CreateAnimation(animationTimeHalf, {
		target = {
			currentBackgroundAlpha = 0,
			currentTextInsetHeight = self.textInsetHeight
		},
		Think = function(animation, panel)
			panel:SetTextInset(panel.currentTextInsetWidth, panel.currentTextInsetHeight)
		end,
	})
end

function PANEL:OnMousePressed(code)
	if (self:GetDisabled()) then
		return
	end

	if (self.color) then
		self:SetTextColor(self.color)
	else
		self:SetTextColor(ix.config.Get("color"))
	end

	LocalPlayer():EmitSound("LimeFruit.UI.ClickRelease")

	if (code == MOUSE_LEFT and self.DoClick) then
		self:DoClick(self)
	elseif (code == MOUSE_RIGHT and self.DoRightClick) then
		self:DoRightClick(self)
	end
end

function PANEL:OnMouseReleased(key)
	if (self:GetDisabled()) then
		return
	end

	if (self.color) then
		self:SetTextColor(self.color)
	else
		self:SetTextColor(color_white)
	end
end

vgui.Register("limefruitMenuButton", PANEL, "DButton")
