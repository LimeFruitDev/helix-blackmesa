local PLUGIN = PLUGIN

function PLUGIN:StartCCTV( ply )
	for k,v in pairs(ents.FindByClass("bmrp_cctv")) do
		if ply:GetPos():Distance(v:GetPos()) <= self.cctvDistance then
			netstream.Start(ply, "cctvStart")
			return
		end
	end
	ix.util.Notify("You must be within "..self.cctvDistance.." units of a CCTV Prompt!", ply)
end

netstream.Hook("cctvUpdate", function( ply, camera )
	local cameraFound

	for k,v in pairs(ents.FindByClass("bmrp_cam")) do
		if v:GetNWString("name", "Unknown") == camera then
			cameraFound = v
			break
		end
	end

	if not cameraFound then
		ix.util.Notify("ERROR: Failure to find camera ( "..camera.." )!", ply)
		return
	end

	if not IsValid(CCTVCamera) then
		CCTVCamera = ents.Create( "point_camera" )
		CCTVCamera:SetKeyValue( "GlobalOverride", 1 )
		CCTVCamera:Spawn()
		CCTVCamera:Activate()
		CCTVCamera:Fire( "SetOn", "", 0.0 )
	end

	pos = cameraFound:LocalToWorld( Vector( 10,0,0 ) )
	CCTVCamera:SetPos(pos)
	local ang = cameraFound:GetAngles()
	ang[2] = ang[2] + 0
	ang[1] = ang[1] + 30
	CCTVCamera:SetAngles(ang)
	CCTVCamera:SetParent(cameraFound)

	for k,v in pairs(ents.FindByClass("bmrp_cctv")) do
		v:SetNWString("camera", camera)
	end
end)

hook.Add("SetupPlayerVisibility", "CCTVRender", function( ply )
	if IsValid(CCTVCamera) then
		AddOriginToPVS( CCTVCamera:GetPos() )
	end
end)

function PLUGIN:SaveData()
	local cctvData = {};
	local cameraData = {};

	for k, v in pairs(ents.FindByClass("bmrp_cctv")) do
		cctvData[#cctvData + 1] = {
			pos = v:GetPos(),
			model = v:GetModel(),
			angles = v:GetAngles()
		}
	end

	for k, v in pairs(ents.FindByClass("bmrp_cam")) do
		cameraData[#cameraData + 1] = {
			pos = v:GetPos(),
			angles = v:GetAngles(),
			model = v:GetModel(),
			camname = v:GetNWString("name", "Unknown")
		}
	end

	local data ={
		["cctv"] = cctvData,
		["cameras"] = cameraData
	}

	self:SetData(data)
end

function PLUGIN:LoadData()
	local data = self:GetData() or {}
	local cctvData = data["cctv"] or {};
	local cameraData = data["cameras"] or {};
	
	for k, v in pairs(ents.FindByClass("bmrp_cctv")) do
		v:Remove()
	end

	for k, v in pairs(ents.FindByClass("bmrp_cam")) do
		v:Remove()
	end
	
	for _, cctvData in pairs(cctvData) do
		local entity = ents.Create("bmrp_cctv")
		entity:SetPos(cctvData.pos)
		entity:SetAngles(cctvData.angles)
		entity:Spawn()
		entity:Activate()

		local phys = entity:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end

	for _, cameraData in pairs(cameraData) do
		local entity = ents.Create("bmrp_cam")
		entity:SetPos(cameraData.pos)
		entity:SetAngles(cameraData.angles)
		entity:Spawn()
		entity:SetModel(cameraData.model)
		entity:SetNWString("name", cameraData.camname)
		entity:Activate()
		local phys = entity:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end
end
