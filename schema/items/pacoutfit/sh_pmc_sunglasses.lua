local ITEM = ITEM
ITEM.name = "Tactical Glasses"
ITEM.description = "A specialized eyewear accessory commonly used in military and tactical settings. These glasses feature a durable frame and distinct orange-tinted lenses designed to enhance vision and provide protection in various environments."
ITEM.model = "models/limefruit/security/equipment/male/pmc_sunglasses3.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.outfitCategory = "glasses"
ITEM.noBusiness = true

ITEM.pacData = {
    ["male"] = {
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
                    ["UniqueID"] = "3043331783",
                    ["EyeTargetUID"] = "",
                    ["BoneMerge"] = false,
                    ["NoCulling"] = false,
                    ["Position"] = Vector(3.0780000686646, -4.5460000038147, -0.10000000149012),
                    ["AngleOffset"] = Angle(0, 0, 0),
                    ["Color"] = Vector(1, 1, 1),
                    ["Hide"] = false,
                    ["Angles"] = Angle(89.83568572998, 179.76422119141, 170.63241577148),
                    ["Scale"] = Vector(1, 1, 1),
                    ["EyeAngles"] = false,
                    ["EditorExpand"] = false,
                    ["Size"] = 1,
                    ["ClassName"] = "model2",
                    ["IgnoreZ"] = false,
                    ["Brightness"] = 1,
                    ["Model"] = "models/limefruit/security/equipment/male/pmc_sunglasses3.mdl",
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
                    ["UniqueID"] = "2111133832",
                    ["EyeTargetUID"] = "",
                    ["BoneMerge"] = false,
                    ["NoCulling"] = false,
                    ["Position"] = Vector(1.6092071533203, -4.594970703125, -0.00787353515625),
                    ["AngleOffset"] = Angle(0, 0, 0),
                    ["Color"] = Vector(1, 1, 1),
                    ["Hide"] = false,
                    ["Angles"] = Angle(89.83568572998, 179.76422119141, 170.63241577148),
                    ["Scale"] = Vector(1, 1, 1),
                    ["EyeAngles"] = false,
                    ["EditorExpand"] = false,
                    ["Size"] = 1,
                    ["ClassName"] = "model2",
                    ["IgnoreZ"] = false,
                    ["Brightness"] = 1,
                    ["Model"] = "models/limefruit/security/equipment/male/pmc_sunglasses3.mdl",
                    ["ForceObjUrl"] = false,
                },
            },
        },
        ["self"] = {
            ["DrawOrder"] = 0,
            ["UniqueID"] = "1645661391",
            ["AimPartUID"] = "",
            ["Hide"] = false,
            ["Duplicate"] = false,
            ["ClassName"] = "group",
            ["OwnerName"] = "self",
            ["IsDisturbing"] = false,
            ["Name"] = "glasses",
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
