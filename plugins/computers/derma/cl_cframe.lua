local PANEL = {}

AccessorFunc( PANEL, "m_bIsMenuComponent", 		"IsMenu", 			FORCE_BOOL )
AccessorFunc( PANEL, "m_bScreenLock", 			"ScreenLock", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_bDeleteOnClose", 		"DeleteOnClose", 	FORCE_BOOL )
AccessorFunc( PANEL, "m_bPaintShadow", 			"PaintShadow", 		FORCE_BOOL )

AccessorFunc( PANEL, "m_iMinWidth", 			"MinWidth" )
AccessorFunc( PANEL, "m_iMinHeight", 			"MinHeight" )

AccessorFunc( PANEL, "m_bBackgroundBlur", 		"BackgroundBlur", 	FORCE_BOOL )

function PANEL:Init()

	self:SetFocusTopLevel( true )
	self:SetPaintShadow( false )

	self:SetScreenLock( false )
	self:SetDeleteOnClose( true )

	self:SetMinWidth( 50 )
	self:SetMinHeight( 50 )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

	self.m_fCreateTime = SysTime()

	-- self:DockPadding( 5, 30, 5, 5 )

end

function PANEL:ShowCloseButton( bShow )

	self.btnClose:SetVisible( bShow )

end

function PANEL:Close()

	self:SetVisible( false )

	if ( self:GetDeleteOnClose() ) then
		self:Remove()
	end

	self:OnClose()

end

function PANEL:OnClose()

end

function PANEL:Center()

	self:InvalidateLayout( true )
	self:SetPos( ScrW()/2 - self:GetWide()/2, ScrH()/2 - self:GetTall()/2 )

end

function PANEL:IsActive()

	if ( self:HasFocus() ) then return true end
	if ( vgui.FocusedHasParent( self ) ) then return true end

	return false

end

function PANEL:Think()

end

function PANEL:Paint( w, h )

	if ( self.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end

	return true

end

function PANEL:OnMousePressed()

end

function PANEL:OnMouseReleased()

end

function PANEL:PerformLayout()

end

derma.DefineControl( "CFrame", "A simple window", PANEL, "EditablePanel" )
