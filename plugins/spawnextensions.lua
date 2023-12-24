
local PLUGIN = PLUGIN

PLUGIN.name = "Spawn Extensions"
PLUGIN.description = "Extensions for the spawn plugin."
PLUGIN.author = "Zoephix"
PLUGIN.spawns = PLUGIN.spawns or {}

local spawnPlugin = ix.plugin.list["spawns"]

assert(spawnPlugin ~= nil)

ix.command.Add("SpawnAddAll", {
	description = "@cmdSpawnAdd",
	privilege = "Manage Spawn Points",
	adminOnly = true,
	OnRun = function(self, client)
		for _, v in ipairs(ix.faction.indices) do
			faction = v.uniqueID
			info = v

			spawnPlugin.spawns[faction] = spawnPlugin.spawns[faction] or {}
			spawnPlugin.spawns[faction]["default"] = spawnPlugin.spawns[faction]["default"] or {}

			table.insert(spawnPlugin.spawns[faction]["default"], client:GetPos())
		end

		spawnPlugin:SaveSpawns()

		return "@spawnAdded", "all"
	end
})
