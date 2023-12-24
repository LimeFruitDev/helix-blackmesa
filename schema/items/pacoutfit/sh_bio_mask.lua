local ITEM = ITEM
ITEM.name = "Bio Mask"
ITEM.description = "Protective mask for filtering out harmful gases and chemicals, covering the face with a secure seal and transparent visor."
ITEM.model = "models/pmcsimp/mask1_prop.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.outfitCategory = "body"
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
                    ["UniqueID"] = "3877143096",
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
                    ["Model"] = "models/pmcsimp/bio_mask.mdl",
                    ["ForceObjUrl"] = false,
                },
            },
        },
        ["self"] = {
            ["DrawOrder"] = 0,
            ["UniqueID"] = "987916211",
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
                    ["UniqueID"] = "3877143096",
                    ["EyeTargetUID"] = "",
                    ["BoneMerge"] = false,
                    ["NoCulling"] = false,
                    ["Position"] = Vector(-61.477188110352, -0.67779541015625, -0.03887939453125),
                    ["AngleOffset"] = Angle(0, 0, 0),
                    ["Color"] = Vector(1, 1, 1),
                    ["Hide"] = false,
                    ["Angles"] = Angle(0, -90, -90),
                    ["Scale"] = Vector(1, 1, 1),
                    ["EyeAngles"] = false,
                    ["EditorExpand"] = false,
                    ["Size"] = 0.95,
                    ["ClassName"] = "model2",
                    ["IgnoreZ"] = false,
                    ["Brightness"] = 1,
                    ["Model"] = "models/pmcsimp/bio_mask.mdl",
                    ["ForceObjUrl"] = false,
                },
            },
        },
        ["self"] = {
            ["DrawOrder"] = 0,
            ["UniqueID"] = "987916211",
            ["AimPartUID"] = "",
            ["Hide"] = false,
            ["Duplicate"] = false,
            ["ClassName"] = "group",
            ["OwnerName"] = "self",
            ["IsDisturbing"] = false,
            ["Name"] = "my outfit",
            ["EditorExpand"] = true,
        },
    }
}

local validModels = {
    ["female"] = "female",
    ["male"] = "male"
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

    return pacData or self.pacData["male"] or {}
end
