--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

PLUGIN.validModels = {
	["models/props_office/computer_monitor01.mdl"] = true,
	["models/props_office/computer_monitor02.mdl"] = true,
	["models/props_office/computer_monitor03.mdl"] = true,
	["models/props_office/computer_monitor04.mdl"] = true
}

-- replace monitors with a working entity
function PLUGIN:InitPostEntity()
	for model, _ in pairs(self.validModels) do
		for _, monitor in pairs(ents.FindByModel(model)) do
			local computer = ents.Create("computer")
			computer:SetPos(monitor:GetPos())
			computer:SetAngles(monitor:GetAngles())
			computer:SetModel(monitor:GetModel())
			computer:SetSkin(5)
			computer:SetMoveType(MOVETYPE_NONE)
			computer:Spawn()

			local physicsObject = computer:GetPhysicsObject()

			if IsValid(physicsObject) then
				physicsObject:EnableMotion(false)
			end

			monitor:Remove()
		end
	end
end

-- when player spawns a monitor replace with a working entity
function PLUGIN:PlayerSpawnedProp(ply, model, entity)
	if self.validModels[model] then
		local computer = ents.Create("computer")
		computer:SetPos(entity:GetPos())
		computer:SetAngles(entity:GetAngles())
		computer:SetModel(model)
		computer:SetSkin(5)
		computer:Spawn()
		computer:SetNetVar("spawner", ply)
		entity:Remove()

		undo.Create("Computer")
			undo.AddEntity(computer)
			undo.SetPlayer(ply)
		undo.Finish()
	end
end

-- prevent computer entity from breaking
function PLUGIN:EntityTakeDamage(entity, dmginfo)
	if self.validModels[entity:GetModel()] then
		dmginfo:SetDamage(0)
	end
end

-- player use determination
function PLUGIN:KeyPress(ply, key)
	if key ~= IN_USE then return end

	local computer = ply:GetEyeTrace().Entity
	if not IsValid(computer) then return end
	if not self.validModels[computer:GetModel()] then return end
	if computer:GetClass() ~= "computer" then return end
	if ply:GetPos():DistToSqr(computer:GetPos()) > 10000 then return end

	local angDiff = math.AngleDifference(computer:GetAngles().y, ply:GetAngles().y)
	if angDiff > -120 and angDiff < 130 then return end

	if computer:IsAuthorized() and IsValid(computer:GetUser()) and computer:GetUser() ~= ply then
		ply:Notify("This computer is already being used.")
		return
	end

	if IsValid(ply:GetComputer()) then
		ply:GetComputer():SetUser(nil)
	end

	if timer.Exists(ply:GetName() .. "computerLeaveTimer") then
		timer.Remove(ply:GetName() .. "computerLeaveTimer")
	end

	if computer:IsBluescreened() then
		if ply:GetCharacter():GetFaction() == FACTION_MAINTENANCE then
			computer:SetSkin(2)
		end

		return
	end

	computer:SetUser(ply)
	ply:SetComputer(computer)
	ply:SetNetVar("useComputer", true)

	netstream.Start(ply, "computerUse", computer)
end

-- switch active state
-- when the startup has completed
-- when the computer was shutdown
netstream.Hook("computerSetActive", function(ply, computer, state)
	if ply:GetComputer() == computer then
		computer:SetSkin(state and 2 or 0)
		computer:SetNetVar("active", state)

		if not state then
			computer:EmitSound("limefruit/bmrp/computers/shutdown.wav", 75)
			computer:SetNetVar("user", nil)
			ply:SetNetVar("computer", nil)
		else
			computer:EmitSound("limefruit/bmrp/computers/startup.wav", 75)
		end
	end
end)

-- authorization
-- when the player does a login or logout
netstream.Hook("computerAuthorize", function(ply, state)
	local computer = ply:GetComputer()

	if computer:GetUser() == ply then
		computer:SetSkin(state and 2 or 5)
		computer:SetNetVar("authorized", state)
	end
end)

-- player leaves computer
netstream.Hook("computerLeave", function(ply, computer)
	-- computer was authorized
	if computer:IsAuthorized() then
		ply:SetNetVar("useComputer", false)
		local timerName = ply:GetName() .. "computerLeaveTimer"
		timer.Create(timerName, 300, 0, function()
			if computer:GetUser() == ply then
				computer:SetSkin(5)
				computer:SetNetVar("user", nil)
				ply:SetNetVar("computer", nil)
				timer.Remove(timerName)
			end
		end)
	else
		computer:SetSkin(5)
		computer:SetNetVar("user", nil)
		ply:SetNetVar("computer", nil)
	end
end)

netstream.Hook("computerMouse", function(ply)
	if ply.computerMouseDelay and CurTime() < ply.computerMouseDelay then return end
	ply.computerMouseDelay = CurTime() + 0.25

	local computer = ply:GetComputer()
	if IsValid(computer) and ply:IsUsingComputer() then
		computer:EmitSound("limefruit/computers/mouse.mp3", 75, math.random(100, 125))
	end
end)
