--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN
PLUGIN.name = "Radio Extras"
PLUGIN.description = "Adds extra features to radios."
PLUGIN.author = "Zoephix"

if CLIENT then
    local prefixes = {"/r", "/d"}

    function PLUGIN:GetTypingIndicator(char, text)
        if table.HasValue(prefixes, string.sub(text, 1, 2)) then
            return "radio"
        end
    end

    function PLUGIN:ChatTextChanged(text)
        if table.HasValue(prefixes, string.sub(text, 1, 2)) and not LocalPlayer().radioing then
            LocalPlayer().radioing = true
        elseif not table.HasValue(prefixes, string.sub(text, 1, 2)) and LocalPlayer().radioing then
            LocalPlayer().radioing = false
        end
    end

    function PLUGIN:FinishChat()
        if LocalPlayer().radioing then
            LocalPlayer().radioing = false
        end
    end
end
