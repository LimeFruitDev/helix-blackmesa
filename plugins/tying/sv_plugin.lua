-- animations
local PLAYER = FindMetaTable("Player")

function PLAYER:SetCuffAnim(state)
	if state then
		self:ManipulateBoneAngles(self:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(60,0,0))
		self:ManipulateBoneAngles(self:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(-60,0,0))
		self:ManipulateBoneAngles(self:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(-5,10,0))
		self:ManipulateBoneAngles(self:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(5,20,0))
	else
		self:ManipulateBoneAngles(self:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0,0,0))
		self:ManipulateBoneAngles(self:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0,0,0))
		self:ManipulateBoneAngles(self:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0,0,0))
		self:ManipulateBoneAngles(self:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0,0,0)) 
	end

    if self:GetNetVar("cuffs") then
        netstream.Start(player.GetAll(), "spawnPlayerCuffs", self, state)
    end
end
