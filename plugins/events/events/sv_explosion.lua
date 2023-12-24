
ix.event.Register("Explosion", {
	description = "Makes the screen shake alongside with a global explosion sound.",
	OnRun = function()
		util.ScreenShake(Vector(0, 0, 0), 20, 20, 8, 999999999)

		for _, client in ipairs(player.GetAll()) do
			client:ConCommand("play ambient/machines/wall_crash1.wav")
		end
	end
})
