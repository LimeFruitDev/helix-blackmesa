
ix.event.Register("Screen Shake", {
	description = "Shakes the screen of all players.",
	customNotify = true,
	OnRun = function(client, args)
		if (!args[2]) then
			client:Notify("Missing first argument. Valid: <time Seconds> [Shake strength] [Shake frequency] [Vector x] [Vector y] [Vector z] [Radius].")
			return
		end

		util.ScreenShake(Vector(args[5] or 0, args[6] or 0, args[7] or 0), args[3] or 5, args[4] or 5, args[2], args[8] or 9999999)

		client:Notify("Triggered event Screen Shake.")
	end
})
