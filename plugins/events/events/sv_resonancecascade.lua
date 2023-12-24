
local whitelist = {
}

ix.event.Register("Resonance Cascade", {
	description = "The end of times.",
	customNotify = true,
	OnRun = function(client, args)
		local event = args[2]:lower()
		
		if (!event) then
			client:Notify("Missing argument. Valid: explosion.")
			return
		end
		
		if event == "explosion" then
			ix.event.SpawnParticleSystem("xen_portal_large", Vector(-4089.514404, 607.051025, 5877.077148), 1)
			ix.event.PlayGlobalSound("bms_objects/portal/portal_in_01.wav")
			util.ScreenShake(Vector(0, 0, 0), 5, 5, 5, 9999999)
			
			ix.event.ColorModify()
			
			timer.Simple(2.5, function()
				ix.event.ColorModifyRemove()
			end)
		end
	end
})
