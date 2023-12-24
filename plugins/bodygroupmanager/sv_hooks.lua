
util.AddNetworkString("ixBodygroupView")
util.AddNetworkString("ixBodygroupTableSet")

ix.log.AddType("	", function(client, target)
	return string.format("%s has changed %s's bodygroups.", client:GetName(), target:GetName())
end)

net.Receive("ixBodygroupTableSet", function(length, client)
	local target = net.ReadEntity()

	if (!IsValid(target) or !target:IsPlayer() or !target:GetCharacter()) then
		return
	end

	if (!ix.command.HasAccess(client, "CharEditBodygroup")) then
		if (target == client) then
			local found = false
			
			for _, entity in pairs(ents.FindInSphere(client:GetPos(), 128)) do
				if (entity:GetClass() == "bmrp_customization") then
					found = true
					break
				end
			end

			if (!found) then
				return
			end
		else
			return
		end
	end

	local bodygroups = net.ReadTable()

	local groups = {}

	for k, v in pairs(bodygroups) do
		target:SetBodygroup(tonumber(k) or 0, tonumber(v) or 0)
		groups[tonumber(k) or 0] = tonumber(v) or 0
	end

	target:GetCharacter():SetData("groups", groups)
	target:GetCharacter():Save()

	ix.log.Add(client, "bodygroupEditor", target)
end)
