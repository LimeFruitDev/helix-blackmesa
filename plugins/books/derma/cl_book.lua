local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetBackgroundBlur(true);
	self:SetDeleteOnClose(false);
	self:SetSize(ScrW() * 0.15, ScrH() * 0.35)
	self:MakePopup()
	self:Center()
	
	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		self:Close();
		self:Remove();
		
		gui.EnableScreenClicker(false);
	end;
end;
-- A function to populate the panel.
function PANEL:Populate(itemTable)
	if (!itemTable) then
		return
	end

	self:SetTitle(itemTable.name);

	itemTable.bookInformation = string.gsub( string.gsub(itemTable.bookInformation, "\n", "<br>"), "\t", string.rep("&nbsp;", 4) );
	itemTable.bookInformation = "<html><body bgcolor='#ffffff'><font face='Arial' size='2'>"..itemTable.bookInformation.."</font></body></html>";
	
	self.htmlPanel = self:Add("HTML");
	self.htmlPanel:SetHTML(itemTable.bookInformation);
	self.htmlPanel:SetWrap(true);
	self.htmlPanel:Dock(FILL)
	
	self.button = self:Add("DButton");
	self.button:SetText("Close");
	self.button:Dock(BOTTOM)
	self.button:DockMargin(0, 4, 0, 0)
	
	-- Called when the button is clicked.
	function self.button.DoClick(button)
		self:Close();
		self:Remove();
		
		gui.EnableScreenClicker(false);
	end;
	
	gui.EnableScreenClicker(true);
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	if (!IsValid(self.htmlPanel)) then
		return
	end

	DFrame.PerformLayout(self);
end;

vgui.Register("ixLimeFruitViewBook", PANEL, "DFrame");
