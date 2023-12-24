local PLUGIN = PLUGIN
PLUGIN.name = "CCTV"
PLUGIN.author = "Zoephix & _FR_Starfox64"
PLUGIN.description = "The administration is watching!"
PLUGIN.securitycamDistance = 150

ix.util.Include("sv_plugin.lua")

ix.command.Add("cctvcreate", {
	adminOnly = true,
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, cameraName)
		local ent = ents.Create("bmrp_cam")
		ent:SetPos(client:GetPos())
		ent:SetNWString("name", cameraName)
		ent:Spawn()
		ent:Activate()
	end
})


if (CLIENT) then
	netstream.Hook("cctvStart", function()
		local Frame = vgui.Create("DFrame")
		Frame:SetPos(0, 300)
		Frame:SetSize(300, 500)
		Frame:SetTitle("CCTV Prompt")
		Frame:MakePopup()

		local Notice = vgui.Create("ixNoticeBar", Frame)
		Notice:Dock( TOP )
		Notice:DockMargin( 0, 0, 0, 5 )
		Notice:SetType( 4 )
		Notice:SetText( "Black Mesa CCTV Network" )

		local List = vgui.Create("DListView", Frame)
		List:Dock( FILL )
		List:DockMargin( 0, 0, 0, 5 )
		List:SetMultiSelect(false)
		List:AddColumn("Cameras")

		for k,v in pairs(ents.FindByClass("bmrp_cam")) do
			if v:GetNWString("name", "Unknown") != "Unknown" then
		        List:AddLine(v:GetNWString("name"))
		    end
		end

		function List:OnRowSelected( id, line )
			netstream.Start("cctvUpdate", line:GetColumnText(1))
		end
	end)
end
