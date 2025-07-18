-- AdventureBoots 2023
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Jackarunda"
ENT.Information = "glhfggwpezpznore"
ENT.PrintName = "EZ Grinder"
ENT.Category = "JMod - EZ HL:2"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Base = "ent_jack_gmod_ezmachine_base"
---
ENT.Model = "models/aboot/ezgrinder01.mdl"
ENT.Mass = 200
ENT.SpawnHeight = 10
ENT.EZcolorable = false
ENT.JModPreferredCarryAngles = Angle(0, 180, -90)
ENT.EZupgradable = false
ENT.StaticPerfSpecs = {
	MaxDurability = 100,
	MaxElectricity = 200
}
ENT.DynamicPerfSpecs = {
	Armor = 1
}

local STATE_BROKEN, STATE_OFF, STATE_RUNNING = -1, 0, 1
---
function ENT:CustomSetupDataTables()
	self:NetworkVar("Float", 1, "Progress")
	--self:NetworkVar("String", 0, "Message")
end

if(SERVER)then
	function ENT:CustomInit()
		self:SetProgress(0)
		self.NextResourceThinkTime = 0
		self.NextEffectThinkTime = 0
		self.NextOSHAthinkTime = 0
        timer.Simple(5, function()
            if IsValid(self) then
            JMod.Hint(self.EZowner, "work spread")
            end
        end)
	end

	function ENT:TurnOn(activator)
		if self:GetState() ~= STATE_OFF then return end

		if (self:GetElectricity() > 0) then
			if IsValid(activator) then self.EZstayOn = true end
			self:SetState(STATE_RUNNING)
			self.SoundLoop = CreateSound(self, "^snds_jack_gmod/genny_start_loop.wav")
			self.SoundLoop:SetSoundLevel(80)
			self.SoundLoop:Play()
			self:SetProgress(0)
		else
			JMod.Hint(activator, "nopower")
		end
	end
	
	function ENT:TurnOff(activator)
		if (self:GetState() <= 0) then return end
		if IsValid(activator) then self.EZstayOn = nil end
		self:SetState(STATE_OFF)

		if self.SoundLoop then
			self.SoundLoop:Stop()
		end
	end

	function ENT:Use(activator)
		local State = self:GetState()
		local OldOwner = JMod.GetEZowner(self)
		local alt = JMod.IsAltUsing(activator)
		JMod.SetEZowner(self, activator, true)

		if State == STATE_BROKEN then
			JMod.Hint(activator, "destroyed", self)

			return
		elseif State == STATE_OFF then
			self:TurnOn(activator)
		elseif State == STATE_RUNNING then
			self:TurnOff(activator)
		end
	end

	function ENT:OnBreak()
		if self.SoundLoop then
			self.SoundLoop:Stop()
		end
		self:SetBodygroup(1, 1)
		self:SetBodygroup(2, 1)
	end

	function ENT:OnRepair()
		self:SetBodygroup(1, 0)
		self:SetBodygroup(2, 0)
	end
	
	function ENT:OnRemove()
		if(self.SoundLoop)then self.SoundLoop:Stop() end
	end
	
	function ENT:Think()
		local State, Time, Prog = self:GetState(), CurTime(), self:GetProgress()
		local SelfPos, SelfUp, SelfRight, Forward = self:GetPos(), self:GetUp(), self:GetRight(), self:GetForward()
		local Phys = self:GetPhysicsObject()

		self:UpdateWireOutputs()

		if (self.NextResourceThinkTime < Time) then
			self.NextResourceThinkTime = Time + .1
			if State == STATE_BROKEN then
				if self.SoundLoop then self.SoundLoop:Stop() end

				if self:GetElectricity() > 0 then
					if math.random(1, 4) == 2 then JMod.DamageSpark(self) end
				end

				return
			elseif State == STATE_RUNNING then

				local Resolution = 8
				local Radius = 16
				local RotationAngles = self:GetAngles():GetCopy()
				local SpinOrigin = SelfPos + SelfUp * -16
				local CutStrength = 5000

				for i = 1, Resolution do
					RotationAngles:RotateAroundAxis(RotationAngles:Forward(), 360 / Resolution)
					local CutDir = RotationAngles:Right() * -1
					local LineStart = SpinOrigin + RotationAngles:Up() * Radius + CutDir * Radius * -.5
					local LineOffset = CutDir * Radius
					local CutTr = util.QuickTrace(LineStart, LineOffset, {self})

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
								Ent:GetPhysicsObject():ApplyForceOffset(CutDir * -CutStrength, HitPos)
							end
						end
						self:GetPhysicsObject():ApplyForceOffset(CutDir * CutStrength, HitPos)

						if CutTr.SurfaceProps > 0 then
							self:EmitSound(util.GetSurfaceData(CutTr.SurfaceProps).impactSoftSound)
						end
						self:HitEffect(HitPos, 1)

						local Message = JMod.EZprogressTask(Ent, HitPos, self, "salvage", 0.01)
						if Message then
							Message = JMod.EZprogressTask(Ent, HitPos, self, "loosen", 0.01)
						else
							sound.Play("snds_jack_gmod/ez_dismantling/1.ogg", HitPos, 65, 110)--math.random(90, 110))
						end
						if Message then
							debugoverlay.Text(HitPos, Message, .2, true)
						end

						self:ConsumeElectricity(0.05 * JMod.Config.Tools.Toolbox.DeconstructSpeedMult)

						break
					end
				end
				self:ConsumeElectricity(0.05 * JMod.Config.Tools.Toolbox.DeconstructSpeedMult)
			end
		end

		self:NextThink(CurTime() + .1)
		return true
	end

	function ENT:HitEffect(pos, scale)
		scale = scale or 1
		local effectdata = EffectData()
		effectdata:SetOrigin(pos + VectorRand())
		effectdata:SetNormal((VectorRand() + Vector(0, 0, 1)):GetNormalized())
		effectdata:SetMagnitude(math.Rand(1, 2) * scale) --amount and shoot hardness
		effectdata:SetScale(math.Rand(.5, 1.5) * scale) --length of strands
		effectdata:SetRadius(math.Rand(2, 4) * scale) --thickness of strands
		util.Effect("Sparks", effectdata, true, true)
	end

	function ENT:PostEntityPaste(ply, ent, createdEntities)
		local Time = CurTime()
		JMod.SetEZowner(self, ply, true)
		ent.NextRefillTime = Time + math.Rand(0, 3)
		ent.NextResourceThinkTime = 0
		ent.NextEffectThinkTime = 0
		ent.NextOSHAthinkTime = 0
	end

elseif(CLIENT)then
	function ENT:CustomInit()
		--self.SawBlade = JMod.MakeModel(self, "models/props_junk/sawblade001a.mdl")
		self.CurSpin = 0
		self.CurSpeed = 0
		self.MaxElectricity = 200
	end

	function ENT:Think()
		local State, FT = self:GetState(), FrameTime()
		self.CurSpin = self.CurSpin or 0
		if State == STATE_RUNNING then
			self.CurSpin = self.CurSpin - FT * self.CurSpeed
			self.CurSpeed = math.min(self.CurSpeed + FT * 200, 1000)
		elseif self.CurSpin > 0 then
			self.CurSpin = self.CurSpin - FT * self.CurSpeed
			self.CurSpeed = math.max(self.CurSpeed - FT * 100, 0)
		end
		if self.CurSpin > 360 then
			self.CurSpin = 0
		elseif self.CurSpin < 0 then
			self.CurSpin = 360
		end
	end

	function ENT:Draw()
		local Up, Right, Forward, State = self:GetUp(), self:GetRight(), self:GetForward(), self:GetState()
		local SelfPos, SelfAng = self:GetPos(), self:GetAngles()
		local SawPos = SelfPos + Up * -16
		--
		self:DrawModel()
		--

		local Obscured = util.TraceLine({start = EyePos(), endpos = SelfPos, filter = {LocalPlayer(), self}, mask = MASK_OPAQUE}).Hit
		local Closeness = LocalPlayer():GetFOV() * (EyePos():Distance(SelfPos))
		local DetailDraw = Closeness < 36000 -- cutoff point is 400 units when the fov is 90 degrees
		local DrillDraw = true
		if State == STATE_BROKEN then 
			DetailDraw = false 
			DrillDraw = false 
		end -- look incomplete to indicate damage, save on gpu comp too

		--[[if DrillDraw then
			local SawAng = SelfAng:GetCopy()
			SawAng:RotateAroundAxis(Right, 90)
			SawAng:RotateAroundAxis(Forward, self.CurSpin)
			JMod.RenderModel(self.SawBlade, SawPos, SawAng, Vector(.8, .8, .8), nil)
		end--]]
		self:ManipulateBoneAngles(self:LookupBone("start"), Angle(-self.CurSpin, 0, 0))
		self:ManipulateBoneAngles(self:LookupBone("end"), Angle(-self.CurSpin, 0, 0))

		if (not(DetailDraw)) and (Obscured) then return end -- if player is far and sentry is obscured, draw nothing
		if Obscured then DetailDraw = false end -- if obscured, at least disable details
		
		if DetailDraw then
			if (State == STATE_RUNNING) then
				local DisplayAng = SelfAng:GetCopy()
				DisplayAng:RotateAroundAxis(DisplayAng:Forward(), 90)
				DisplayAng:RotateAroundAxis(DisplayAng:Up(), 180)
				local Opacity = math.random(50, 150)
				cam.Start3D2D(SelfPos + Up * 25 + Right * 15, DisplayAng, .15)
					draw.SimpleTextOutlined("POWER", "JMod-Display",0,0,Color(255,255,255,Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
					local ElecFrac=self:GetElectricity()/self.MaxElectricity
					local R,G,B = JMod.GoodBadColor(ElecFrac)
					draw.SimpleTextOutlined(tostring(math.Round(ElecFrac*100)).."%","JMod-Display",0,-30,Color(R,G,B,Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
				cam.End3D2D()
			end
		else
			debugoverlay.Cross(SelfPos, 10, .2, Color(255, 0, 0), true)
		end
	end
	language.Add("ent_aboot_gmod_ezpounder","EZ Ground-Pounder")
end