FACTION.name = "Xenian Creature"
FACTION.description = ""
FACTION.color = Color(0, 255, 0)

FACTION.models = {
	"models/xenians/houndeye.mdl",
	"models/xenians/headcrab.mdl",
	"models/xenians/bullsquid.mdl",
	"models/xenians/snark.mdl",
	"models/antlion.mdl",
	"models/antlion_guard.mdl",
	"models/hl1_alpha/panther.mdl",
	"models/Ichthyosaur.mdl"
}

FACTION.pills = {
	["models/xenians/headcrab.mdl"] = "headcrab",
	["models/xenians/houndeye.mdl"] = "houndeye",
	["models/xenians/bullsquid.mdl"] = "bullsquid",
	["models/antlion.mdl"] = "antlion",
	["models/antlion_guard.mdl"] = "antlion_guard",
	["models/hl1_alpha/panther.mdl"] = "panther_alpha_pill",
	["models/Ichthyosaur.mdl"] = "ichthyosaur"
}

function FACTION:OnSpawn(client)
	local pill = self.pills[client:GetModel()]
	if pill then
    	pk_pills.apply(client, pill)
	end
end

FACTION_XEN = FACTION.index
