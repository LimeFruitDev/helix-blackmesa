util.AddNetworkString("ixTutorialFinished")

net.Receive("ixTutorialFinished", function( _, client )
	client:SetData("ixTutorialFinished", true)
end)
