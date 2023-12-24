include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_canteen/soda_machine.mdl")

	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetStock(math.random(1, 15), true)

	self:EmitSound("limefruit/vendingmachinehum.wav", 50, 100, 1)

	-- Get vending machine items.
	self.items = {}

	for name, item in pairs(ix.item.list) do
		if (string.match(name, "soda")) then
			self.items[#self.items + 1] = name
		end
	end
end

-- Called when the entity gets removed.
function ENT:OnRemove()
	self:StopSound("limefruit/vendingmachinehum.wav")
end

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

-- A function to create the entity's water.
function ENT:CreateWater(activator)
	self:GiveStock(-1)
	self:EmitSound("buttons/button4.wav")
	self:SetFlashDuration(3, true)

	local item = self.items[math.random(1, #self.items)]
	local position = self:GetPos()
	local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()

	ix.item.Spawn(item, position + f*4.5 + r*-17 + u*25, nil, Angle(-90, 0, 0))
end

-- A function to get the entity's default stock.
function ENT:GetDefaultStock()
	return self.defaultStock or 0
end

-- A function to give stock to the entity.
function ENT:GiveStock(amount)
	self:SetStock(math.Clamp(self:GetStock() + amount, 0, self:GetDefaultStock()))
end

-- A function to set the entity's stock.
function ENT:SetStock(amount, default)
	self:SetDTInt(0, amount)

	if (default) then
		if (type(default) == "number") then
			self.defaultStock = default
		else
			self.defaultStock = amount
		end
	end
end

-- A function to restock the entity.
function ENT:Restock()
	self:SetFlashDuration(3, true)
	self:EmitSound("buttons/button5.wav")
	self:SetStock( self:GetDefaultStock() )
end

-- A function to set the entity's flash duration.
function ENT:SetFlashDuration(duration, action)
	self:SetDTFloat(0, CurTime() + duration)

	if (action) then
		self:SetDTBool(0, true)
	else
		self:EmitSound("buttons/button2.wav")
		self:SetDTBool(0, false)
	end
end

-- Called when the entity's physics should be updated.
function ENT:PhysicsUpdate(physicsObject)
	if (!self:IsPlayerHolding() and !self:IsConstrained()) then
		physicsObject:SetVelocity( Vector(0, 0, 0) )
		physicsObject:Sleep()
	end
end

-- Called when the entity is used.
function ENT:Use(activator, caller)
	if (activator:IsPlayer() and activator:GetEyeTraceNoCursor().Entity == self) then
		local curTime = CurTime()

		if (!self.nextUse or curTime >= self.nextUse) then
			if (curTime > self:GetDTFloat(0)) then
				self.nextUse = curTime + 3

				if (activator:GetChar():GetFaction() == FACTION_MAINTENANCE and activator:KeyDown(IN_SPEED)) then
					self:Restock()
				else
					if (self:GetStock() == 0 or !activator:GetChar():HasMoney(5)) then
						self:SetFlashDuration(3)
						if !(activator:GetChar():HasMoney(5)) then
							activator:Notify("You need "..ix.currency.Get(5).." to use this vending machine.")
						end

						return
					elseif (!activator.nextVendingMachine or curTime >= activator.nextVendingMachine) then
						self:CreateWater(activator)
						
						activator.nextVendingMachine = curTime + 600
						
						activator:GetChar():TakeMoney(5)
						activator:Notify("You have spent "..ix.currency.Get(5).." on this vending machine.")
					else
						self:SetFlashDuration(3)
					end
				end
			end
		end
	end
end

-- Called when a player attempts to use a tool.
function ENT:CanTool(player, trace, tool)
	return false
end
