
ix.event.Register("Screen Fade", {
	description = "Fades the screen of all players.",
	customNotify = true,
	OnRun = function(client, args)
		local fadeTime = args[2]
		local holdTime = args[3]

		if (!fadeTime or !holdTime) then
			client:Notify("Missing arguments. Valid: <fade Time Seconds> <hold Time Seconds>.")
			return
		end

		BroadcastLua([[
			LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), ]]..fadeTime..[[, ]]..holdTime..[[)
		]])

		BroadcastLua([[
			timer.Simple(]]..fadeTime..[[ + ]]..holdTime..[[, function()
				LocalPlayer():ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), ]]..fadeTime..[[, 1)
			end)
		]])
	end
})
