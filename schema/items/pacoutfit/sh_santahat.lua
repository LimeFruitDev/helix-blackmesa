local ITEM = ITEM
ITEM.name = "Santa Hat"
ITEM.description = "A red and white hat associated with Santa Claus, with a white bobble on top."
ITEM.model = "models/cloud/kn_santahat.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.outfitCategory = "hat"
ITEM.noBusiness = true

ITEM.pacData = {
    ["default"] = {
        [1] = {
            ["children"] = {
                [1] = {
                    ["children"] = {
                    },
                    ["self"] = {
                        ["Bone"] = "head",
                        ["Position"] = Vector(3.580078125, -0.1865234375, -0.045604705810547),
                        ["Angles"] = Angle(-3.4579093456268, -74.026000976563, -90),
                        ["Scale"] = Vector(0.80000001192093, 0.80000001192093, 0.60000002384186),
                        ["EditorExpand"] = true,
                        ["Size"] = 1,
                        ["ClassName"] = "model2",
                        ["Model"] = "models/captainbigbutt/skeyler/hats/santa.mdl"
                    },
                },
            },
            ["self"] = {
                ["UniqueID"] = "580451698",
                ["ClassName"] = "group",
                ["EditorExpand"] = true
            },
        }
    },
    ["male"] = {
        [1] = {
            ["children"] = {
                [1] = {
                    ["children"] = {
                    },
                    ["self"] = {
                        ["Bone"] = "head",
                        ["Position"] = Vector(3.740234375, -0.5283203125, -0.01171875),
                        ["Angles"] = Angle(-4.3499999046326, -74.026000976563, -90),
                        ["Scale"] = Vector(0.80000001192093, 0.80000001192093, 0.60000002384186),
                        ["EditorExpand"] = true,
                        ["Size"] = 1,
                        ["ClassName"] = "model2",
                        ["Model"] = "models/captainbigbutt/skeyler/hats/santa.mdl"
                    },
                },
            },
            ["self"] = {
                ["UniqueID"] = "580451698",
                ["ClassName"] = "group",
                ["EditorExpand"] = true
            },
        }
    },
    ["female"] = {
        [1] = {
            ["children"] = {
                [1] = {
                    ["children"] = {
                    },
                    ["self"] = {
                        ["Bone"] = "head",
                        ["Position"] = Vector(3.724609375, 0.0126953125, -0.066986083984375),
                        ["Angles"] = Angle(-2.2820000648499, -78.279716491699, -90),
                        ["Scale"] = Vector(0.80000001192093, 0.80000001192093, 0.60000002384186),
                        ["EditorExpand"] = true,
                        ["Size"] = 1,
                        ["ClassName"] = "model2",
                        ["Model"] = "models/captainbigbutt/skeyler/hats/santa.mdl"
                    },
                },
            },
            ["self"] = {
                ["UniqueID"] = "580451698",
                ["ClassName"] = "group",
                ["EditorExpand"] = true
            },
        }
    }
}

ITEM.getPacData = function( self, client )
    local model = client:GetModel()

    if string.find(model, "limefruit") then
        if string.find(model, "female") then
            return self.pacData["female"]
        else
            return self.pacData["male"]
        end
    else
        return self.pacData["default"]
    end
end
