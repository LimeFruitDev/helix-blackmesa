
local skinTypes = {
	["reset"] = 5,
	["bluescreen"] = 4,
	["off"] = 0
}

ix.event.Register("Computer Screens", {
	description = "Reset, off or bluescreen the facility computers.",
	customNotify = true,
	OnRun = function(client, args)
		local skinType = skinTypes[args[2]]

		if (!skinType) then
			client:Notify("Missing argument. Valid: reset, off, bluescreen.")
			return
		end

		local entAllComputers = table.Add(ents.FindByModel("models/props_office/computer_monitor01.mdl"), ents.FindByModel("models/props_office/computer_monitor04.mdl"))

		for k, v in pairs(entAllComputers) do
			v:SetSkin(skinType)
		end

		client:Notify("Set computer screens to " .. args[2] .. ".")
	end
})
