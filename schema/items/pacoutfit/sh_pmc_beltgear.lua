local ITEM = ITEM
ITEM.name = "Tactical Belt"
ITEM.description = "A wide and sturdy accessory made from reinforced nylon. It features a durable strap that is adjustable in length to accommodate different waist sizes, ensuring a comfortable fit. The belt's ample width allows for even weight distribution, providing optimal comfort while carrying equipment and accessories."
ITEM.model = "models/limefruit/security/equipment/male/pmc_beltgear4.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.outfitCategory = "waist"
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
                    ["UniqueID"] = "2123221827",
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
                    ["Model"] = "models/limefruit/security/equipment/male/bonemerge/pmc_beltgear4.mdl",
                    ["ForceObjUrl"] = false,
                },
            },
        },
        ["self"] = {
            ["DrawOrder"] = 0,
            ["UniqueID"] = "3620760109",
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
                    ["UniqueID"] = "2123221827",
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
                    ["Model"] = "models/limefruit/security/equipment/female/bonemerge/pmc_belt.mdl",
                    ["ForceObjUrl"] = false,
                },
            },
        },
        ["self"] = {
            ["DrawOrder"] = 0,
            ["UniqueID"] = "3620760109",
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
