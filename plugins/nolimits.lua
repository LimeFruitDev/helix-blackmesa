
PLUGIN.name = "No Limits"
PLUGIN.author = "SleepyMode"
PLUGIN.description = "Removes traditional sandbox limits for staff."

function PLUGIN:PlayerCheckLimit(client, category, count, limit)
	if (client:IsStaff()) then
		return true
	end
end
