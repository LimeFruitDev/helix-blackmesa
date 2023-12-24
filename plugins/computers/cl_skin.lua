local PLUGIN = PLUGIN

-- Source: NutScript Framework Skin

local SKIN = {}

SKIN.fontFrame = "BudgetLabel"
SKIN.fontTab = "ixSmallFont"
SKIN.fontButton = "ixSmallFont"

SKIN.Colours = table.Copy(derma.SkinList.Default.Colours)

SKIN.Colours.Window.TitleInactive = Color(0, 0, 0)
SKIN.Colours.Window.TitleActive = Color(255, 255, 255)

SKIN.MainColor = Color(100, 100, 100, 200)
SKIN.BackgroundColor = Color(45, 45, 45, 240)

SKIN.Colours.Button.Normal = Color(80, 80, 80)
SKIN.Colours.Button.Hover = Color(255, 255, 255)
SKIN.Colours.Button.Down = Color(180, 180, 180)
SKIN.Colours.Button.Disabled = Color(0, 0, 0, 100)

if Schema.christmas then
	SKIN.Colours.Window.TitleInactive = Color(0, 0, 0)
	SKIN.Colours.Window.TitleActive = Color(255, 255, 255)

	SKIN.MainColor = Color(200, 0, 0, 255)
	SKIN.BackgroundColor = Color(0, 100, 0, 200)

	SKIN.Colours.Button.Normal = Color(80, 80, 80)
	SKIN.Colours.Button.Hover = Color(255, 255, 255)
	SKIN.Colours.Button.Down = Color(180, 180, 180)
	SKIN.Colours.Button.Disabled = Color(0, 0, 0, 100)
end

function SKIN:PaintFrame(panel)
	ix.util.DrawBlur(panel, 10)

	surface.SetDrawColor(SKIN.BackgroundColor)
	surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

	surface.SetDrawColor(SKIN.MainColor)
	surface.DrawRect(0, 0, panel:GetWide(), 24)

	surface.SetDrawColor(SKIN.MainColor)
	surface.DrawOutlinedRect(0, 0, panel:GetWide(), panel:GetTall())
end

function SKIN:DrawGenericBackground(x, y, w, h)
	surface.SetDrawColor(SKIN.BackgroundColor)
	surface.DrawRect(x, y, w, h)

	surface.SetDrawColor(0, 0, 0, 180)
	surface.DrawOutlinedRect(x, y, w, h)

	surface.SetDrawColor(100, 100, 100, 25)
	surface.DrawOutlinedRect(x + 1, y + 1, w - 2, h - 2)
end

function SKIN:PaintPanel(panel)
	if (panel:GetPaintBackground()) then
		local w, h = panel:GetWide(), panel:GetTall()

		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(0, 0, w, h)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
end

function SKIN:PaintButton(panel)
	if (panel:GetPaintBackground()) then
		local w, h = panel:GetWide(), panel:GetTall()
		local alpha = 180

		if (panel:GetDisabled()) then
			alpha = 10
		elseif (panel.Depressed) then
			alpha = 180
		elseif (panel.Hovered) then
			alpha = 75
		end

		surface.SetDrawColor(230, 230, 230, alpha)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(0, 0, 0, 180)
		surface.DrawOutlinedRect(0, 0, w, h)

		surface.SetDrawColor(180, 180, 180, 2)
		surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
	end
end

function SKIN:PaintWindowMinimizeButton( panel, w, h )
end

function SKIN:PaintWindowMaximizeButton( panel, w, h )
end

derma.DefineSkin("ComputerSkin", "ComputerBaseSkin", SKIN)
