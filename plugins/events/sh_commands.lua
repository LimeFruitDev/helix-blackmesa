--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

ix.command.Add("TriggerEvent", {
	staffOnly = true,
	description = "Trigger a map/script event.",
	OnRun = function(self, client, args)
		if (#args == 0) then
			client:Notify("Missing argument.")
			return
		end

		ix.event.Run(args[1]:lower(), client, args)

		if (SERVER) then
			ix.log.AddRaw(client:Name().." has triggered event '"..args[1].."'", FLAG_WARNING)
		end
	end
})

ix.command.Add("ListEvents", {
	staffOnly = true,
	description = "Lists available events.",
	OnRun = function(self, client, args)
		client:ChatPrint("List of available events:")

		for name, data in pairs(ix.event.list) do
			client:ChatPrint(string.format("%s - %s", name, data.description))
		end
	end
})
