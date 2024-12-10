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
ENT.Model = "models/aboot/ez_airboat_engine.mdl"
ENT.Mass = 45
ENT.IdleSounds = {
	fan = "vehicles/airboat/fan_blade_idle_loop1.wav", 
	motor = "vehicles/airboat/fan_motor_idle_loop1.wav"}
ENT.FullThrottleSounds = {
	fan = "vehicles/airboat/fan_blade_fullthrottle_loop1.wav", 
	motor ="vehicles/airboat/fan_motor_fullthrottle_loop1.wav"}
--
ENT.StaticPerfSpecs={ 
	MaxFuel = 100,
	MaxDurability = 100,
	Armor = 2
}
ENT.EZconsumes = {
	JMod.EZ_RESOURCE_TYPES.BASICPARTS,
	JMod.EZ_RESOURCE_TYPES.FUEL
}

function ENT:CustomSetupDataTables()
	self:NetworkVar("Float", 0, "Fuel")
	self:NetworkVar("Float", 1, "BladeSpeed")
end

local STATE_BROKEN, STATE_OFF, STATE_SPINNING = -1, 0, 1
--
if SERVER then
	function ENT:SetupWire()
		if not(istable(WireLib)) then return end
		local WireInputs = {"TurnOnOff [NORMAL]", "Spin [NORMAL]"}
		local WireInputDesc = {"1 turns on, 0 turns off", "Sets the desired speed and direction of spinning\nmin -100, max 100"}
		self.Inputs = WireLib.CreateInputs(self, WireInputs, WireInputDesc)
		--
		local WireOutputs = {"State [NORMAL]", "CurSpin [NORMAL]", "DesiredSpin [NORMAL]"}
		local WireOutputDesc = {"The state of the machine \n-1 is broken \n0 is off \n1 is on \n2 is speeling", "The current speed and direction of spin", "The desired speed and direction of spin"}
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
		self.FanSoundLoop = CreateSound(self, self.IdleSounds["fan"])
		self.EngineSoundLoop = CreateSound(self, self.IdleSounds["motor"])
	end

	function ENT:TurnOn()
		local State = self:GetState()
		if State < STATE_OFF then return end
		self:EmitSound("vehicles/airboat/fan_motor_start1.wav", 60, 100)
		timer.Simple(1, function()
			if not IsValid(self) or (State < STATE_OFF) then return end
			self:SetState(STATE_SPINNING)
			self:SetThrottle(self.MaxBladeSpeed * 0.1)
		end)
	end

	function ENT:TurnOff()
		if self:GetState() < STATE_SPINNING then return end
		self:SetState(STATE_OFF)
		self:SetThrottle(0)
		self:EmitSound("vehicles/airboat/fan_motor_shut_off1.wav", 60, 100)
		self:EndSounds()
	end

	function ENT:SetThrottle(val)
		if self:GetState() < STATE_SPINNING then return end
		self.DesiredBladeSpeed = math.Clamp(val, -self.MaxBladeSpeed, self.MaxBladeSpeed)
		if WireLib then
			WireLib.TriggerOutput(self, "DesiredSpin", self.DesiredBladeSpeed)
		end
		if self.EngineSoundLoop then
			self.EngineSoundLoop:Stop()
		end
		if val > 50 then
			self.EngineSoundLoop = CreateSound(self, self.FullThrottleSounds["motor"])
		else
			self.EngineSoundLoop = CreateSound(self, self.IdleSounds["motor"])
		end
		self.EngineSoundLoop:Play()
	end

	function ENT:EndSounds()
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
		local Alt = IsPly and JMod.IsAltUsing(activator)
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
			self:EndSounds()
			return
		end
		local CurSpeed = self:GetBladeSpeed()

		if State == STATE_SPINNING then
			--jprint("cur: " .. tostring(CurSpeed) .. " desired: " .. tostring(self.DesiredBladeSpeed))
			if CurSpeed ~= self.DesiredBladeSpeed then
				CurSpeed = (math.Approach(math.Clamp(CurSpeed, -self.MaxBladeSpeed, self.MaxBladeSpeed), self.DesiredBladeSpeed, 15 / ThinkRate))
				if self.EngineSoundLoop then self.EngineSoundLoop:ChangePitch(50 + 50 * math.abs(CurSpeed) / self.MaxBladeSpeed, .1) end
				if self.FanSoundLoop then self.FanSoundLoop:ChangePitch(50 + 50 * math.abs(CurSpeed) / self.MaxBladeSpeed, .1) end
				if WireLib then
					WireLib.TriggerOutput(self, "CurSpin", CurSpeed)
				end
			end
			self:SetBladeSpeed(CurSpeed)

			if self:GetFuel() <= 0 then
				self:TurnOff()

				return
			end

			local Phys = self:GetPhysicsObject()

			if IsValid(Phys) then
				local SelfPos = self:GetPos()
				local SelfUp, SelfRight, SelfForward = self:GetUp(), self:GetRight(), self:GetForward()
				Phys:ApplyForceCenter(SelfRight * CurSpeed * 2000 / ThinkRate)

				if (self.NextWhackTime or 0) < CurTime() then
					self.NextWhackTime = CurTime() + math.min(1, math.abs(1 / (CurSpeed * .5 / 3.14)))
					--jprint(math.abs(1 / (CurSpeed * .5 / 3.14)))
					local Resolution = 16
					local Radius = 30
					local RotationAngles = self:GetAngles():GetCopy()
					local SpinOrigin = SelfPos + SelfRight * -23 + SelfUp * -4.3
					local CutStrength = 1000

					RotationAngles:RotateAroundAxis(SelfUp, 90)
					for i = 1, Resolution do
						local CutDir = RotationAngles:Right()
						local Reverse = CurSpeed < 0
						if Reverse then
							CutDir = -CutDir
							RotationAngles:RotateAroundAxis(RotationAngles:Forward(), -360 / Resolution)
						else
							RotationAngles:RotateAroundAxis(RotationAngles:Forward(), 360 / Resolution)
						end
						
						local LineStart = SpinOrigin + RotationAngles:Up() * Radius + CutDir * -Radius / math.pi
						debugoverlay.Cross(SpinOrigin, 5, .2, Color(255, i * 100 / Resolution, 0), true)
						debugoverlay.Line(LineStart, LineStart + CutDir * Radius / math.pi, .2, Color(255, i * 100 / Resolution, 0), true)
						local CutTr = util.QuickTrace(LineStart, CutDir * Radius / math.pi, {self, self:GetParent()})

						if (CutTr.Hit) then
							local Ent = CutTr.Entity
							local HitPos = CutTr.HitPos

							if IsValid(Ent) then
								local Dmg = DamageInfo()
								Dmg:SetDamagePosition(HitPos)
								Dmg:SetDamageForce(CutDir * CutStrength)
								Dmg:SetDamage(3)
								Dmg:SetDamageType(DMG_SLASH)
								Dmg:SetInflictor(Ent)
								Dmg:SetAttacker(JMod.GetEZowner(self))
								Ent:TakeDamageInfo(Dmg)
								if Ent:IsPlayer() then
									Ent:SetVelocity(CutDir * CutStrength / 10)
								elseif IsValid(Ent:GetPhysicsObject()) then
									Ent:GetPhysicsObject():ApplyForceOffset(CutDir * CutStrength, HitPos)
								end
							end
							Phys:ApplyForceOffset(CutDir * -CutStrength, HitPos)

							if CutTr.SurfaceProps > 0 then
								self:EmitSound(util.GetSurfaceData(CutTr.SurfaceProps).impactSoftSound)
							end
							--self:HitEffect(HitPos, 1)
							break
						end
					end
				end
			end

			if (math.abs(CurSpeed) < 80) then
				if self.FanSoundLoop then self.FanSoundLoop:Stop() end
				self.FanSoundLoop = CreateSound(self, self.IdleSounds["fan"])
			elseif (math.abs(CurSpeed) > 80) then
				if self.FanSoundLoop then self.FanSoundLoop:Stop() end
				self.FanSoundLoop = CreateSound(self, self.FullThrottleSounds["fan"])
			end

			self:ConsumeFuel(0.001 * math.abs(CurSpeed) / ThinkRate)
			self:UpdateWireOutputs()
		elseif State == STATE_OFF then
			self:SetBladeSpeed(math.Approach(CurSpeed, 0, 100 / ThinkRate))
		end

		self:NextThink(Time + (1 / ThinkRate))
		return true
	end

	function ENT:ConsumeFuel(amount)
		self:SetFuel(math.max(0, self:GetFuel() - amount))
		if self:GetFuel() <= 0 then
			self:TurnOff()
		end
	end

	function ENT:OnPostEntityPaste(ply, Ent, CreatedEntities)
		self:TurnOff()
	end

	function ENT:OnBreak()
		self:EndSounds()
	end

	function ENT:OnRemove()
		self:EndSounds()
	end

elseif CLIENT then
	function ENT:CustomInit()
		self:DrawShadow(true)
		self.Blade = JMod.MakeModel(self, "models/aboot/airboat_propeller.mdl")
		self.BladeTurn = 0
	end

	function ENT:Think()
		if self.ClientOnly then return end
		local Time, State, BladeSpeed = CurTime(), self:GetState(), self:GetBladeSpeed()
		local FT = FrameTime()

		if State == STATE_SPINNING then
			self.BladeTurn = self.BladeTurn + BladeSpeed * 66 * FT
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
			WheelAng:RotateAroundAxis(WheelAng:Right(), -self.BladeTurn)
			WheelAng:RotateAroundAxis(WheelAng:Forward(), 90)
			JMod.RenderModel(self.Blade, BasePos + Right * -23 + Up * -4.3 + Forward * 0.2, WheelAng)
			if Closeness < 20000 and State > JMod.EZ_STATE_OFF then
				local DisplayAng = SelfAng:GetCopy()
				DisplayAng:RotateAroundAxis(DisplayAng:Forward(), 30)
				local Opacity = math.random(50, 150)
				local Elec = self:GetFuel()
				local R, G, B = JMod.GoodBadColor(Elec / self.MaxFuel)

				cam.Start3D2D(SelfPos + Up * 1 + Right * 28, DisplayAng, .08)
					draw.SimpleTextOutlined("FUEL", "JMod-Display", 0, 0, Color(200, 255, 255, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
					draw.SimpleTextOutlined(tostring(math.Round(Elec)) .. "/" .. tostring(math.Round(self.MaxFuel)), "JMod-Display", 0, 30, Color(R, G, B, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
					draw.SimpleTextOutlined("RPM", "JMod-Display", 0, 60, Color(200, 255, 255, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
					draw.SimpleTextOutlined(tostring(math.Round(self:GetBladeSpeed())), "JMod-Display", 0, 90, Color(255, 255, 255, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
				cam.End3D2D()
			end
		end
		language.Add("ent_jack_gmod_ezwinch", "EZ Winch")
	end
end