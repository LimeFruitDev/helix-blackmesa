--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN
local csModels = csModels or {}

netstream.Hook( "ixClearanceSlideKeycard", function( reader, rmodel )
	-- Check if the models are valid
	if !( IsValid( reader ) or IsValid( rmodel ) ) then return end

	-- Create the keycard model
	local keycard = ClientsideModel( "models/sky/cid.mdl" )
	keycard:SetAngles( rmodel:GetAngles() + Angle( 180, 0, 90 ) )
	keycard.offset = rmodel:GetPos() + rmodel:GetUp() * 7 + rmodel:GetForward() * 5.5 + Vector(rmodel:GetRight() * - 2.85, 0, 0)

	-- Set the time for when we remove the keycard
	keycard.RemoveTime = CurTime() + 0.75

	-- Create a new table entry
	csModels[ #csModels + 1 ] = { rmodel = rmodel, keycard = keycard }
end)

hook.Add('Think','KeycardSlide', function()
	if #csModels > 0 then
		for UID, data in pairs( csModels ) do
			local rmodel = data.rmodel
			local keycard = data.keycard

			-- Remove the keycard after the delay
			if CurTime() > keycard.RemoveTime then
				-- Remove the keycard
				keycard:Remove()

				-- Remove the table entry
				table.remove( csModels, UID )

				return
			end

			-- Change the keycard position
			keycard:SetPos( keycard.offset - rmodel:GetUp() * ( FrameTime() * 15 ) )
			keycard.offset = keycard:GetPos()
		end
	end
end)
