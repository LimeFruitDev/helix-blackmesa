
ix.event.Register("Reception Lights", {
	description = "Toggles reception lights.",
	customNotify = true,
	OnRun = function(client)
		SetGlobalBool("receptionLightsFailed", !GetGlobalBool("receptionLightsFailed", true))

		local status = GetGlobalBool("receptionLightsFailed")

		if (status) then
			ix.event.FireMapEntity("light_reception_trigger_stop", "Trigger", "", 0)
		else
			ix.event.FireMapEntity("light_reception_trigger_start", "Trigger", "", 0)
		end

		if (client) then
			client:Notify("Reception Lights: " ..(status and "On" or "Off"))
		end
	end
})
