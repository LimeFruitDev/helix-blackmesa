ITEM.name = "HEV Mark VI"
ITEM.description = "Designed for Black Mesa scientists to protect themselves from radiation, energy discharges, blunt-force trauma during the handling of hazardous materials, and the effects of traveling to Xen as part of Survey Teams."
ITEM.category = "Outfit"
ITEM.model = "models/weapons/w_suitcase_passenger.mdl"

-- ITEM.replacements = {
--     {"models/limefruitbmce/guard.mdl", "models/limefruitbmce/hev_guard.mdl"},
--     {"models/limefruitbmce/guard_02.mdl", "models/limefruitbmce/hev_guard.mdl"},
--     {"models/limefruitbmce/guard_03.mdl", "models/limefruitbmce/hev_guard.mdl"},
--     {"models/limefruitbmce/scientist.mdl", "models/limefruitbmce/hev_scientist.mdl"},
--     {"models/limefruitbmce/scientist_02.mdl", "models/limefruitbmce/hev_scientist.mdl"},
--     {"models/limefruitbmce/scientist_03.mdl", "models/limefruitbmce/hev_scientist03.mdl"},
--     {"models/humans/limefruit/guard_sleeveless.mdl", "models/limefruitbmce/hev_scientist03.mdl"},
--     {"models/humans/scientist_female", "models/player/hev_female.mdl"},
--     {"models/limefruitbmce/scientist_female.mdl", "models/limefruitbmce/hev_female.mdl"}
-- }

ITEM.replacements = "models/limefruit/hev/male.mdl"

-- ITEM.functions.toggleHelmet = {
-- 	name = "Toggle Helmet",
-- 	tip = "toggleHelmetTip",
-- 	icon = "icon16/tick.png",
-- 	OnRun = function(item)
--         if SERVER then
--             if item.toggleHelmetBodygroup then
--                 local newGroup = item.player:GetBodygroup(item.toggleHelmetBodygroup) == 0 and 1 or 0
--                 item.player:SetNetVar("toggleHelmetStatus", newGroup == 1 and true or false)
--                 item.player:SetBodygroup(item.toggleHelmetBodygroup, newGroup)
--             else
--                 item.player:Notify("Cannot find helmet bodygroup.")
--             end
-- 		end

--         return false
-- 	end,
--     OnCanRun = function( item )
--         return item:GetData("equip", false)
--     end
-- }

-- function ITEM:OnEquipped()
--     for _, bodygroup in pairs(self.player:GetBodyGroups()) do
--         if bodygroup.name == "helmet" then
--             self.toggleHelmetBodygroup = bodygroup.id
--             break
--         end
--     end
-- end

function ITEM:PaintOver(item, w, h)
    if item:GetData("equip", false) then    
        surface.SetDrawColor(110, 255, 110, 100)
        surface.DrawRect(w - 14, h - 14, 8, 8)
    else
        surface.SetDrawColor(255, 110, 110, 100)
        surface.DrawRect(w - 14, h - 14, 8, 8)
        return
    end

    -- if LocalPlayer():GetNetVar("toggleHelmetStatus", false) then
    --     surface.SetDrawColor(110, 255, 110, 100)
    -- else
    --     surface.SetDrawColor(255, 110, 110, 100)
    -- end
    surface.DrawRect(w - 12, h - 12, 8, 8)
end

function ITEM:GetDescription()
    if self:GetData("equip", false) then
        -- return self.description .. "\nSuit: " .. (self:GetData("equip", false) == true and "Equipped" or "Unequipped") .. "\nHelmet: " .. (LocalPlayer():GetNetVar("toggleHelmetStatus", false) == true and "Equipped" or "Unequipped")
        return self.description .. "\nSuit: " .. (self:GetData("equip", false) == true and "Equipped" or "Unequipped")
    else
        return self.description
    end
end
