--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN
local playerMeta = playerMeta or FindMetaTable("Player")

PLUGIN.name = "Extensions"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Adds custom functions we felt the framework was missing."

-- Convert first character in a string to uppercase
function string.FirstToUpper( str )
    return str:gsub("^%l", string.upper)
end

if (SERVER) then
	function ix.chat.PrintChat(audience, ...)
		netstream.Start(audience, "ixChatPrintChat", {...});
	end
else
	-- Prints chat messages containing multiple arguments with color
	netstream.Hook("ixChatPrintChat", function(data)
		chat.AddText(unpack(data))
	end)

	-- Draws a blurred rectangle.
	local blur = blur or Material("pp/blurscreen")
	function surface.DrawBlurRect(x, y, w, h, amount, heavyness, alpha)
		local X, Y = 0,0
		local scrW, scrH = ScrW(), ScrH()

		surface.SetDrawColor(255,255,255,alpha)
		surface.SetMaterial(blur)

		for i = 1, heavyness do
			blur:SetFloat("$blur", (i / 3) * (amount or 6))
			blur:Recompute()

			render.UpdateScreenEffectTexture()

			render.SetScissorRect(x, y, x+w, y+h, true)
				surface.DrawTexturedRect(X * -1, Y * -1, scrW, scrH)
			render.SetScissorRect(0, 0, 0, 0, false)
		end
	end

	-- Create clientside prop with physics
	function ClientsidePhysicsModel(modelpath, pos)
		if(!modelpath || !pos) then return end
		local prop = ents.CreateClientProp(modelpath)
		if (!IsValid(prop)) then return end
		prop:SetModel(modelpath)
		prop:SetPos(pos)
		prop:Spawn()
		prop:PhysicsInit(SOLID_VPHYSICS)
		prop:SetSolid(SOLID_NONE)
		prop:SetMoveType(MOVETYPE_VPHYSICS)
		return prop
	end
end

-- Timer based upon SysTime
RealTimer = {}
RealTimer.Tasks = {}

function RealTimer.Simple(time, func)
	local task = {}
	task.End = time + SysTime()
	task.Func = func
	table.insert(RealTimer.Tasks, task)
end

hook.Add("Think", "RealTimerThink", function()
	local removelist = {}
	local currentTime = SysTime()
	for k, v in pairs(RealTimer.Tasks) do
		if (v.End <= currentTime) then
			local status, error = pcall(v.Func)
			if (!status) then
				MsgN(error)
			end
			table.insert(removelist, v)
		end
	end
	for k, v in pairs(removelist) do
		table.remove(RealTimer.Tasks, table.KeyFromValue(RealTimer.Tasks, v))
	end
end)

-- Play a sound
function SoundPlay(snd, pos, lvl, pitch, vol, ply)
	if (!snd || type(snd) != "string") then return end
	if (!pos || type(pos) != "Vector") then return end
	if (!lvl || type(lvl) != "number") then lvl = 75 end
	if (!pitch || type(pitch) != "number") then pitch = 100 end
	if (!vol || type(vol) != "number") then vol = 1 end
	if (SERVER) then
		net.Start("limefruit_soundplay")
		net.WriteStringTable(snd)
		net.WriteVector(pos)
		net.WriteUInt(lvl, 8)
		net.WriteUInt(pitch, 8)
		net.WriteFloat(vol)
		net.SendOmit({ ply })
	else
		if (vol > 1) then
			for i = 0, vol do
				sound.Play(snd, pos, lvl, pitch, 1)
			end
		else
			sound.Play(snd, pos, lvl, pitch, vol)
		end
	end
end

if (SERVER) then
	util.AddNetworkString("limefruit_soundplay")
else
	net.Receive("limefruit_soundplay", function(len)
		local str = net.ReadStringTable()
		SoundPlay(str, net.ReadVector(), net.ReadUInt(8), net.ReadUInt(8), net.ReadFloat())
	end)
end
