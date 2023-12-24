ITEM.name = "Cigarette Pack"
ITEM.model = Model("models/kek1ch/drink_cigar1.mdl")
ITEM.description = "A pack of cigarettes."
ITEM.category = "Recreation"
ITEM.open = false
ITEM.totalcigs = 5
ITEM.new = true

function ITEM:OnInstanced()
    self:SetData("open", self.open)
    self:SetData("totalcigs", self.totalcigs)
    self:SetData("new", self.new)
end

function ITEM:GetDescription()
    if self:GetData("totalcigs", 0) == self.totalcigs and (self:GetData("open", self.open) == false) and self:GetData("new", self.new) then
        return L(self.description .. "\nIt is unopened.")
    else
        if self:GetData("open", false) == false then
            return L(self.description .. "\nIt is closed.")
        else
            return L(self.description .. "\nIt has " .. self:GetData("totalcigs", self.totalcigs) .. " cigarettes remaining.")
        end
    end
end

ITEM.functions.TakeCigarette = {
    name = "Take Cigarette",
    icon = "icon16/basket_put.png",
    tip = "Take a cigarette.",
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
