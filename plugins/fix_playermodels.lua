local PLUGIN = PLUGIN

PLUGIN.name = "Fix Playermodels"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Adds compatibility for previous playermodels."

PLUGIN.paths = {
	["models/limefruit/research/"] = "models/humans_limefruit/science/group/",
	["models/limefruit/security/"] = "models/humans_limefruit/security/group/"
}

if (SERVER) then
	function PLUGIN:CharacterLoaded(character)
		for oldPath, newPath in pairs(self.paths) do
			if (character:GetModel():find(oldPath)) then
				character:SetModel(character:GetModel():gsub(oldPath, newPath))
			end
		end
	end
end
