--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

ix.computers = ix.computers or {}

local PLUGIN = PLUGIN

PLUGIN.name = "Computers"
PLUGIN.description = "Adds an interactive computer system."
PLUGIN.author = "Zoephix"

PLUGIN.config = {}

ix.util.Include("cl_skin.lua")
ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

if SERVER then
	-- download programs
	local files = file.Find( PLUGIN.folder .. "/programs/sh_*.lua", "LUA" )
	for k, v in pairs(files) do
		AddCSLuaFile(PLUGIN.folder .. "/programs/" .. v)
	end

	-- include programs
	local files = file.Find( PLUGIN.folder .. "/programs/*.lua", "LUA" )
	for k, v in pairs(files) do
		include("programs/" .. v)
	end
else
	-- include programs
	local files = file.Find(PLUGIN.folder .. "/programs/sh_*.lua", "LUA" )
	for k, v in pairs(files) do
		include("programs/"..v)
	end
end

// = = = = = = = = = = = = = = = = = = = = = = = =
// 
//	Meta
//
// = = = = = = = = = = = = = = = = = = = = = = = =

local playerMeta = FindMetaTable("Player")

function playerMeta:GetUsername()
	local name = string.Explode(" ", self:GetName())

	if #name == 1 then
		return string.lower(name[1])
	elseif #name == 3 then
		return string.lower(string.sub(name[1], 1, 3) .. string.sub(name[3], 1, 3))
	else
		return string.lower(string.sub(name[1], 1, 3) .. string.sub(name[2], 1, 3))
	end
end

function playerMeta:GetComputer()
	return self:GetNetVar("computer")
end

function playerMeta:SetComputer(computer)
	self:SetNetVar("computer", computer)
end

function playerMeta:IsUsingComputer()
	return self:GetNetVar("useComputer", false)
end

// = = = = = = = = = = = = = = = = = = = = = = = =
// 
//	Functions
//
// = = = = = = = = = = = = = = = = = = = = = = = =

function PLUGIN:GetUsername(name)
	local name = string.Explode(" ", name)

	if #name == 1 then
		return string.lower(name[1])
	elseif #name == 3 then
		return string.lower(string.sub(name[1], 1, 3) .. string.sub(name[3], 1, 3))
	else
		return string.lower(string.sub(name[1], 1, 3) .. string.sub(name[2], 1, 3))
	end
end

if CLIENT then
	function PLUGIN:LoadFonts()
		surface.CreateFont("LimeFruit.Computers.Small", {
			font = "Tahoma",
			size = 13
		})
	end
end
