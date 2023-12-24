netstream.Hook("ixViewPaper", function(itemID, text, bEditable, bIsPaper)
	bEditable = tobool(bEditable)

	local panel = vgui.Create("ixPaper")
	panel:SetTitle(bIsPaper == 1 and "Paper" or "Notepad")
	panel:SetText(text)
	panel:SetEditable(bEditable)
	panel:SetItemID(itemID)
end)
