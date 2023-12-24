
ix.event.Register("Earthquake", {
	description = "Makes an earthquake.",
	OnRun = function()
		util.ScreenShake(Vector(0, 0, 0), 20, 20, 8, 999999999)

		for _, client in pairs(player.GetAll()) do
			client:ConCommand("play ambient/atmosphere/terrain_rumble1.wav")
		end
	end
})
