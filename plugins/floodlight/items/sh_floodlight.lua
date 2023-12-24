ITEM.name = "Flood Light"
ITEM.description = "A Flood Light capable of illuminating large areas."
ITEM.model = "models/props_c17/light_floodlight02_off.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 50

ITEM.functions.Place = {
    OnRun = function( item )
        local client = item.player
        local trace = client:GetEyeTraceNoCursor()
        local entity = ents.Create("bmrp_floodlight")

        entity:SetModel(item.model)
		entity:SetPos(trace.HitPos)
        entity:SetOwner(client)
		entity:Spawn()

        return true
    end
}
