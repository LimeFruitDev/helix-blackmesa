local PLUGIN = PLUGIN

PLUGIN.name = "No Command Cooldown"
PLUGIN.author = "LimeFruit Dev Team"
PLUGIN.description = "Removes the command cooldown from certain users."

if (SERVER) then
	local ignoreCommandCooldown = {
	}

	local ixCommandRun = ix.command.Run
	function ix.command.Run(client, command, arguments)
		if (ignoreCommandCooldown[client:SteamID()]) then
			client.ixCommandCooldown = 0
		end

		return ixCommandRun(client, command, arguments)
	end
end
