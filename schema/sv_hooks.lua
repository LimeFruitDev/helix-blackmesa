function Schema:OnCharacterCreated( client, char )
	local faction = ix.faction.indices[char:GetFaction()]

	-- Set their starting clearances.
	char:SetData("clearances", faction.clearances and faction.clearances or "1")

	-- Give bodygroup/skin flags.
	char:GiveFlags("b")

	-- Give them their items.
	local inventory = char:GetInv()
	if (inventory) then
		inventory:Add("keycard", 1, {
			name = char:GetName(),
			id = math.random( 10000, 99999 )
		})

		if (faction.frequency) then
			inventory:Add("radio", 1, {freq = faction.frequency, power = true})
		end
	end
end

-- Gear footstep sounds.
function Schema:PlayerFootstep(client, position, foot, soundName, volume)
	if (client:IsRunning() and (client:Team() == FACTION_SECURITY or client:Team() == FACTION_DCT)) then
		client:EmitSound("npc/combine_soldier/gear" .. math.random(1, 2) .. ".wav", volume * 220)
	end

	return true
end

-- Fix player bone manipulations.
hook.Add("PlayerSpawn", "FixPlayerBones", function(ply)
	for i = 0, ply:GetBoneCount() - 1 do
		ply:ManipulateBoneAngles(ply:LookupBone(ply:GetBoneName(i)), Angle(0, 0, 0))
	end
end)

-- Optimizations.
local skipModels = {
	"models/props_office/computer_monitor01.mdl",
	"models/props_office/computer_monitor02.mdl",
	"models/props_office/computer_monitor03.mdl",
	"models/props_office/computer_monitor04.mdl"
}

hook.Add("InitPostEntity", "OptimizeSpawnedPhysicsProps", function()
	for k, v in pairs(ents.FindByClass("prop_physics")) do
		if (table.HasValue(skipModels, v:GetModel())) then continue end

		local newEntity = ents.Create("prop_physics_multiplayer")
		newEntity:SetModel(v:GetModel())
		newEntity:SetPos(v:GetPos())
		newEntity:SetAngles(v:GetAngles())
		newEntity:SetSkin(v:GetSkin())
		newEntity:SetColor(v:GetColor())
		newEntity:SetMaterial(v:GetMaterial())
		newEntity:SetCollisionGroup(v:GetCollisionGroup())
		newEntity:SetKeyValue("fademindist", "1000")
		newEntity:SetKeyValue("fademaxdist", "1250")
		newEntity:Spawn()

		local bodyGroups = v:GetBodyGroups()

		if (istable(bodyGroups)) then
			for _, v2 in pairs(bodyGroups) do
				if (v:GetBodygroup(v2.id) > 0) then
					newEntity:SetBodygroup(v2.id, v:GetBodygroup(v2.id))
				end
			end
		end

		local physicsObject = v:GetPhysicsObject()
		local newEntityPhysicsObject = newEntity:GetPhysicsObject()

		if (IsValid(physicsObject) and IsValid(newEntityPhysicsObject)) then
			newEntityPhysicsObject:EnableMotion(physicsObject:IsMoveable())
		end

		v:Remove()
	end
end)

hook.Add("PlayerInitialSpawn", "PlayerSpawnCommands", function( ply, transition )
    ply:ConCommand("gmod_mcore_test 1")
	ply:ConCommand("mat_queue_mode -1")
	ply:ConCommand("cl_threaded_bone_setup 1")
end)

-- Disable item collision, to prevent crashing.
function Schema:ShouldCollide(f, t)
    if (f:GetClass() == "ix_item" and t:GetClass() == "ix_item") then
        return false
    end
end

-- Add workshop items.
hook.Add("Think", "AddWorkshopCollection", function()
	http.Fetch("https://steamcommunity.com/workshop/filedetails/?id=" .. GetConVar("host_workshop_collection"):GetString(), function(page)
		local workshopItems = 0

		for k in string.gmatch(page, '<div data%-panel="{&quot;type&quot;:&quot;PanelGroup&quot;}" id="sharedfile_(%d+)" class="collectionItem">') do
			resource.AddWorkshop(k)
			workshopItems = workshopItems + 1
		end

		if (workshopItems < 1) then
			ErrorNoHalt("[Schema] No workshop items were added!\n")
		else
			Msg("[Schema] Added " .. workshopItems .. " workshop items!\n")
		end
	end)

	hook.Remove("Think", "AddWorkshopCollection")
end)
