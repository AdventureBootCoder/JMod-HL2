-- AdventureBoots 2023
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Jackarunda"
ENT.Information = "glhfggwpezpznore"
ENT.PrintName = "EZ Capactior"
ENT.Category = "JMod - EZ HL:2"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Base = "ent_jack_gmod_ezmachine_base"
---
ENT.Model = "models/props_lab/powerbox02b.mdl"
ENT.Mass = 50
ENT.SpawnHeight = 10
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)
ENT.EZupgradable = false
ENT.StaticPerfSpecs = {
	MaxDurability = 100,
	MaxElectricity = 100
}
ENT.DynamicPerfSpecs = {
	Armor = 1
}
--
ENT.ShockDistance = 1000

local STATE_BROKEN, STATE_OFF, STATE_ON = -1, 0, 1
---

if(SERVER)then
	function ENT:CustomInit()
		self.ElecticalCallbacks = {}
	end

	function ENT:TurnOn(activator)
		if self:GetState() ~= STATE_OFF then return end

		if (self:GetElectricity() > 0) then
			if IsValid(activator) then self.EZstayOn = true end
			self:SetState(STATE_ON)
			self:CheckForConnection()
			jprint("turning on")
		else
			JMod.Hint(activator, "nopower")
		end
	end
	
	function ENT:TurnOff(activator)
		if (self:GetState() <= 0) then return end
		if IsValid(activator) then self.EZstayOn = nil end
		self:SetState(STATE_OFF)
	end

	function ENT:Use(activator)
		local State = self:GetState()
		local OldOwner = self.EZowner
		local alt = activator:KeyDown(JMod.Config.General.AltFunctionKey)
		JMod.SetEZowner(self, activator, true)

		if State == STATE_BROKEN then
			JMod.Hint(activator, "destroyed", self)

			return
		elseif State == STATE_OFF then
			self:TurnOn(activator)
		elseif State >= STATE_ON then
			self:TurnOff(activator)
		end
	end
	
	function ENT:Think()
		local State, Time = self:GetState(), CurTime()
		--local SelfPos, Up, Right, Forward = self:GetPos(), self:GetUp(), self:GetRight(), self:GetForward()

		self:UpdateWireOutputs()

		self:ConsumeElectricity(math.Rand(0.02, 0.05))

		self:NextThink(Time + 1)
		return true
	end

	local Shockables = {MAT_METAL, MAT_DEFAULT, MAT_GRATE, MAT_FLESH, MAT_ALIENFLESH}

	function ENT:CheckForConnection(shocker)
		for _, Ent in pairs(constraint.GetAllConstrainedEntities(self)) do
			if IsValid(shocker) then
				if Ent == shocker then

					return true
				end
			else
				local EntID = Ent:EntIndex()
				if (Ent:GetClass() == "prop_physics") and (table.HasValue(Shockables, Ent:GetMaterialType())) and not(self.ElecticalCallbacks[EntID]) then
					local ShockCallback = Ent:AddCallback("PhysicsCollide", function(ent, data)
						if not(IsValid(ent)) or not(IsValid(data.HitEntity)) then return end
						if data.DeltaTime > 0.3 then
							timer.Simple(0, function()
								if not(IsValid(Ent)) or not(IsValid(data.HitEntity)) then return end
								if IsValid(self) then
									self:Shock(Ent, data) 
								else
									Ent:RemoveCallback("PhysicsCollide", ShockCallback)
								end
							end)
						end
					end)
					self.ElecticalCallbacks[EntID] = ShockCallback
				end
			end
		end

		return false
	end

	function ENT:Shock(shocker, shockedData)
		if self:GetState() == STATE_ON then
			local ShockEnt = shockedData.HitEntity
			if self:GetPos():Distance(ShockEnt:GetPos()) <= self.ShockDistance then
				local Connected = self:CheckForConnection(shocker)
				if Connected then
					if ShockEnt:IsPlayer() or ShockEnt:IsNPC() or table.HasValue(Shockables, ShockEnt:GetMaterialType()) then
						local Damage, Force = 1, 500 -- Adjust damage and force factors as desired
						local Zap = DamageInfo()
						Zap:SetDamage(Damage)
						Zap:SetDamageForce(shockedData.HitNormal * -Force)
						Zap:SetDamagePosition(shockedData.HitPos)
						Zap:SetAttacker(JMod.GetEZowner(self))
						Zap:SetInflictor(shocker)
						Zap:SetDamageType(DMG_SHOCK)
						ShockEnt:TakeDamageInfo(Zap)
						-- Electrical effect
						local ZapEff = EffectData()
						ZapEff:SetOrigin(shockedData.HitPos)
						ZapEff:SetNormal(shockedData.HitNormal)
						ZapEff:SetMagnitude(math.Rand(5, 10)) --amount and shoot hardness
						ZapEff:SetScale(math.Rand(.5, 1.5)) --length of strands
						ZapEff:SetRadius(math.Rand(2, 4)) --thickness of strands
						util.Effect("Sparks", ZapEff, true, true)
						-- Electrical sound
						shocker:EmitSound("snd_jack_turretfizzle.wav", 70, 100)
						-- Reduce power
						self:ConsumeElectricity(1)
						JMod.EZimmobilize(ShockEnt, 1.5, self)
					end
				end
			end
		end
	end

	function ENT:OnRemove()
		for k, v in pairs(self.ElecticalCallbacks) do
			Entity(k):RemoveCallback("PhysicsCollide", v)
		end
	end

	function ENT:PostEntityPaste(ply, ent, createdEntities)
		local Time = CurTime()
		JMod.SetEZowner(self, ply, true)
		ent.NextRefillTime = Time + math.Rand(0, 3)
		ent.NextResourceThinkTime = 0
	end

elseif(CLIENT)then
	function ENT:CustomInit()
		self.MaxElectricity = 100
	end

	function ENT:Think()
		local State, FT = self:GetState(), FrameTime()
		if State == STATE_ON then
		end
	end

	function ENT:Draw()
		local Up, Right, Forward, State = self:GetUp(), self:GetRight(), self:GetForward(), self:GetState()
		local SelfPos, SelfAng = self:GetPos(), self:GetAngles()
		--
		local Obscured = util.TraceLine({start = EyePos(), endpos = MotorPos, filter = {LocalPlayer(), self}, mask = MASK_OPAQUE}).Hit
		local Closeness = LocalPlayer():GetFOV() * (EyePos():Distance(SelfPos))
		local DetailDraw = Closeness < 36000 -- cutoff point is 400 units when the fov is 90 degrees
		if State == STATE_BROKEN then DetailDraw = false end -- look incomplete to indicate damage, save on gpu comp too
		if Obscured then DetailDraw = false end -- if obscured, at least disable details
		--
		self:DrawModel()
		--
		if DetailDraw then
			if (Closeness < 40000) and (State >= STATE_ON) then
				local Opacity = math.random(50, 150)
				local DisplayAng = SelfAng:GetCopy()

				cam.Start3D2D(SelfPos + Forward * 1 + Up * 1 + Right * 1, DisplayAng, .15)
					draw.SimpleTextOutlined("POWER", "JMod-Display",250,-60,Color(255,255,255,Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
					local ElecFrac=self:GetElectricity()/self.MaxElectricity
					local R,G,B = JMod.GoodBadColor(ElecFrac)
					draw.SimpleTextOutlined(tostring(math.Round(ElecFrac*100)).."%","JMod-Display",250,-30,Color(R,G,B,Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
				cam.End3D2D()
			end
		end
	end
	language.Add("ent_aboot_gmod_ezpounder","EZ Ground-Pounder")
end