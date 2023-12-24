--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

PLUGIN.name = "Extra Acts"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Adds extra actions."

function PLUGIN:SetupActs()
	ix.act.Register("SitChair", {"citizen_male", "citizen_female"}, {
		start = {"idle_to_sit_chair", "sitccouchtv1", "p_breakroom_sit_01loop", "d1_t02_plaza_sit02", "d1_t01_breakroom_sit02_entry", "d1_t01_BreakRoom_Sit01_Idle"},
		sequence = {"sit_chair", "sitccouchtv1", "p_breakroom_sit_01loop", "d1_t02_plaza_sit02", "d1_t01_breakroom_sit02", "d1_t01_BreakRoom_Sit01_Idle"},
		finish = {
			"",
			"",
			"",
			"",
			"d1_t01_breakroom_sit02_exit",
			""
		},
		untimed = true,
		idle = true
	})
	ix.act.Register("SitCouch", {"citizen_male", "citizen_female"}, {
		start = {"sitcouchknees1", "sitcouchfeet1"},
		sequence = {"sitcouchknees1", "sitcouchfeet1"},
		finish = {
			"",
			""
		},
		untimed = true,
		idle = true
	})
end
