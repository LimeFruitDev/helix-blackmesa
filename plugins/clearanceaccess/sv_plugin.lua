--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

PLUGIN.scanners = PLUGIN.scanners or {}

util.AddNetworkString("LimeFruit.Clearance.SlideKeycard")

local scannerConfigurations = {
	-- Sector C Extended Beta
	{ entName = "scannerbutton_logingates_1", clearance = "1" }, -- middle access gate at tramplatform - towards facility
	{ entName = "scannerbutton_logingates_2", clearance = "1" }, -- far right access gate at tramplatform - towards facility
	{ entName = "scannerbutton_logoutgates_1", clearance = "1" }, -- leaving facility at tramplatform (only gate)

	-- Sector C Extended
	{ entName = "scannerbutton_logingate_lobby1", clearance = "1" }, -- Lobby access gate
	{ entName = "scannerbutton_logingate_lobby2", clearance = "1" }, -- Lobby access gate
	{ entName = "scannerbutton_logingate_lobby3", clearance = "1" }, -- Lobby access gate
	{ entName = "scannerbutton_logingate_lobby4", clearance = "1" }, -- Lobby access gate
	{ entName = "scannerbutton_logoutgate_lobby1", clearance = "1" }, -- Lobby exit gate
	{ entName = "scannerbutton_logoutgate_lobby2", clearance = "1" }, -- Lobby exit gate

	-- { entName = "scannerbutton_topside_corridor", clearance = "1" }, -- Topside Lab Access (Elevators) In
	-- { entName = "scannerbutton_topside_corridor_2", clearance = "1" }, -- Topside Lab Access (Elevators) Out

	{ entName = "scannerbutton_lab_a_corridor", clearance = "2" }, -- Access from elevators towards labs & security In
	{ entName = "scannerbutton_lab_a_corridor_2", clearance = "2" }, -- Access from elevators towards labs & security Out

	{ entName = "scannerbutton_airlock", clearance = "X" }, -- AMS entrance airlock
	{ entName = "scannerbutton_airlock2", clearance = "X" }, -- AMS exit airlock
	{ entName = "scannerbutton_airlock3", clearance = "X" }, -- AMS blast left
	{ entName = "scannerbutton_airlock4", clearance = "X" }, -- AMS blast right
	{ entName = "scannerbutton_am_handling", clearance = "4B" }, -- access to xenpen - necroscopy; corridor opposite of lab C/D elevator, red lined wall
	{ entName = "scannerbutton_ams_level3_a", clearance = "4" }, -- access to level 3 - ionisation chambers
	{ entName = "scannerbutton_ams_level3_b", clearance = "4" }, -- leaving level 3 - ionisation chambers
	{ entName = "scannerbutton_boio_airl_door_01", clearance = "4B" }, -- access BSL lab airlock (advanced biolab)
	{ entName = "scannerbutton_computerlab", clearance = "2" }, -- access engineering lab - currently under construction
	{ entName = "scannerbutton_containm_lab03", clearance = "3" }, -- access engineering lab from within xenpen corridor
	{ entName = "scannerbutton_controlroom_a", clearance = "5" }, -- enter control room from ionisation chambers
	{ entName = "scannerbutton_controlroom_b", clearance = "5" }, -- exit control room to ionisation chambers
	{ entName = "scannerbutton_controlroom_c", clearance = "5" }, -- exit control room to plasma cells
	{ entName = "scannerbutton_controlroom_d", clearance = "5" }, -- enter control room from plasma cells
	-- { entName = "scannerbutton_corridor_a", clearance = "3" }, -- corridor access from labs A/B to lower labs
	-- { entName = "scannerbutton_corridor_b", clearance = "3" }, -- corridor access from lower labs to A/B
	{ entName = "scannerbutton_lab_03", clearance = "3" }, -- access to engineering lab from lower labs area, under construction
	{ entName = "scannerbutton_lab_a", clearance = "2" }, -- lab A
	{ entName = "scannerbutton_lab_b", clearance = "2" }, -- lab B
	{ entName = "scannerbutton_lab_c", clearance = "2" }, -- lab C
	{ entName = "scannerbutton_lab_c_d_corridor", clearance = "3" }, -- access lab C/D corridor from lab C
	{ entName = "scannerbutton_lab04", clearance = "3B" }, -- access to advanced biology lab
	{ entName = "scannerbutton_lab04_airl_door01", clearance = "4B" }, -- access adv bio lab to handwash station
	{ entName = "scannerbutton_lab04_airl_door03", clearance = "4B" }, -- access adv bio lab handwash to gowning area
	{ entName = "scannerbutton_laba_locker", clearance = "2" }, -- access lab A/B locker from Lab A
	{ entName = "scannerbutton_laba_locker2", clearance = "2" }, -- leave lab A/B locker to lab A
	{ entName = "scannerbutton_labb_locker", clearance = "2" }, -- leave lab A/B locker to lab B
	{ entName = "scannerbutton_labb_locker2", clearance = "2" }, -- access lab A/B locker from lab B
	{ entName = "scannerbutton_security_serverroom", clearance = "S" }, -- access to security server room
	{ entName = "scannerbutton_serverroom", clearance = "5" }, -- access serverroom, next to engineering lab, across of meeting room
	{ entName = "scannerbutton_surg", clearance = "3B" }, -- access to necroscopy
	{ entName = "scannerbutton_doctoroffice_surgery", clearance = "2" }, -- access to medbay offices and surgery room
	{ entName = "scannerbutton_medbaypost", clearance = "S" }, -- access to medbay security post
	{ entName = "emergencybiodoor", clearance = "3S" }, -- access to the medbay lockdown
	
	{ entName = "scannerbutton_HSAL_exit_AM", clearance = "3" }, -- High Security Laboratory Entrance
	{ entName = "scannerbutton_HSAL_entrance_AM", clearance = "3" }, -- High Security Laboratory Entrance
	{ entName = "scannerbutton_HSAL_entrance_HS", clearance = "3" }, -- High Security Laboratory Entrance
	{ entName = "scannerbutton_HSAL_exit_HS", clearance = "3" }, -- High Security Laboratory Entrance
	{ entName = "scannerbutton_HSAL_post", clearance = "S" }, -- High Security Laboratory Entrance - Security Post Access
	{ entName = "scannerbutton_engineerlab", clearance = "3" }, -- Engineering laboratory top access
	{ entName = "scannerbutton_engineerlab_b", clearance = "3" } -- Engineering laboratory bottom access
}

function PLUGIN:SetScannerAttributes( scanner, entName, clearance )
	scanner:SetKeyValue("spawnflags", "1")
	scanner:SetNetVar("name", entName)
	scanner:SetNetVar("clearance", clearance)

	-- for k, v in ipairs(ents.FindInSphere(scanner:GetPos(), 25)) do
	for k, v in ipairs(scanner:GetChildren()) do
		if (v:GetModel() == PLUGIN.ReaderModel) then
			scanner.ReaderModel = v
			scanner:SetNetVar("keycard", true)
		elseif (v:GetModel() == PLUGIN.KeypadModel) then
			scanner.KeypadModel = v
			scanner:SetNetVar("keypad", true)
		end
	end

	table.insert(PLUGIN.scanners, scanner:GetName())
end

function PLUGIN:ConfigureScanners()
	for _, config in ipairs(scannerConfigurations) do
		local entName = config.entName
		local clearance = config.clearance
		for _, scanner in pairs(ents.FindByName(entName)) do
			self:SetScannerAttributes(scanner, entName, clearance)
		end
	end
end

function PLUGIN:Initialize()
	self:ConfigureScanners()
end

function PLUGIN:PlayerInitialSpawn()
	if self.initialized then return end
	self.initialized = true
	self:Initialize()
end

-- Start using the scanner
function PLUGIN:ClearanceStart( status, activator, scanner )
	local clearance = scanner:GetNetVar("clearance")
	local readerSound = status and "granted" or "denied"
	local entName = ix.security.doorNames[string.Replace(scanner:GetNetVar("name", ""), "scannerbutton_", "")]

	-- Fix logs display name
	if (ix.security.doorNames[entName]) then
		entName = ix.security.doorNames[entName]
	end

	if (scanner:GetNetVar("keycard")) then
		netstream.Start(player.GetAll(), "ixClearanceSlideKeycard", scanner, scanner.ReaderModel)
		scanner:EmitSound("limefruit/clearanceaccess/" .. readerSound .. ".wav", 70, 100)

		timer.Simple(0.375, function()
			scanner.ReaderModel:SetSkin(status and 1 or 2)

			if (status) then
				scanner:Fire("Press", "", 2)
			end

			ix.security.AddDoorLog(status, clearance, entName, activator.CrackedKeycard and "Error" or activator:GetName())

			timer.Simple(2, function() scanner.ReaderModel:SetSkin(0) end)
		end)
	elseif (scanner:GetNetVar("keypad")) then
		timer.Create("keypadSound", 0.33, 4, function()
			scanner:EmitSound("buttons/blip1.wav", 70, 100)
		end)

		timer.Simple(1.5, function()
			scanner:EmitSound("buttons/button" .. (status and 3 or 8) .. ".wav", 70, 100)
			scanner.KeypadModel:SetSkin(status and 1 or 2)

			if (status) then
				scanner:Fire("Press", "", 2)
			end

			ix.security.AddDoorLog(status, clearance, entName, activator.CrackedKeycard and "Error" or activator:GetName())

			timer.Simple(2, function() scanner.KeypadModel:SetSkin(0) end)
		end)
	else
		local fixedString = status and "retinal_scanner" or "retinalscanner"
		scanner:EmitSound("bms_objects/doors/" .. fixedString .. "_access_" .. readerSound .. "01.wav", 70, 100)

		if (status) then
			scanner:Fire("Press", "", 2)
		end

		ix.security.AddDoorLog(status, clearance, entName, activator.CrackedKeycard and "Error" or activator:GetName())
	end
end

function PLUGIN:RunCheck( activator, scanner )
	if scanner:GetPos():DistToSqr(activator:GetPos()) > 20000 then return end

	if scanner.delay and CurTime() < scanner.delay then return end
	scanner.delay = CurTime() + 2

	-- Check if the player has a keycard when required.
	local entReader = scanner:GetNetVar("keycard")

	if (entReader) then
		activator.Keycard = false
		activator.CrackedKeycard = false

		for k, v in pairs(activator:GetCharacter():GetInv():GetItems()) do
			if (v.uniqueID == "keycard") then
				activator.Keycard = true
			elseif (v.uniqueID == "cracked_keycard") then
				activator.Keycard = true
				activator.CrackedKeycard = true
			end
		end

		if (!activator.Keycard) then
			activator:Notify("You must have a keycard to open this door." )
			return
		end
	end

	-- Check if the player is using a gate.
	if string.find(scanner:GetNetVar("name", ""), "gate") then
		activator:SetNWBool("OnDuty", !activator:GetNWBool("OnDuty"))
	end

	-- Check the clearances.
	local access = false
	if activator.CrackedKeycard and math.random(1, 5) == 5 then
		access = true
	else
		access = activator:HasClearances(scanner:GetNetVar("clearance"))
	end

	-- Start using the scanner.
	self:ClearanceStart(access, activator, scanner)
end

local approvedChildClasses = {
	["prop_dynamic"] = true,
	["prop_static"] = true,
	["limefruit_btn_override"] = true
}
function PLUGIN:KeyPress( ply, key )
	if (key != IN_USE) then return end

	local ent = ply:GetEyeTrace().Entity

	if (!IsValid(ent)) then return end

	local parent = ent:GetParent()

	if
		ent:GetClass() == "func_button"
		and table.HasValue(self.scanners, ent:GetName())
		or approvedChildClasses[ent:GetClass()]
		and IsValid(parent)
		and parent:GetClass() == "func_button"
		and table.HasValue(self.scanners, parent:GetName())
	then
		self:RunCheck(ply, parent)
	end
end

function PLUGIN:AcceptInput(ent, _, ply)
	if (IsValid(ent:GetParent()) and table.HasValue(self.scanners, ent:GetParent():GetName())) then
		self:RunCheck(ply, ent:GetParent())
		return true
	end
end
