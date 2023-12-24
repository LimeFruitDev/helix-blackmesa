
ix.event.Register("Comms Fail", {
	description = "Toggles Communication Servers Failure.",
	customNotify = true,
	OnRun = function(client)
		SetGlobalBool("comFailed", !GetGlobalBool("comFailed", false))

		if (client) then
			client:Notify("New Comms Status: " ..(GetGlobalBool("comFailed") == true and "Offline" or "Online"))
		end
	end
})
