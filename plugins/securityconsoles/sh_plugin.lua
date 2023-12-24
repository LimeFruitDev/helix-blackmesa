--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

PLUGIN.name = "Security Consoles"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Adds various security monitoring consoles."

ix.security = ix.security or {}
ix.security.log = ix.security.log or {}
ix.security.radiolog = ix.security.radiolog or {}

-- Include plugin files.
ix.util.Include( "sh_config.lua" )
ix.util.Include( "sv_plugin.lua" )

if (CLIENT) then
    -- Adds a new door log.
    netstream.Hook( "securityLog", function( log )
        table.insert( ix.security.log, log )
    
        if ( #ix.security.log > 30 ) then
            table.remove( ix.security.log, 1 )
        end
    end )

    -- Adds a new radio log.
    netstream.Hook("securityRadioLog", function( speaker, chatType, time, frequency, text )
        local color = ix.chat.classes[chatType]:GetColor()
        local text = string.format(ix.chat.classes[chatType].format, speaker:GetName(), text)
        local msg = {time=os.time(), color=color, time=time, frequency=frequency, text=text}

        table.insert(ix.security.radiolog, msg)

        if (#ix.security.radiolog > 30) then
            table.remove(ix.security.radiolog, 1)
        end
    end)

    -- Prompt with door controls.
	netstream.Hook("securityLogStart", function()
        local Frame = vgui.Create("DFrame")
        Frame:SetPos(0, 300)
        Frame:SetSize(300, 500)
        Frame:SetTitle("Security Console Prompt")
        Frame:MakePopup()

        local Notice = vgui.Create("ixNoticeBar", Frame)
        Notice:Dock( TOP )
        Notice:DockMargin( 0, 0, 0, 5 )
        Notice:SetType( 4 )
        Notice:SetText( "Black Mesa Door Network" )

        local List = vgui.Create("DListView", Frame)
        List:Dock( FILL )
        List:DockMargin( 0, 0, 0, 5 )
        List:SetMultiSelect(false)
        List:AddColumn("Doors")

        for i = 1, #ix.security.consoleEnabledDoors do
            local entName = ix.security.consoleEnabledDoors[ i ]
            local doorName = ix.security.doorNames[ entName ]

            List:AddLine( doorName, entName )
        end

        function List:OnRowSelected(id, line)
            netstream.Start("securityLogDoorOpen", line:GetColumnText(2), line:GetColumnText(1))
        end
    end)
end
