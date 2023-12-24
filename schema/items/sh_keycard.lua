ITEM.name = "Keycard"
ITEM.description = "A flat piece of plastic for identification."
ITEM.model = "models/sky/cid.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 10
ITEM.iconCam = {
	pos = Vector( 57.848472595215, 48.591835021973, 35.289249420166 ),
	ang = Angle( 25, 220, 0 ),
	fov = 4.2223741746681,
}

-- Item function for assigning
ITEM.functions.Assign = {
    OnRun = function( item )
        -- Item owner
        local client = item.player

        -- Start a traceline to find the target
        local data = {}
            data.start    = client:EyePos()
            data.endpos    = data.start + client:GetAimVector() * 96
            data.filter    = client
        local target = util.TraceLine(data).Entity

        -- Check if the target is valid
        if (IsValid(target) and target:IsPlayer()) then
            if (!target:GetCharacter() or !target:GetCharacter():GetInv()) then
                client:NotifyLocalized("plyNotValid")

                return false
            end
        else
            client:NotifyLocalized("plyNotValid")

            return false
        end

        -- Generate the details
        item:SetData( "name", target:Name() )
        item:SetData( "id", math.random(10000, 99999) )

        -- Tell the player who assigned it
        client:Notify( "Successfully assigned this keycard to " .. "\"" .. target:Name() .. "\"." )

        return false
    end,
    OnCanRun = function( item )
        return item.player:HasClearances("A") or item.player:IsAdmin()
    end
}

function ITEM:GetDescription()
	local description = self.description .. "\nThis keycard belongs to " .. self:GetData("name", "no one") .. "."

	return description
end
