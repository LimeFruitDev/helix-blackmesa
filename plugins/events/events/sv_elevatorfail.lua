
ix.event.Register("Elevator Fail", {
	description = "Trigger elevator failure.",
	customNotify = true,
	OnRun = function(client, args)
		local elevator = args[2]

		if (!elevator or (elevator != "1" and elevator != "2")) then
			client:Notify("Missing argument. Valid: 1, 2.")
			return
		else
			client:Notify("Triggered event Elevator Fail for elevator " .. elevator .. ".")
		end

		elevator = tonumber(elevator)
		entElevator = ents.FindByName((elevator == 2 and "mb" or "") .. "GC_EV1")[1]

		entElevator:SetNWBool("active", !entElevator:GetNWBool("active", true))
		local elevatorState = entElevator:GetNWBool("active", true)

		local alarm = ents.FindByName("elevator_" .. elevator .. "_klaxon")[1]
		alarm:Fire(elevatorState and "StopSound" or "PlaySound", 0, 0)
		alarm:Fire("Volume", elevatorState and 0 or 100, 0)

		entElevator:Fire("SetSpeed", shouldFix and 100 or 0, 0)

		for i = 1, 2 do
			local elevatorLight = ents.FindByName("elevator_" .. elevator .. "_light")[1]
			local elevatorLights = ents.FindByName("elevator_" .. elevator .. "_lights")[i]
			local elevatorLightsGlow = ents.FindByName("elevator_" .. elevator .. "_lights_glow")[i]

			elevatorLight:Fire("TurnOff", 0, 0)
			elevatorLight:Fire(elevatorState and "Enable" or "Disable", 0, 0)
			elevatorLights:Fire("SetSkin", elevatorState and 1 or 0, 0)
			elevatorLightsGlow:Fire("ColorRedValue", elevatorState and 214 or 255, 0)
			elevatorLightsGlow:Fire("ColorGreenValue", elevatorState and 187 or 0, 0)
			elevatorLightsGlow:Fire("ColorBlueValue", elevatorState and 148 or 0, 0)
		end

		for k, v in pairs(ents.FindByName("m" .. (elevator == 2 and "b" or "") .. "liftbutton*")) do
			v:Fire(elevatorState and "Unlock" or "Lock", 0, 0)
		end
	end
})
