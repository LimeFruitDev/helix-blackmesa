local PLUGIN = PLUGIN

ix.bar.Add(function()
	local character = LocalPlayer():GetCharacter()

	if !character then return 0 end

	local hunger = character:GetData("hunger", 0)

	if (!PLUGIN.hunger) then
		PLUGIN.hunger = hunger
	else
		PLUGIN.hunger = math.Approach(PLUGIN.hunger, hunger, 1)
	end

	local text, color = PLUGIN:GetHungerText(PLUGIN.hunger)

	return PLUGIN.hunger/100, text
end, Color(100, 200, 0), nil, "hunger")

ix.bar.Add(function()
	local character = LocalPlayer():GetCharacter()

	if !character then return 0 end

	local thirst = character:GetData("thirst", 0)

	if (!PLUGIN.thirst) then
		PLUGIN.thirst = thirst
	else
		PLUGIN.thirst = math.Approach(PLUGIN.thirst, thirst, 1)
	end

	local text, color = PLUGIN:GetThirstText(PLUGIN.thirst)

	return PLUGIN.thirst/100, text
end, Color(0, 170, 215), nil, "thirst")

function PLUGIN:CreateCharacterInfo(panel)
	if (panel) then
		panel.hunger = panel:Add("ixListRow")
		panel.hunger:SetList(panel.list)
		panel.hunger:Dock(TOP)
		panel.hunger:SizeToContents()

		panel.thirst = panel:Add("ixListRow")
		panel.thirst:SetList(panel.list)
		panel.thirst:Dock(TOP)
		panel.thirst:SizeToContents()
	end
end

function PLUGIN:UpdateCharacterInfo(panel)
	if (panel.hunger) then
		panel.hunger:SetLabelText("Hunger")

		local hunger = LocalPlayer():GetChar():GetData("hunger", 0)

		if (!self.hunger) then
			self.hunger = hunger
		else
			self.hunger = math.Approach(self.hunger, hunger, 1)
		end

		local text = self:GetHungerText(self.hunger)

		panel.hunger:SetText(text.." ["..math.Round(self.hunger).."%]")
	end

	if (panel.thirst) then
		panel.thirst:SetLabelText("Thirst")

		local thirst = LocalPlayer():GetChar():GetData("thirst", 0)

		if (!self.thirst) then
			self.thirst = thirst
		else
			self.thirst = math.Approach(self.thirst, thirst, 1)
		end

		local text = self:GetThirstText(self.thirst)

		panel.thirst:SetText(text.." ["..math.Round(self.thirst).."%]")
	end
end

local viewbluralpha = 0
function PLUGIN:RenderScreenspaceEffects()
	if !(PLUGIN.hunger or PLUGIN.thirst) then
		return
	end

	local frametime = RealFrameTime()

	if (PLUGIN.hunger > 80 or PLUGIN.thirst > 80) then
		viewbluralpha = Lerp(frametime / 2, viewbluralpha, 10)
	else
		viewbluralpha = Lerp(frametime / 2, viewbluralpha, 0)
	end

	DrawMotionBlur(math.Clamp((10-viewbluralpha)*0.1, 0.1, 1), 1, 0)
end
