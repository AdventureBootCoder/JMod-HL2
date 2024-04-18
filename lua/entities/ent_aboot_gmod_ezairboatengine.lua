-- AdventureBoots 2024
AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_gmod_ezmachine_base"
ENT.PrintName = "EZ Airboat engine"
ENT.Author = "Jackarunda"
ENT.Category = "JMod - EZ HL:2"
ENT.Information = ""
ENT.Spawnable = true
ENT.AdminSpawnable = true
--
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)
ENT.Model = "models/airboat_engine.mdl"
ENT.Mass = 45
--
ENT.StaticPerfSpecs={ 
	MaxElectricity = 100,
	MaxDurability = 100,
	Armor = 1.5
}

function ENT:CustomSetupDataTables()
	self:NetworkVar("Float", 1, "BladeSpeed")
end

local STATE_BROKEN, STATE_OFF, STATE_IDLING, STATE_SPINNING = -1, 0, 1, 2
--
if SERVER then
	function ENT:SetupWire()
		if not(istable(WireLib)) then return end
		local WireInputs = {"TurnOnOff [NORMAL]", "Spin [NORMAL]"}
		local WireInputDesc = {"1 turns on, 0 turns off", "Sets the desired speed and direction of spinning"}
		self.Inputs = WireLib.CreateInputs(self, WireInputs, WireInputDesc)
		--
		local WireOutputs = {"State [NORMAL]", "CurSpin [NORMAL]"}
		local WireOutputDesc = {"The state of the machine \n-1 is broken \n0 is off \n1 is on \n2 is speeling", "The current speed and direction of spin"}
		for _, typ in ipairs(self.EZconsumes) do
			if typ == JMod.EZ_RESOURCE_TYPES.BASICPARTS then typ = "Durability" end
			local ResourceName = string.Replace(typ, " ", "")
			local ResourceDesc = "Amount of "..ResourceName.." left"
			--
			local OutResourceName = string.gsub(ResourceName, "^%l", string.upper).." [NORMAL]"
			if not(istable(self.FlexFuels) and table.HasValue(self.FlexFuels, typ)) then
				table.insert(WireOutputs, OutResourceName)
				table.insert(WireOutputDesc, ResourceDesc)
			end
		end
		self.Outputs = WireLib.CreateOutputs(self, WireOutputs, WireOutputDesc)
	end

	function ENT:UpdateWireOutputs()
		if not istable(WireLib) then return end
		WireLib.TriggerOutput(self, "State", self:GetState())
		--WireLib.TriggerOutput(self, "Length", self.CurrentCableLength)
		for _, typ in ipairs(self.EZconsumes) do
			if typ == JMod.EZ_RESOURCE_TYPES.BASICPARTS then
				WireLib.TriggerOutput(self, "Durability", self.Durability)
			else
				local MethodName = JMod.EZ_RESOURCE_TYPE_METHODS[typ]
				if MethodName then
					local ResourceGetMethod = self["Get"..MethodName]
					if ResourceGetMethod then
						local ResourceName = string.Replace(typ, " ", "")
						WireLib.TriggerOutput(self, string.gsub(ResourceName, "^%l", string.upper), ResourceGetMethod(self))
					end
				end
			end
		end
	end

	function ENT:TriggerInput(iname, value)
		local State, Owner = self:GetState(), JMod.GetEZowner(self)
		if State < STATE_OFF then return end
		if iname == "TurnOnOff" then
			if value == 1 then
				self:TurnOn(Owner)
			elseif value == 0 then
				self:TurnOff(Owner)
			end
		elseif iname == "Spin" then
			self:SetThrottle(value)
		end
	end

	function ENT:CustomInit()
		self.NextUseTime = 0
		self.EZupgradable = false
		self.EZcolorable = false
		self.MaxBladeSpeed = 100
		self.DesiredBladeSpeed = 0
		self:SetBladeSpeed(0)
		self.FanSoundLoop = CreateSound(self, "vehicles/airboat/fan_blade_idle_loop1.wav")
		self.EngineSoundLoop = CreateSound(self, "vehicles/airboat/fan_motor_idle_loop1.wav")
	end

	function ENT:TurnOn()
		local State = self:GetState()
		if State < STATE_OFF then return end
		self.DesiredBladeSpeed = self.MaxBladeSpeed * 0.1
		self:EmitSound("vehicles/airboat/fan_motor_start1.wav", 60, 100)
		timer.Simple(1, function()
			if not IsValid(self) or (State < STATE_OFF) then return end
			self:SetState(STATE_IDLING)
			self:StartSound()
		end)
	end

	function ENT:TurnOff()
		if self:GetState() < STATE_IDLING then return end
		self:SetState(STATE_OFF)
		self.DesiredBladeSpeed = 0
		self:EmitSound("vehicles/airboat/fan_motor_shut_off1.wav", 60, 100)
		self:EndSound()
	end

	function ENT:SetThrottle(val)
		if self:GetState() < STATE_IDLING then return end
		self.DesiredBladeSpeed = math.Clamp(val, -self.MaxBladeSpeed, self.MaxBladeSpeed)
		self:EndSound()
		if (val > self.MaxBladeSpeed * 0.1) or (val < -self.MaxBladeSpeed * 0.1) then
			self.FanSoundLoop = CreateSound(self, "vehicles/airboat/fan_blade_fullthrottle_loop1.wav")
			self.EngineSoundLoop = CreateSound(self, "vehicles/airboat/fan_motor_fullthrottle_loop1.wav")
			self:SetState(STATE_SPINNING)
		else
			self:SetState(STATE_IDLING)
		end
		self:StartSound()
	end

	function ENT:StartSound()
		if not self.FanSoundLoop or not self.EngineSoundLoop then
			self.FanSoundLoop = CreateSound(self, "vehicles/airboat/fan_blade_idle_loop1.wav")
			self.EngineSoundLoop = CreateSound(self, "vehicles/airboat/fan_motor_idle_loop1.wav")
		end
		self.FanSoundLoop:Play()
		self.EngineSoundLoop:Play()
	end

	function ENT:EndSound()
		if self.FanSoundLoop then
			self.FanSoundLoop:Stop()
			self.FanSoundLoop = nil
		end
		if self.EngineSoundLoop then
			self.EngineSoundLoop:Stop()
			self.EngineSoundLoop = nil
		end
	end

	function ENT:Use(activator)
		if self.NextUseTime > CurTime() then return end
		self.NextUseTime = CurTime() + 1
		local State = self:GetState()
		local IsPly = (IsValid(activator) and activator:IsPlayer())
		local Alt = IsPly and activator:KeyDown(JMod.Config.General.AltFunctionKey)
		JMod.SetEZowner(self, activator)

		if State == JMod.EZ_STATE_BROKEN then
			JMod.Hint(activator, "destroyed", self)

			return
		end

		if State == STATE_OFF then
			self:TurnOn()
		else
			if Alt then
				if (self.DesiredBladeSpeed < self.MaxBladeSpeed) and not(self.DesiredBladeSpeed < 0) then
					self:SetThrottle(self.MaxBladeSpeed)
				elseif self.DesiredBladeSpeed > 0 then
					self:SetThrottle(-self.MaxBladeSpeed)
				elseif self.DesiredBladeSpeed < 0 then
					self:SetThrottle(self.MaxBladeSpeed * 0.1)
				end
			else
				self:TurnOff()
			end
		end
	end

	local ThinkRate = 66

	function ENT:Think()
		local Time, State = CurTime(), self:GetState()

		if State == STATE_BROKEN then
			self:EndSound()
			return
		end
		local CurSpeed = self:GetBladeSpeed()

		if State == STATE_SPINNING then
			if math.abs(CurSpeed) < 10 then
				self:SetState(STATE_IDLING)
			end
			local Phys = self:GetPhysicsObject()

			if IsValid(Phys) then
				Phys:ApplyForceCenter(self:GetRight() * CurSpeed * 500 / ThinkRate)
			end
		elseif State == STATE_IDLING then
			if math.abs(CurSpeed) > 10 then
				self:SetState(STATE_SPINNING)
			end
		end

		if State ~= STATE_OFF then
			if self.DesiredBladeSpeed ~= CurSpeed then
				self:SetBladeSpeed(math.Approach(math.Clamp(CurSpeed, -self.MaxBladeSpeed, self.MaxBladeSpeed), self.DesiredBladeSpeed, (self.DesiredBladeSpeed - CurSpeed) * 10 * FrameTime()))
				if math.abs(CurSpeed) < 50 then
					if self.FanSoundLoop then
						self.FanSoundLoop:Stop()
					end
					if math.abs(CurSpeed) > 5 then
						self.FanSoundLoop = CreateSound(self, "vehicles/airboat/fan_blade_idle_loop1.wav")
						self.FanSoundLoop:Play()
					end
				else
					if self.FanSoundLoop then
						self.FanSoundLoop:Stop()
					end
					self.FanSoundLoop = CreateSound(self, "vehicles/airboat/fan_blade_fullthrottle_loop1.wav")
					self.FanSoundLoop:Play()
				end
			end
			self:UpdateWireOutputs()
		end

		self:NextThink(Time + (1 / ThinkRate))
		return true
	end

	function ENT:OnPostEntityPaste(ply, Ent, CreatedEntities)
		self:TurnOff()
	end

	function ENT:OnBreak()
		self:EndSound()
	end

	function ENT:OnRemove()
		self:EndSound()
	end

elseif CLIENT then
	function ENT:CustomInit()
		self:DrawShadow(true)
		self.Blade = JMod.MakeModel(self, "models/airboat_propeller.mdl")
		self.BladeTurn = 0
	end

	function ENT:Think()
		if self.ClientOnly then return end
		local Time, State, BladeSpeed = CurTime(), self:GetState(), self:GetBladeSpeed()
		local FT = FrameTime()

		if State == STATE_SPINNING or State == STATE_IDLING then
			self.BladeTurn = self.BladeTurn + BladeSpeed * 100 * FT
		end

		if self.BladeTurn > 360 then
			self.BladeTurn = self.BladeTurn - 360
		end
		if self.BladeTurn < 0 then
			self.BladeTurn = self.BladeTurn + 360
		end

		self:NextThink(Time + .01)
		return true
	end

	function ENT:Draw()
		local SelfPos, SelfAng, State = self:GetPos(), self:GetAngles(), self:GetState()
		local Up, Right, Forward = SelfAng:Up(), SelfAng:Right(), SelfAng:Forward()
		---
		local BasePos = SelfPos
		local Obscured = util.TraceLine({start = EyePos(), endpos = BasePos, filter = {LocalPlayer(), self}, mask = MASK_OPAQUE}).Hit
		local Closeness = LocalPlayer():GetFOV() * (EyePos():Distance(SelfPos))
		local DetailDraw = Closeness < 120000 -- cutoff point is 400 units when the fov is 90 degrees
		---
		if((not(DetailDraw)) and (Obscured))then return end -- if player is far and sentry is obscured, draw nothing
		if(Obscured)then DetailDraw = false end -- if obscured, at least disable details
		if(State == STATE_BROKEN)then DetailDraw = false end -- look incomplete to indicate damage, save on gpu comp too
		---
		self:DrawModel()
		---
		if DetailDraw then
			local WheelAng = SelfAng:GetCopy()
			WheelAng:RotateAroundAxis(WheelAng:Right(), self.BladeTurn)
			WheelAng:RotateAroundAxis(WheelAng:Forward(), 90)
			JMod.RenderModel(self.Blade, BasePos + Right * -22 + Up * -4.3 + Forward * 0.2, WheelAng, Vector(1, 1, 1))
			if Closeness < 20000 and State > JMod.EZ_STATE_OFF then
				local DisplayAng = SelfAng:GetCopy()
				DisplayAng:RotateAroundAxis(DisplayAng:Right(), -90)
				DisplayAng:RotateAroundAxis(DisplayAng:Up(), 90)
				local Opacity = math.random(50, 150)
				local Elec = self:GetElectricity()
				local R, G, B = JMod.GoodBadColor(Elec / self.MaxElectricity)

				cam.Start3D2D(SelfPos + Forward * 8 + Up * 1, DisplayAng, .08)
				draw.SimpleTextOutlined("POWER", "JMod-Display", 0, 0, Color(200, 255, 255, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
				draw.SimpleTextOutlined(tostring(math.Round(Elec)) .. "/" .. tostring(math.Round(self.MaxElectricity)), "JMod-Display", 0, 30, Color(R, G, B, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
				cam.End3D2D()
			end
		end
		language.Add("ent_jack_gmod_ezwinch", "EZ Winch")
	end
end