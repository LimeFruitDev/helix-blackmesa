
	local PLUGIN = PLUGIN

	local function s(px) return ScrW()/(ScrW()/px) end

	local function LerpColor(t,fromc,toc)

	return Color(
		Lerp(t,fromc.r,toc.r),
		Lerp(t,fromc.g,toc.g),
		Lerp(t,fromc.b,toc.b),
		Lerp(t,fromc.a,toc.a)
		)

	end

	PLUGIN.ShouldDraw = {

		CHudBattery = false,
		
		CHudHealth = false,
		CHudDamageIndicator = false,
		
		CHudAmmo = false,
		CHudSecondaryAmmo = false,

		CHudZoom = false,
		
		CHudPoisonDamageIndicator = false,
		CHudGeiger = false,

		CHudWeaponSelection = false,
		CHUDQuickInfo = false,
	
	}

	local paths = {
	"C:/HEV/main/voice.dat",
	"C:/HEV/main/standby.exe",
	"C:/HEV/system/controls/ui.theme",
	"C:/HEV/faa709c5035aea00f9efb278f2ad5df0.dat",
	"C:/HEV/system/helpers/cardio.dll",
	"C:/HEV/system/helpers/geiger.dll",
	"C:/HEV/system/helpers/battery.dll",
	"C:/HEV/system/b367c/poison.detect",
	"C:/HEV/system/b367c/ammo_counter.detect",
	"C:/HEV/wholecheck.dll",
	"C:/HEV/Health System.exe",
	"C:/HEV/Ammo System.exe",
	"C:/HEV/FirmwareHEV.sys",
	"-----------------------------"
	}

	local timers = {}

	local lines = {}
	local function paths_calculate_hidetime(text) return string.len(text)*.09 + 1 end

	local function addPathNotify(text)

	local index = table.insert(lines,{

		text = text,
		symbols = 0,
		x = s(10),
		y = ScrH()/2.5,
		time = CurTime() + paths_calculate_hidetime(text)*2.5

	})
	local tindex = tostring(index)..tostring(math.random(1,5))
	table.insert(timers,"hevSuit.pathnotify_expandline"..tindex)
	timer.Create("hevSuit.pathnotify_expandline"..tindex,.05,string.len(text),function()

	if istable(lines[index]) then lines[index].symbols = lines[index].symbols+1 end

	end) -- timer
	end -- addPathNotify

	hook.Add("HUDShouldDraw","PLUGIN.ShouldDraw",function(el) if PLUGIN.ShouldDraw[el] then return false end end)







	----------------------------------------------

	local center_notifies = {}
	local function addCenterNotify(text)


	local index = table.insert(center_notifies,{

		text = text,
		x = ScrW()/2,
		y = ScrH()/2,
		time = CurTime() + 5

	})	



	end

	----------------------------------------------


	--[[-------------------------------------------------------------------------
	Title
	---------------------------------------------------------------------------]]

	local hev_suit_material_undefined = true
	local hev_suit_material_shoulddraw = false

	------------------

	local percent = 0
	local lp_x,lp_y = 0,0
	local flicker_alpha = 0
	local bw,bt = s(500),s(20)
	local draw_color = PLUGIN.HUDColor

	local draw_hevlogo = true
	
	local function HEV_First()

	lp_x,lp_y = s(math.random(0,1)),s(math.random(0,1))
	flicker_alpha = math.random(10,40)
	draw_color = ColorAlpha(PLUGIN.HUDColor,130+flicker_alpha)


	draw.RoundedBox(s(5),ScrW()/2-bw/2 + lp_x,ScrH()/2 + lp_y,bw,bt,draw_color)
	draw.RoundedBox(s(5),ScrW()/2-bw/2 + lp_x,ScrH()/2 + lp_y,bw*(percent/100),bt,draw_color)

	draw.SimpleText("Initializing...","hevSuit.ConsolasL",ScrW()/2-bw/2 + lp_x+1,ScrH()/2 + lp_y - bt - s(3)+1,color_black,TEXT_ALIGN_LEFT)
	draw.SimpleText(percent.."%","hevSuit.ConsolasL",ScrW()/2-bw/2 + lp_x + bw+1,ScrH()/2 + lp_y - bt - s(3)+1,color_black,TEXT_ALIGN_RIGHT)
	
	draw.SimpleText("Initializing...","hevSuit.ConsolasL",ScrW()/2-bw/2 + lp_x,ScrH()/2 + lp_y - bt - s(3),draw_color,TEXT_ALIGN_LEFT)
	draw.SimpleText(percent.."%","hevSuit.ConsolasL",ScrW()/2-bw/2 + lp_x + bw,ScrH()/2 + lp_y - bt - s(3),draw_color,TEXT_ALIGN_RIGHT)

	if draw_hevlogo then 
		draw.SimpleText("HEV (Hazardous Environment) Mark IV","hevSuit.MarkIV",ScrW()/2+lp_x+1,ScrH()/2-bt/2-s(90)+lp_y+1,color_black,TEXT_ALIGN_CENTER) 
		draw.SimpleText("HEV (Hazardous Environment) Mark IV","hevSuit.MarkIV",ScrW()/2+lp_x,ScrH()/2-bt/2-s(90)+lp_y,draw_color,TEXT_ALIGN_CENTER) 
	end

	end

	local function HEV_Path()

	local by = ScrH()/2.5

	for k,v in pairs(lines) do 
		draw.SimpleText(string.sub(v.text,0,v.symbols).."...","hevSuit.ConsolasB",v.x+lp_x+1,v.y+lp_y+1,color_black)
		draw.SimpleText(string.sub(v.text,0,v.symbols).."...","hevSuit.ConsolasB",v.x+lp_x,v.y+lp_y,draw_color)
		v.y = Lerp(FrameTime()*10, v.y, by+(k-1)*s(30) )
	end

	for k,v in pairs(lines) do if v.time < CurTime() then table.remove( lines, k ) end end
	
	end

	----------------

	local rhdc = Color(200,40,40,100)
	local rhdc_al = 0
	local rhdc_blockal = true
	local rh_mat = Material("hev/suit.png","smooth")

	local hev_weight
	local hev_weight_text = "WEIGHT: CALCULATING..."

	local hev_hull_txt = "HEIGHT: CALCULATING..."

	local function HEV_RightHEVSuitMaterial()

	if not hev_suit_material_shoulddraw then return end

	hev_weight = 192.73

	rhdc = LerpColor(FrameTime() * 5,rhdc,hev_suit_material_undefined and Color(200,40,40,100) or PLUGIN.HUDColor)
	rhdc_al = math.abs( math.sin(CurTime()*3)*100 )
	rhdc = ColorAlpha(rhdc,rhdc_al+flicker_alpha)
	if rhdc_blockal then rhdc = ColorAlpha(rhdc,130+flicker_alpha) end

	surface.SetDrawColor(rhdc)
	surface.SetMaterial(rh_mat)
	surface.DrawTexturedRect(ScrW() - s(130) - s(166) + lp_x, ScrH()/2 - s(203) + lp_y,s(166),s(406))

	if not hev_suit_material_undefined then hev_weight_text = "WEIGHT: "..hev_weight.." LB" hev_hull_txt = "HEIGHT: 5FT. 11.986 IN" end

	draw.SimpleText(hev_weight_text,"hevSuit.SuitInfo",ScrW()-s(130)-s(166/2)+lp_x+1,ScrH()/2+s(195)+lp_y+1,color_black,TEXT_ALIGN_CENTER)
	draw.SimpleText(hev_hull_txt,"hevSuit.SuitInfo",ScrW()-s(130)-s(166/2)+lp_x+1,ScrH()/2+s(195)+lp_y+s(25)+1,color_black,TEXT_ALIGN_CENTER)
	
	draw.SimpleText(hev_weight_text,"hevSuit.SuitInfo",ScrW()-s(130)-s(166/2)+lp_x,ScrH()/2+s(195)+lp_y,rhdc,TEXT_ALIGN_CENTER)
	draw.SimpleText(hev_hull_txt,"hevSuit.SuitInfo",ScrW()-s(130)-s(166/2)+lp_x,ScrH()/2+s(195)+lp_y+s(25),rhdc,TEXT_ALIGN_CENTER)

	end

	---------------

	local hev_suit_poison_shoulddraw = false
	local hev_suit_poison_undefined = true
	local hev_suit_poison_flicker = true
	local rp_mat = Material("hev/hc_types.png","smooth")

	local rhpc = Color(200,40,40,100)

	local function HEV_RightHEVPoisonMaterial()

	if not hev_suit_poison_shoulddraw then return end
	
	rhpc = LerpColor(FrameTime() * 5,rhpc,hev_suit_poison_undefined and Color(200,40,40,100) or PLUGIN.HUDColor)
	rhpc = ColorAlpha(rhpc,rhdc_al+flicker_alpha)
	if not hev_suit_poison_flicker then rhpc = ColorAlpha(rhpc,130+flicker_alpha) end

	surface.SetDrawColor(rhpc)
	surface.SetMaterial(rp_mat)
	surface.DrawTexturedRect(s(10)+lp_x,ScrH()-s(210)+lp_y,s(736),s(92))


	end

	--[[-------------------------------------------------------------------------
	Title
	---------------------------------------------------------------------------]]

	local function HEV_DrawCenterLog()
		--hevSuit.SuitInfo

	local by = ScrH()/2+s(30)

	for k,v in pairs(center_notifies) do 
		draw.SimpleText(v.text,"hevSuit.ConsolasB",v.x+lp_x+1,v.y+lp_y+1,color_black,TEXT_ALIGN_CENTER)
		draw.SimpleText(v.text,"hevSuit.ConsolasB",v.x+lp_x,v.y+lp_y,draw_color,TEXT_ALIGN_CENTER)
		v.y = Lerp(FrameTime()*10, v.y, by+(k-1)*s(25) )
	end

	for k,v in pairs(center_notifies) do if v.time < CurTime() then table.remove( center_notifies, k ) end end

	end

	--[[-------------------------------------------------------------------------
	Title
	---------------------------------------------------------------------------]]

	local function DrawHEVSuit()

	HEV_First()
	HEV_Path()
	HEV_RightHEVSuitMaterial()
	HEV_RightHEVPoisonMaterial()
	HEV_DrawCenterLog()	

	end

	function HEV_RestoreDefaults()

	hev_suit_material_undefined = true
	hev_suit_material_shoulddraw = false
	hev_suit_poison_shoulddraw = false
	hev_suit_poison_undefined = true
	hev_suit_poison_flicker = true
	percent = 0
	lp_x,lp_y = 0,0
	flicker_alpha = 0
	bw,bt = s(500),s(20)
	draw_color = PLUGIN.HUDColor
	rhdc = Color(200,40,40,100)
	rhpc = Color(200,40,40,100)
	rhdc_al = 0
	rhdc_blockal = true
	draw_hevlogo = true
	hev_hull_txt = "HEIGHT: CALCULATING..."
	lines = {}
	center_notifies = {}
	hev_weight_text = "WEIGHT: CALCULATING..."
	PLUGIN.ShouldDraw = {

		CHudBattery = false,
		
		CHudHealth = false,
		CHudDamageIndicator = false,
		
		CHudAmmo = false,
		CHudSecondaryAmmo = false,

		CHudZoom = false,
		
		CHudPoisonDamageIndicator = false,
		CHudGeiger = false,

		CHudWeaponSelection = false,
		CHUDQuickInfo = false,
	
	}

	-----------------------------------------

	hook.Remove("HUDPaint","hev.DrawHEVSuit")
	RunConsoleCommand("stopsound") --remove this if u wanna activate death sounds
	timer.Remove("hev_percent")
	timer.Remove("hev_end")
	for k,v in pairs(timers) do timer.Remove(v) timer.Remove("hev_g1"..k) end 
	timers = {}

	timer.Remove("hev_1")
	timer.Remove("hev_2")
	timer.Remove("hev_3")
	timer.Remove("hev_4")
	timer.Remove("hev_5")
	timer.Remove("hev_6")
	timer.Remove("hev_7")
	timer.Remove("hev_8")
	timer.Remove("hev_9")
	timer.Remove("hev_10")
	timer.Remove("hev_11")
	timer.Remove("hev_12")
	timer.Remove("hev_13")
	timer.Remove("hev_14")
	timer.Remove("hev_15")
	timer.Remove("hev_16")
	timer.Remove("hev_startlog")

	hook.Call("inSuit.UpdateHands",nil,player_manager.TranslatePlayerHands( LocalPlayer().OldModel ))

	end


	--[[-------------------------------------------------------------------------
	---------------------------------------------------------------------------]]

	local function PrepareSuit()

	surface.PlaySound("hevsuit/startup.mp3")
	hook.Add("HUDPaint","hev.DrawHEVSuit",DrawHEVSuit)	
	
	timer.Create("hev_end",60,1,function() hook.Remove("HUDPaint","hev.DrawHEVSuit") end)
	timer.Create("hev_percent",.4,100,function() percent = percent + 1 end)

	-------------------
	timer.Create("hev_startlog",1,1,function()
	for k,v in pairs(paths) do 
	timer.Create("hev_g1"..k,k*.4 + paths_calculate_hidetime(v)*1.5,1,function() addPathNotify(v) end) 
	end
	end)
	-------------------

	timer.Create("hev_2",5,1,function() hev_suit_material_shoulddraw = true draw_hevlogo = false end)
	timer.Create("hev_3",11,1,function() PLUGIN.ShouldDraw["CHudBattery"] = false hev_suit_material_undefined = false rhdc_blockal = false addCenterNotify("IMPACT ARMOR ACTIVATED") end) --  (remove the armor from the side CHudBattery)
	
	timer.Create("hev_4",13,1,function() rhdc_blockal = true end)
	timer.Create("hev_5",15,1,function() PLUGIN.ShouldDraw["CHudPoisonDamageIndicator"] = false PLUGIN.ShouldDraw["CHudGeiger"] = false rhdc_blockal = false hev_suit_poison_shoulddraw = true addCenterNotify("POISON I-V SENSOR ACTIVATED") end) --  (material with tz, CHudPoisonDamageIndicator)

	timer.Create("hev_6",16,1,function() rhdc_blockal = true hev_suit_poison_flicker = false end)
	timer.Create("hev_7",17.5,1,function() hev_suit_poison_flicker = true hev_suit_poison_undefined = false end)
	timer.Create("hev_8",18.5,1,function() hev_suit_poison_flicker = false end)
	timer.Create("hev_9",19,1,function() hev_suit_poison_flicker = true end)
	timer.Create("hev_10",23,1, function() hev_suit_poison_shoulddraw = false addCenterNotify("VITAL SIGNS MONITORING ACTIVATED") end)

	timer.Create("hev_11",19,1,function() PLUGIN.ShouldDraw["CHudHealth"] = false PLUGIN.ShouldDraw["CHudDamageIndicator"] = false hev_suit_material_shoulddraw = false addCenterNotify("ATMOSPHERIC CONTAMINANT SENSORS ACTIVATED") end) -- 
	timer.Create("hev_12",27,1,function() PLUGIN.ShouldDraw["CHudZoom"] = false PLUGIN.ShouldDraw["CHudWeaponSelection"] = false addCenterNotify("DEFENSIVE WEAPON SELECTION SYSTEM ACTIVATED") end) -- (CHudZoom)
	timer.Create("hev_13",32,1,function() PLUGIN.ShouldDraw["CHudAmmo"] = false PLUGIN.ShouldDraw["CHudSecondaryAmmo"] = false PLUGIN.ShouldDraw["CHUDQuickInfo"] = false addCenterNotify("MUNITION LEVEL MONITORING ACTIVATED") end) -- 

	timer.Create("hev_14",36,1,function() addCenterNotify("COMMUNICATION DEVICE ONLINE") end)
	timer.Create("hev_15",39,1,function() addCenterNotify("HAVE A VERY SAFE DAY") end)

	timer.Create("hev_16",54,1,function() addCenterNotify(":/Process Completed Closing Window/:") end)

	end

	net.Receive("hevsuit_send",PrepareSuit)

	surface.CreateFont("hevSuit.ConsolasL",{font = "Consolas", size = s(20), weight = s(300), extended = true})
	surface.CreateFont("hevSuit.ConsolasB",{font = "Consolas", size = s(27), weight = s(600), extended = true})
	surface.CreateFont("hevSuit.MarkIV",{font = "Roboto Black", size = s(80), weight = s(1000), italic = true, blursize = s(2), extended = true})
	surface.CreateFont("hevSuit.SuitInfo",{font = "Roboto", size = s(23), weight = s(600), extended = true})
