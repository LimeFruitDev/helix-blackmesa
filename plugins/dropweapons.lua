local PLUGIN = PLUGIN

PLUGIN.name = "Drop Weapons"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Makes players drop their equipped weapons on death."

function PLUGIN:PlayerDeath( client )
    local character = client:GetCharacter()
    if not character then return end

    local items = character:GetInv():GetItems()
    for _, item in pairs(items) do
        if (item.isWeapon and item:GetData("equip")) then
            ix.item.Spawn(item.uniqueID, client:GetPos() + Vector(0, 0, 25), nil, nil, item:GetData())

            item:Remove()
        end
    end
end
