local PLUGIN = PLUGIN

PLUGIN.SoundLocations = PLUGIN.SoundLocations or {
	--[[
		rp_sectorc_limefruit_extended
	--]]
	-- Vector(-1397.419922, 4778.117676, -239.458862),
	-- Vector(-957.072205, 5174.497070, -111.209534),
	-- Vector(-416.506104, 3855.420166, 86.286423),
	-- Vector(-1039.909790, 3193.189209, -50.968826),
	-- Vector(-1263.243286, 2554.757813, 592.951111),
	-- Vector(-484.829071, 2558.615234, 605.112488),
	-- Vector(1279.817871, 1882.228027, 605.946106),
	-- Vector(449.214203, 1955.483643, 649.488708),
	-- Vector(-504.005341, 1324.594360, 752.868469),
	-- Vector(1387.236572, 2467.582764, 1178.377930),
	-- Vector(867.410828, 953.090759, 1153.364502)

	--[[
		rp_limefruit_sectorc_extended
	-- ]]
	Vector(695.782898, 1355.145020, 7548.794922),
	Vector(730.905701, 2336.264648, 7446.106445),
	Vector(792.097595, 2333.015869, 6915.072754),
	Vector( -96.324402, 1951.317017, 6953.214355),
	Vector(-1077.763428, 3312.584961, 6773.560547),
	Vector(-1877.491699, 1730.917847, 6736.267090),
	Vector(-1168.048340, 1348.882324, 7631.062988),
	Vector(-4487.195801, 1983.209595, 6141.551758),
	Vector(-5066.090332, 847.139832, 5786.973633),
	Vector(-480.285583, 3575.607666, 6864.525391),
	Vector(-1626.258911, 3572.322998, 6755.978516)
}

function PLUGIN:Think()
	if (!nextPlay or CurTime() > nextPlay) then
		local toPlaySound = "limefruit/announcements/"..math.Round(math.random(1,51))..".wav"

		for _, SoundLocation in pairs(self.SoundLocations) do
			sound.Play(toPlaySound, SoundLocation, 75, 100, 1)
		end

		nextPlay = CurTime() + math.random(30, 180)
	end
end
