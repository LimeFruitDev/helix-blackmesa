function Schema:LoadFonts(font, genericFont)
	surface.CreateFont("ix3D2DThickFont", {
		font = "Roboto Bold",
		size = 128,
		extended = true,
		weight = 100
	})
end

-- Overwrite hook to hide the class tab
hook.Add("CreateMenuButtons", "ixClasses", function(tabs)
	return
end)

-- Plays character menu music
hook.Add("ClientSignOnStateChanged", "PlayMenuMusic", function(userID, oldState, newState)
	if newState == SIGNONSTATE_FULL then
		RunConsoleCommand("stopsound")

		timer.Simple(0.25, function()
			if IsValid(ix.gui.characterMenu) then
				ix.gui.characterMenu:PlayMusic()
			end
		end)
	end
end)

-- Overwrite ArcCW HUD
if ArcCW then
	function ArcCW:ShouldDrawHUDElement()
		return false
	end
end
