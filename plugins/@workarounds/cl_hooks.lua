
local PLUGIN = PLUGIN

net.Receive("ixCharacterVarChanged", function()
	local id = net.ReadUInt(32)
	local character = ix.char.loaded[id]

	if (character) then
		local key = net.ReadString()
		local value = net.ReadType()

		character.vars[key] = value
		hook.Run("CharacterVariableChanged", character, key, value)
	end
end)
