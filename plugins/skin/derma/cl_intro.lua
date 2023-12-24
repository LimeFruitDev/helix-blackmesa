DEFINE_BASECLASS("EditablePanel")

local PANEL = {}

function PANEL:Init()
	if (IsValid(ix.gui.intro)) then
		ix.gui.intro:Remove()
	end

	ix.gui.intro = self
end

function PANEL:Think()
	if (IsValid(LocalPlayer())) then
		self:BeginIntro()
		self.Think = nil
	end
end

function PANEL:BeginIntro()
	local bLoaded = false

	if (ix and ix.option and ix.option.Set) then
		local bSuccess, _ = pcall(ix.option.Set, "showIntro", false)
		bLoaded = bSuccess
	end

	if (!bLoaded) then
		self:Remove()

		if (ix and ix.gui and IsValid(ix.gui.characterMenu)) then
			ix.gui.characterMenu:Remove()
		end

		ErrorNoHalt(
			"[Helix] Something has errored and prevented the framework from loading correctly - check your console for errors!\n")

		return
	end

	self:Remove()
end

function PANEL:OnRemove()
	hook.Run("CreateTutorial")
end

vgui.Register("ixIntro", PANEL, "EditablePanel")
