ITEM.name = "Pack of Cigarettes"
ITEM.model = Model("models/closedboxshib.mdl")
ITEM.description = "A pack of primium cigarettes, branded with a familiar logo."
ITEM.category = "Recreation"
ITEM.noBusiness = true
ITEM.open = false
ITEM.totalcigs = 10
ITEM.price = 40
ITEM.new = true

ITEM.functions.TakeCigarette = {
    name = "Take Cigarette",
    tip = "Take a cigarette.",
    icon = "icon16/brick.png",
    OnCanRun = function(item)
        return item:GetData("open")
    end,
    OnRun = function(item)
        if item:GetData("totalcigs", 0) > 1 and item:GetData("open") then
            item:SetData("totalcigs", item:GetData("totalcigs", 0) - 1 )
            return false
        end

        return true
    end
}

ITEM.functions.OpenCigarettes = {
	name = "Open Cigarettes",
	tip = "Open the pack of cigarettes.",
    icon = "icon16/door_open.png",
    OnCanRun = function(item)
        return not item:GetData("open")
    end,
    OnRun = function(item)
    	item:SetData("open", true)
    	return false
    end
}
ITEM.postHooks.TakeCigarette = function(item, result)
    if not (item.player:GetCharacter():GetInventory():Add("cigarette", 1)) then
        ix.item.Spawn("cigarette", item.player)
    end
end
