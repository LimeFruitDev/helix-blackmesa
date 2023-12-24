PLUGIN.name = "Tutorial"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Tutorial that introduces new players to the server."

ix.util.Include( "cl_plugin.lua" )
ix.util.Include( "sv_plugin.lua" )

local PLUGIN = PLUGIN

if CLIENT then
	function PLUGIN:CreateTutorial()
		ix.tutorial.start()
	end

	-- function PLUGIN:OnCharacterMenuCreated()
	-- 	ix.tutorial.start()
	-- end
end
