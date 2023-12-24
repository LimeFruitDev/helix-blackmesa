local PLUGIN = PLUGIN

PLUGIN.name = "Clearance Signs"
PLUGIN.author = "Riekelt & Zoephix"
PLUGIN.description = "Adds clearance signs with administrative tools to manage them."

if (SERVER) then
    -- Load the plugin data
    function PLUGIN:LoadData()
        data = self:GetData() or {}

        for k, v in pairs(data) do
            local entity = ents.Create("nut_csign")
            entity:SetPos(v.pos)
            entity:SetAngles(v.angles)
            entity:SetNetVar("clearance", v.clearance)
            entity:Spawn()
            entity:Activate()

            local phys = entity:GetPhysicsObject()

            if phys and phys:IsValid() then
                phys:EnableMotion(false)
            end
        end
    end

    -- Save the plugin data
    function PLUGIN:SaveData()
        local data = {}
        for k, v in pairs(ents.FindByClass("nut_csign")) do
            data[#data + 1] = {
                pos = v:GetPos(),
                angles = v:GetAngles(),
                clearance = v:GetNetVar("clearance")
            }
        end
        self:SetData(data)
    end
else
    -- Create the plugin fonts
    surface.CreateFont( "clearanceTitle", {
        font = "Arial",
        size = 35,
        weight = 2400,
        antialias = true,
    } )

    surface.CreateFont( "clearanceLevel", {
        font = "Arial",
        size = 32,
        weight = 400,
        antialias = true,
    } )
end

ix.command.Add("SignSetClearance", {
    description = "@cmdSignSetClearance",
    adminOnly = true,
    arguments = {
		ix.type.string
	},
    OnRun = function(self, client, clearances)
        local signEntity = client:GetEyeTrace().Entity

        if string.len(clearances) > 2 then
            return "You must enter a clearance smaller then 2 characters."
        elseif not signEntity then
            return "You must be looking at a sign to set its clearance."
        elseif signEntity:GetClass() ~= "nut_csign" then
            return "You must be looking at a sign to set its clearance."
        end

        signEntity:SetNetVar("clearance", clearances)

        return "You have set the clearance for this sign to " .. clearances .. "!"
    end
})
