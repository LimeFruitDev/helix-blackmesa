
ix.event.Register("AMS Power Box", {
	description = "Destroys or repairs the AMS power box.",
	customNotify = true,
	OnRun = function(client, args)
		if (!args[2]) then
			client:Notify("Missing argument. Valid: explode, fix.")
			return
		end

		if (args[2]:lower() == "explode") then
			client:Notify("You have made the AMS power box explode.")
			ents.FindByName("ams_power_explode")[1]:Fire("Trigger", "", 0)
		elseif (args[2]:lower() == "fix") then
			client:Notify("You have fixed the AMS power box.")
			ents.FindByName("ams_power_fix")[1]:Fire("Trigger", "", 0)
		end
	end
})
