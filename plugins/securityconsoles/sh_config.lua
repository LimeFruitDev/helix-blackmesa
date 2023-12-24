--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

ix.security.logcolors = ix.security.logcolors or {
	error = Color( 255, 190, 0 ),
	granted = Color( 100, 255, 100 ),
	security = Color( 100, 100, 255 ),
	lowDenied = Color( 255, 100, 100 ),
	highDenied = Color( 255, 100, 100 )
}

ix.security.doorNames = ix.security.doorNames or {
    ["logingate_lobby1"] = "Lobby Check-in Gate",
    ["logingate_lobby2"] = "Lobby Check-in Gate",
    ["logingate_lobby3"] = "Lobby Check-in Gate",
    ["logingate_lobby4"] = "Lobby Check-in Gate",
    ["logoutgate_lobby1"] = "Lobby Check-out Gate",
    ["logoutgate_lobby2"] = "Lobby Check-out Gate",
    ["securitypost"] = "Security Jail Room",
    ["lab_a_corridor"] = "Door A/B Labs Corridor Access",
    ["lab_a_corridor_2"] = "Door A/B Labs Corridor Exit",
    ["scannerbutton_offices_corridor"] = "Office Elevator Corridor Door",
    ["security_serverroom"] = "Security Hub",
    ["computerlab"] = "Computer Lab Door",
    ["lab_a"] = "Lab A Door",
    ["lab_c"] = "Lab B Door",
    ["lab_c_d_corridor"] = "Door C/D Labs Corridor",
    ["lab04"] = "Lab C Door",
    ["lab_03"] = "Lab D Door",
    ["ams_level3"] = "Level Three Door",
    ["controlroom"] = "AMS Control Room",
    ["controlroomexit"] = "AMS Control Room Exit",
    -- ["corridor_a"] = "Door A/B Labs Corridor",
    -- ["corridor_b"] = "Door A/B Labs Corridor",
    ["airlock"] = "Test Lab C-33/a Airlock",
    ["airlock2"] = "Test Lab C-33/a Exit Airlock",
    ["airlock3"] = "Test Lab C-33/a Blastdoor Left",
    ["airlock4"] = "Test Lab C-33/a Blastdoor Right",
    ["am_handling"] = "Xenpen Access - Necroscopy",
    ["ams_level3_a"] = "Access to Level 3 - Ionisation Chambers",
    ["ams_level3_b"] = "Leaving Level 3 - Ionisation Chambers",
    ["boio_airl_door_01"] = "BSL Lab Airlock (Advanced Biolab)",
    ["containm_lab03"] = "Engineering Lab Access from Xenpen Corridor",
    ["controlroom_a"] = "Enter Control Room from Ionisation Chambers",
    ["controlroom_b"] = "Exit Control Room to Ionisation Chambers",
    ["controlroom_c"] = "Exit Control Room to Plasma Cells",
    ["controlroom_d"] = "Enter Control Room from Plasma Cells",
    ["lab04_airl_door01"] = "Access Advanced Biolab to Handwash",
    ["lab04_airl_door03"] = "Access Handwash to Gowning Area",
    ["laba_locker"] = "Access Lab A/B Locker from Lab A",
    ["laba_locker2"] = "Leave Lab A/B Locker to Lab A",
    ["labb_locker"] = "Leave Lab A/B Locker to Lab B",
    ["labb_locker2"] = "Access Lab A/B Locker from Lab B",
    ["serverroom"] = "Server Room",
    ["surg"] = "Necroscopy"
}

ix.security.consoleEnabledDoors = ix.security.consoleEnabledDoors or {
    "logingate_lobby1",
    "logingate_lobby2",
    "logingate_lobby3",
    "logingate_lobby4",
    "logoutgate_lobby1",
    "logoutgate_lobby2",
    "lab_a_corridor",
    "computerlab",
    "scannerbutton_offices_corridor",
    "lab_a",
    "lab_c",
    "lab_c_d_corridor",
    "lab04",
    "lab_03",
    "laba_locker",
    "laba_locker2",
    "labb_locker",
    "labb_locker2",
    "security_serverroom",
    "serverroom",
    "surg",
}
