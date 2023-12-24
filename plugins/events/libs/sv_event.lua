ix.event = ix.event or {}
ix.event.list = ix.event.list or {}

function ix.event.Register(eventName, eventData)
	local fixedEventName = eventName:gsub("%s+", "")

	--[[ if (istable(ix.event.list[fixedEventName])) then
		ErrorNoHalt("[ixEvent] Attempted to add another event with the name \"" .. fixedEventName .. "\"! Not adding.\n")
		return
	end ]]

	ix.event.list[fixedEventName] = {
		name = eventName,
		description = eventData.description and eventData.description or "[No description]",
		customNotify = eventData.customNotify or false,
		OnRun = eventData.OnRun or function(client, args)
			client:Notify("This event is not available.")
		end
	}
end

function ix.event.Run(eventName, activator, arguments)
	local fixedEventName = eventName:gsub("%s+", ""):lower()

	for name, data in pairs(ix.event.list) do
		if (name:lower() == fixedEventName) then
			data.OnRun(activator, arguments)

			if (activator and !data.customNotify) then
				activator:Notify("Triggered event " .. name .. ".")
				return
			end
		end
	end

	ErrorNoHalt("[ixEvent] Couldn't find event \"" .. eventName .. "\"!\n")
end

function ix.event.FireMapEntity(name, input, param, delay, activator, caller)
	for k, v in pairs(ents.FindByName(name)) do
		v:Fire(input, param, delay, activator, caller)
	end
end

function ix.event.PlayGlobalSound(path)
	for _, v in pairs(player.GetAll()) do
		v:SendLua("surface.PlaySound( \"" .. path .. "\" )")
	end
end

function ix.event.ScreenFade(enumScreenFade, colorScreenFade, fadeTime, fadeHold)
	for _, v in pairs(player.GetAll()) do
		v:ScreenFade(enumScreenFade, colorScreenFade, fadeTime, fadeHold)
	end
end

function ix.event.SpawnParticleSystem(name, pos, removeTime)
	PrecacheParticleSystem(name)
	util.PrecacheModel("models/props_junk/popcan01a.mdl")
	netstream.Start(player.GetAll(), "eventSpawnParticleSystem", name, pos)
	
	if removeTime then
		timer.Simple(removeTime, function()
			netstream.Start(player.GetAll(), "eventRemoveParticleSystem", name)
		end)
	end
end

function ix.event.RemoveParticleSystem(name)
	netstream.Start(player.GetAll(), "eventRemoveParticleSystem", name)
end

function ix.event.ColorModify()
	netstream.Start(player.GetAll(), "eventColorModify")
end

function ix.event.ColorModifyRemove()
	netstream.Start(player.GetAll(), "eventColorModifyRemove")
end

function ix.event.SetMapLightStyle(lightStyle, bUpdateStaticProps, bUpdateStaticLighting)
	engine.LightStyle(0, lightStyle)
	BroadcastLua(string.format("render.RedownloadAllLightmaps(%s, %s)", bUpdateStaticProps and "true" or "false", bUpdateStaticLighting and "true" or "false"))
end
