PLUGIN.name = "Radio"
PLUGIN.author = "Black Tea & Zoephix"
PLUGIN.description = "You can communicate with other people in distance."

local RADIO_CHAT_COLOR = Color(100, 255, 50)
local OOC_RADIO_CHAT_COLOR = Color(0, 127, 31)
local DEPARTMENTS_CHAT_COLOR = Color(255, 100, 50)
local EMERGENCY_CHAT_COLOR = Color(255, 0, 0)
local REQUESTS_CHAT_COLOR = Color(255, 130, 0)

local langkey = "english"
do
	local langTable = {
		radioFreq = "Frequency",
		radioSubmit = "Submit",
		radioNoRadio = "You don't have any radio to adjust.",
		radioNoRadioComm = "You don't have any radio to communicate",
		radioFormat = "%s radios in: \"%s\"",
	}

	table.Merge(ix.lang.stored[langkey], langTable)
end

if (CLIENT) then
	surface.CreateFont("ix_C_RADIO", {
		font = mainFont,
		size = 24,
		weight = 1000,
		antialias = true
	})

	local PANEL = {}
	function PANEL:Init()
		self.number = 0
		self:SetWide(70)

		local up = self:Add("DButton")
		up:SetFont("Marlett")
		up:SetText("t")
		up:Dock(TOP)
		up:DockMargin(2, 2, 2, 2)
		up.DoClick = function(this)
			self.number = (self.number + 1)% 10
			surface.PlaySound("buttons/lightswitch1.wav")
		end

		local down = self:Add("DButton")
		down:SetFont("Marlett")
		down:SetText("u")
		down:Dock(BOTTOM)
		down:DockMargin(2, 2, 2, 2)
		down.DoClick = function(this)
			self.number = (self.number - 1)% 10
			surface.PlaySound("buttons/lightswitch2.wav")
		end

		local number = self:Add("Panel")
		number:Dock(FILL)
		number.Paint = function(this, w, h)
			draw.SimpleText(self.number, "ixDialFont", w/2, h/2, color_white, 1, 1)
		end
	end

	vgui.Register("ixRadioDial", PANEL, "DPanel")

	PANEL = {}

	function PANEL:Init()
		self:SetTitle(L("radioFreq"))
		self:SetSize(330, 220)
		self:Center()
		self:MakePopup()

		self.submit = self:Add("DButton")
		self.submit:Dock(BOTTOM)
		self.submit:DockMargin(0, 5, 0, 0)
		self.submit:SetTall(25)
		self.submit:SetText(L("radioSubmit"))
		self.submit.DoClick = function()
			local str = ""
			for i = 1, 5 do
				if (i != 4) then
					str = str .. tostring(self.dial[i].number or 0)
				else
					str = str .. "."
				end
			end
			netstream.Start("radioAdjust", str, self.itemID)

			self:Close()
		end

		self.dial = {}
		for i = 1, 5 do
			if (i != 4) then
				self.dial[i] = self:Add("ixRadioDial")
				self.dial[i]:Dock(LEFT)
				if (i != 3) then
					self.dial[i]:DockMargin(0, 0, 5, 0)
				end
			else
				local dot = self:Add("Panel")
				dot:Dock(LEFT)
				dot:SetWide(30)
				dot.Paint = function(this, w, h)
					draw.SimpleText(".", "ixDialFont", w/2, h - 10, color_white, 1, 4)
				end
			end
		end
	end

	function PANEL:Think()
		self:MoveToFront()
	end

	vgui.Register("ixRadioMenu", PANEL, "DFrame")

	surface.CreateFont("ixDialFont", {
		font = "Agency FB",
		extended = true,
		size = 100,
		weight = 1000
	})

	netstream.Hook("radioAdjust", function(freq, id)
		local adjust = vgui.Create("ixRadioMenu")

		if (id) then
			adjust.itemID = id
		end

		if (freq) then
			for i = 1, 5 do
				if (i != 4) then
					adjust.dial[i].number = tonumber(freq[i])
				end
			end
		end
	end)
else
	netstream.Hook("radioAdjust", function(client, freq, id)
		local inv = (client:GetCharacter() and client:GetCharacter():GetInventory() or nil)

		if (inv) then
			local item

			if (id) then
				item = ix.item.instances[id]
			else
				item = inv:hasItem("radio")
			end

			local ent = item:GetEntity()

			if (item and (IsValid(ent) or item:GetOwner() == client)) then
				(ent or client):EmitSound("buttons/combine_button1.wav", 50, 170)

				item:SetData("freq", freq)
			else
				client:Notify(L("radioNoRadio"))
			end
		end
	end)
end

local find = {
	["radio"] = false,
	["sradio"] = true
}

local function endChatter(listener)
	timer.Simple(1, function()
		if (!listener:IsValid() or !listener:Alive()) then
			return false
		end

		listener:EmitSound("npc/metropolice/vo/off"..math.random(1, 3)..".wav", math.random(60, 70), math.random(80, 120))
	end)
end

local function canSayRadio(self, speaker, text)
	local schar = speaker:GetCharacter()
	local speakerInv = schar:GetInventory()
	local freq

	if (GetGlobalBool("comFailed")) then
		speaker:ChatPrint("Communication servers are down.")

		return false
	end

	if (speakerInv) then
		for k, v in pairs(speakerInv:GetItems()) do
			if (freq) then
				break
			end

			for id, far in pairs(find) do
				if (v.uniqueID == id and v:GetData("power", false) == true) then
					freq = v:GetData("freq", "000.0")

					break
				end
			end
		end
	end

	if (freq) then
		CURFREQ = freq
		speaker:EmitSound("npc/metropolice/vo/on"..math.random(1, 2)..".wav", math.random(50, 60), math.random(80, 120))
	else
		speaker:Notify("You need a radio and have it online.")
		return false
	end
end

local function globalCanHear(self, speaker, listener)
	local dist = speaker:GetPos():Distance(listener:GetPos())
	local speakRange = ix.config.Get("chatRange", 280)
	local listenerInv = listener:GetCharacter():GetInventory()

	if (dist <= speakRange) then
		return true
	end

	if (listenerInv) then
		for k, v in pairs(listenerInv:GetItems()) do
			if (freq) then
				break
			end

			if (v:GetData("power", false) == true) then
				endChatter(listener)

				return true
			end
		end
	end

	return false
end

ix.chat.Register("radio", {
	format = "%s radios in: \"%s\"",
	GetColor = function(speaker, text)
		return RADIO_CHAT_COLOR
	end,
	CanHear = function(self, speaker, listener)
		local dist = speaker:GetPos():Distance(listener:GetPos())
		local speakRange = ix.config.Get("chatRange", 280)
		local listenerInv = listener:GetCharacter():GetInventory()
		local freq

		if (!CURFREQ or CURFREQ == "") then
			return false
		end

		if (dist <= speakRange) then
			return true
		end

		if (listenerInv) then
			for k, v in pairs(listenerInv:GetItems()) do
				if (freq) then
					break
				end

				for id, far in pairs(find) do
					if (v.uniqueID == id and v:GetData("power", false) == true) then
						if (CURFREQ == v:GetData("freq", "000.0")) then
							endChatter(listener)

							return true
						end

						break
					end
				end
			end
		end

		return false
	end,
	CanSay = canSayRadio,
	prefix = {"/r", "/radio"},
})

ix.chat.Register("or", {
    prefix = {"/or", "/oocradio"},
	format = "(( %s radios in: \"%s\" ))",
	GetColor = function(speaker, text)
		return OOC_RADIO_CHAT_COLOR
	end,
    CanSay = function(self, speaker, text)
        local schar = speaker:GetCharacter()
        local speakerInv = schar:GetInventory()
        local freq

        if (GetGlobalBool("comFailed")) then
            speaker:ChatPrint("Communication servers are down.")

            return false
        end

        if (speakerInv) then
            for k, v in pairs(speakerInv:GetItems()) do
                if (freq) then
                    break
                end

                for id, far in pairs(find) do
					freq = v:GetData("freq", "000.0")

                    break
				end
            end
        end

        if (freq) then
            CURFREQ = freq
		else
            speaker:Notify("You need a radio and have it online.")
            return false
        end
    end,
	CanHear = function(self, speaker, listener)
		local dist = speaker:GetPos():Distance(listener:GetPos())
		local speakRange = ix.config.Get("chatRange", 280)
		local listenerInv = listener:GetCharacter():GetInventory()
		local freq

		if (!CURFREQ or CURFREQ == "") then
			return false
		end

		if (dist <= speakRange) then
			return true
		end

		if (listenerInv) then
			for k, v in pairs(listenerInv:GetItems()) do
				if (freq) then
					break
				end

				for id, far in pairs(find) do
					if (v.uniqueID == id and v:GetData("power", false) == true) then
						if (CURFREQ == v:GetData("freq", "000.0")) then
							endChatter(listener)

							return true
						end

						break
					end
				end
			end
		end

		return false
	end,
})

ix.chat.Register("departments", {
	format = "%s radios in: \"%s\"",
	GetColor = function(speaker, text)
		return DEPARTMENTS_CHAT_COLOR
	end,
	CanHear = globalCanHear,
	CanSay = canSayRadio,
	prefix = {"/d", "/dep", "/departments"},
})

ix.chat.Register("emergency", {
	format = "%s radios in emergency: \"%s\"",
	GetColor = function(speaker, text)
		return EMERGENCY_CHAT_COLOR
	end,
	CanHear = globalCanHear,
	CanSay = canSayRadio,
	prefix = {"/e", "/emergency"},
})

ix.chat.Register("request", {
	format = "%s requests: \"%s\"",
	GetColor = function(speaker, text)
		return REQUESTS_CHAT_COLOR
	end,
	CanHear = globalCanHear,
	CanSay = canSayRadio,
	prefix = {"/req", "/request"},
})
