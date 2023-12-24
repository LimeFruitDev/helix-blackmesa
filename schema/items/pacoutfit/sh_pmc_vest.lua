local ITEM = ITEM
ITEM.name = "Tactical Vest"
ITEM.description = "A robust and utilitarian garment designed for tactical operations. It is made from durable, rip-resistant nylon fabric that can withstand rugged environments and extreme conditions."
ITEM.model = "models/limefruit/security/equipment/male/pmc_vest.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.outfitCategory = "body"
ITEM.noBusiness = true

ITEM.pacData = {
    ["male"] = {
        ["children"] = {
            [1] = {
                ["children"] = {},
                ["self"] = {
                    ["Skin"] = 0,
                    ["Invert"] = false,
                    ["EyeTargetName"] = "",
                    ["NoLighting"] = false,
                    ["OwnerName"] = "self",
                    ["AimPartName"] = "",
                    ["BlendMode"] = "",
                    ["AimPartUID"] = "",
                    ["Materials"] = "",
                    ["Name"] = "",
                    ["LevelOfDetail"] = 0,
                    ["NoTextureFiltering"] = false,
                    ["PositionOffset"] = Vector(0, 0, 0),
                    ["IsDisturbing"] = false,
                    ["Translucent"] = false,
                    ["DrawOrder"] = 0,
                    ["Alpha"] = 1,
                    ["Material"] = "",
                    ["ModelModifiers"] = "",
                    ["Bone"] = "head",
                    ["UniqueID"] = "3273671870",
                    ["EyeTargetUID"] = "",
                    ["BoneMerge"] = true,
                    ["NoCulling"] = false,
                    ["Position"] = Vector(0, 0, 0),
                    ["AngleOffset"] = Angle(0, 0, 0),
                    ["Color"] = Vector(1, 1, 1),
                    ["Hide"] = false,
                    ["Angles"] = Angle(0, 0, 0),
                    ["Scale"] = Vector(1, 1, 1),
                    ["EyeAngles"] = false,
                    ["EditorExpand"] = false,
                    ["Size"] = 1,
                    ["ClassName"] = "model2",
                    ["IgnoreZ"] = false,
                    ["Brightness"] = 1,
                    ["Model"] = "models/limefruit/security/equipment/male/bonemerge/pmc_vest.mdl",
                    ["ForceObjUrl"] = false,
                },
            },
        },
        ["self"] = {
            ["DrawOrder"] = 0,
            ["UniqueID"] = "1573137967",
            ["AimPartUID"] = "",
            ["Hide"] = false,
            ["Duplicate"] = false,
            ["ClassName"] = "group",
            ["OwnerName"] = "self",
            ["IsDisturbing"] = false,
            ["Name"] = "my outfit",
            ["EditorExpand"] = false,
        },
    },
    ["female"] = {
        ["children"] = {
            [1] = {
                ["children"] = {
                },
                ["self"] = {
                    ["Skin"] = 0,
                    ["Invert"] = false,
                    ["EyeTargetName"] = "",
                    ["NoLighting"] = false,
                    ["OwnerName"] = "self",
                    ["AimPartName"] = "",
                    ["BlendMode"] = "",
                    ["AimPartUID"] = "",
                    ["Materials"] = "",
                    ["Name"] = "",
                    ["LevelOfDetail"] = 0,
                    ["NoTextureFiltering"] = false,
                    ["PositionOffset"] = Vector(0, 0, 0),
                    ["IsDisturbing"] = false,
                    ["Translucent"] = false,
                    ["DrawOrder"] = 0,
                    ["Alpha"] = 1,
                    ["Material"] = "",
                    ["ModelModifiers"] = "",
                    ["Bone"] = "head",
                    ["UniqueID"] = "3142530375",
                    ["EyeTargetUID"] = "",
                    ["BoneMerge"] = true,
                    ["NoCulling"] = false,
                    ["Position"] = Vector(0, 0, 0),
                    ["AngleOffset"] = Angle(0, 0, 0),
                    ["Color"] = Vector(1, 1, 1),
                    ["Hide"] = false,
                    ["Angles"] = Angle(0, 0, 0),
                    ["Scale"] = Vector(1, 1, 1),
                    ["EyeAngles"] = false,
                    ["EditorExpand"] = false,
                    ["Size"] = 1,
                    ["ClassName"] = "model2",
                    ["IgnoreZ"] = false,
                    ["Brightness"] = 1,
                    ["Model"] = "models/limefruit/security/equipment/female/bonemerge/pmc_vest.mdl",
                    ["ForceObjUrl"] = false,
                },
            },
        },
        ["self"] = {
            ["DrawOrder"] = 0,
            ["UniqueID"] = "1573137967",
            ["AimPartUID"] = "",
            ["Hide"] = false,
            ["Duplicate"] = false,
            ["ClassName"] = "group",
            ["OwnerName"] = "self",
            ["IsDisturbing"] = false,
            ["Name"] = "my outfit",
            ["EditorExpand"] = true,
        },
    },
}

local validModels = {
    ["military/female"] = "female",
    ["security/female"] = "female",
    ["military/male"] = "male",
    ["security/male"] = "male"
}

ITEM.getPacData = function( self, client )
    local model = client:GetModel()

    local pacData
    for modelPath, pacKey in pairs(validModels) do
        if (string.find(model, modelPath)) then
            pacData = self.pacData[pacKey]
            break
        end
    end

    return pacData or {}
end

local function onTakeDamage( client, dmg, took )
    if not took then return end

    local vest = client.vest
    if (vest) then
        local armor = vest:GetData("armor", nil)
        if (armor) then
            local armorAmount = armor - dmg:GetDamage()
            armorAmount = armorAmount >= 0 and armorAmount or 0
            vest:SetData("armor", armorAmount)
        end
    end
end

local monitorHookName = "vestDamageMonitor"

function ITEM:OnEquipped()
    local owner = self:GetOwner()
    local armor = self:GetData("armor", 100)

    armor = armor < 0 and 0 or armor

    print(armor)

    self:SetData("armor", armor)
    owner:SetArmor(armor)
    owner.vest = self

    hook.Add("PostEntityTakeDamage", owner:GetName() .. monitorHookName, onTakeDamage)
end

function ITEM:OnUnequipped()
    local owner = self:GetOwner()
    local armor = self:GetData("armor", nil)

    if armor then
        owner:SetArmor(owner:Armor() - armor)
    end

    hook.Remove("PostEntityTakeDamage", owner:GetName() .. monitorHookName)
end

function ITEM:GetDescription()
    return self.description .. "\n\nCondition: " .. self:GetData("armor", 100) .. "%"
end
