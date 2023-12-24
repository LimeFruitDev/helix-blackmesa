local PANEL = {}

function PANEL:Init()
	-- tabs
	self.menu = self:Add("DPanel")
	self.menu:SetWidth(ScrW())
	self.menu:SetTall(80)
	self.menu.buttons = {}
	self.menu.Paint = function(this, width, height)
		surface.SetDrawColor(32, 32, 32, 240)
	    surface.DrawRect(0, 0, width, height)
	    surface.SetDrawColor(Schema.color)
	    surface.DrawRect(0, height - 8, width, 8)
	end

	self.tabs = self.menu:Add("DPanel")
	self.tabs:SetTall(self.menu:GetTall())
	self.tabs.Paint = function(this, width, height)
		
	end
end

function PANEL:Paint(width, height)
	return
end

vgui.Register("ixMenuNew", PANEL, "DPanel")

-- tab button
DEFINE_BASECLASS("DButton")
local PANEL = {}

AccessorFunc(PANEL, "backgroundColor", "BackgroundColor")
AccessorFunc(PANEL, "selected", "Selected", FORCE_BOOL)

function PANEL:Init()
	self:SetFont("LimeFruit.Fonts.TabButton")
	self:SetContentAlignment(5)
	self.padding = {32, 0, 0, 0} -- left, top, right, bottom
	self:SetTextInset(self.padding[1] * 2, 0, 0, 0)

	self.backgroundColor = color_white
	self.selected = false
	self.sectionPanel = nil -- sub-sections this button has; created only if it has any sections
	self.animation = nil
	self.animationTime = .5
	self.animationHeight = 0
end

function PANEL:Paint(width, height)
	if (self.selected) then
		surface.SetDrawColor(Schema.color)
		surface.DrawRect(0, 0, width, height)
	end

	if (self.animationHeight > 0) then
		surface.SetDrawColor(Schema.color)
		surface.DrawRect(0, height - self.animationHeight, width, height)
	end
end

function PANEL:PaintBackground(width, height)
end

function PANEL:SetSelected(bValue, bSelectedSection)
	self.selected = bValue

	if (bValue) then
		self:OnSelected()

		if (self.sectionPanel) then
			self.sectionPanel:Show()
		elseif (self.sectionParent) then
			self.sectionParent.sectionPanel:Show()
		end
	elseif (self.sectionPanel and self.sectionPanel:IsVisible() and !bSelectedSection) then
		self.sectionPanel:Hide()
	end
end

function PANEL:OnCursorEntered()
	LocalPlayer():EmitSound("LimeFruit.UI.Rollover")

	local panelWidth, panelHeight = self:GetSize()

	if self.animation then
		self.animation:ForceComplete()
	end

	self.animation = self:CreateAnimation(self.animationTime, {
		target = {animationHeight = panelHeight},
		easing = "outQuint"
	})
end

function PANEL:OnCursorExited()
	if self.animation then
		self.animation:ForceComplete()
	end

	self.animation = self:CreateAnimation(self.animationTime, {
		target = {animationHeight = 0},
		easing = "outQuint"
	})
end

function PANEL:OnMousePressed(code)
	self:SetSelected(true)
	LocalPlayer():EmitSound("LimeFruit.UI.ClickRelease")
	self:DoClick()
end

function PANEL:OnSelected()
end

vgui.Register("LimeFruit.UI.TabButton", PANEL, "DButton")
