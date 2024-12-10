-- AdventureBoots 2023
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Jackarunda"
ENT.Information = "glhfggwpezpznore"
ENT.PrintName = "EZ Ground-Pounder"
ENT.Category = "JMod - EZ HL:2"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Base = "ent_jack_gmod_ezmachine_base"
---
ENT.Model = "models/hunter/blocks/cube05x1x05.mdl"
ENT.Mass = 200
ENT.SpawnHeight = 10
ENT.JModPreferredCarryAngles = Angle(0, 180, -90)
ENT.EZupgradable = false
ENT.StaticPerfSpecs = {
	MaxDurability = 100,
	MaxElectricity = 200
}
ENT.DynamicPerfSpecs = {
	Armor = 1
}
--
--ENT.WhitelistedResources = {}
ENT.BlacklistedResources = {JMod.EZ_RESOURCE_TYPES.WATER, JMod.EZ_RESOURCE_TYPES.OIL, "geothermal"}

local STATE_BROKEN, STATE_OFF, STATE_RUNNING = -1, 0, 1
---
function ENT:CustomSetupDataTables()
	self:NetworkVar("Float", 1, "Progress")
	self:NetworkVar("Float", 2, "SlamDist")
	self:NetworkVar("String", 0, "ResourceType")
end

if(SERVER)then
	function ENT:CustomInit()
		self:SetProgress(0)
		self.DepositKey = 0
		self.NextResourceThinkTime = 0
		self.NextEffectThinkTime = 0
		self.NextOSHAthinkTime = 0
		self.NextHoleThinkTime = 0
        timer.Simple(5, function()
            if IsValid(self) then
            JMod.Hint(self.EZowner, "ore scan")
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
		self:ProduceResource()

		if self.SoundLoop then
			self.SoundLoop:Stop()
		end
	end

	function ENT:Use(activator)
		local State = self:GetState()
		local OldOwner = JMod.GetEZowner(self)
		local Alt = JMod.IsAltUsing(activator)
		JMod.SetEZowner(self, activator, true)

		if State == STATE_BROKEN then
			JMod.Hint(activator, "destroyed", self)

			return
		elseif State == STATE_OFF then
			self:TurnOn(activator)
		elseif State == STATE_RUNNING then
			if Alt then
				self:ProduceResource()
			else
				self:TurnOff(activator)
			end
		end
	end
	
	function ENT:OnRemove()
		if(self.SoundLoop)then self.SoundLoop:Stop() end
	end
	
	function ENT:Think()
		local State, Time, Prog = self:GetState(), CurTime(), self:GetProgress()
		local SelfPos, Up, Right, Forward = self:GetPos(), self:GetUp(), self:GetRight(), self:GetForward()
		local Phys = self:GetPhysicsObject()

		self:UpdateWireOutputs()

		if (self.NextResourceThinkTime < Time) then
			self.NextResourceThinkTime = Time + .2
			if State == STATE_BROKEN then
				if self.SoundLoop then self.SoundLoop:Stop() end

				if self:GetElectricity() > 0 then
					if math.random(1, 4) == 2 then JMod.DamageSpark(self) end
				end

				return
			elseif State == STATE_RUNNING then

				local PoundDir = Right * -50
				local PoundStrgth = 400

				local PoundTr = util.TraceHull({
					start = SelfPos + PoundDir * .2,
					endpos = SelfPos + PoundDir,
					maxs = Vector(4, 4, 4),
					mins = Vector(-4, -4, -4),
					filter = self,
					mask = MASK_SOLID,
					ignoreworld = false
				})
				debugoverlay.Line(SelfPos + PoundDir * .2, PoundTr.HitPos, 1, Color(255, 0, 0), true)
				
				if (PoundTr.Hit) then
					local Ent = PoundTr.Entity
					if IsValid(Ent) then
						local Dmg = DamageInfo()
						Dmg:SetDamagePosition(PoundTr.HitPos)
						Dmg:SetDamageForce(PoundDir * PoundStrgth)
						Dmg:SetDamage(30)
						Dmg:SetDamageType(DMG_CRUSH)
						Dmg:SetInflictor(Ent)
						Dmg:SetAttacker(JMod.GetEZowner(self))
						Ent:TakeDamageInfo(Dmg)
						if Ent:IsPlayer() then
							Ent:SetVelocity(PoundDir * PoundStrgth / 10)
						else
							Ent:GetPhysicsObject():ApplyForceOffset(PoundDir * PoundStrgth, PoundTr.HitPos)
						end
					end
					self:GetPhysicsObject():ApplyForceOffset(PoundDir * -PoundStrgth, PoundTr.HitPos)

					self:EmitSound("Boulder.ImpactHard")

					if (math.random(1, 10) == 1) then
						util.Decal("EZgroundHole", SelfPos, SelfPos + PoundDir * 2)
					end

					JMod.EmitAIsound(self:GetPos(), 300, .5, 256)

					if math.random(1, 100) == 1 then
						self.DepositKey = JMod.GetDepositAtPos(self, SelfPos)
						if JMod.NaturalResourceTable[self.DepositKey] then
							local amtToDrill = math.min(JMod.NaturalResourceTable[self.DepositKey].amt, math.random(5, 10))
							self:SetProgress(amtToDrill)
							self:SetResourceType(JMod.NaturalResourceTable[self.DepositKey].typ)
							self:ProduceResource()
							JMod.DepleteNaturalResource(self.DepositKey, amtToDrill)
						end
					end
				end
				self:SetSlamDist(50 * PoundTr.Fraction)
				self:ConsumeElectricity(0.2  * JMod.Config.ResourceEconomy.ExtractionSpeed)
			end
		end

		self:NextThink(CurTime() + .1)
		return true
	end
	
	function ENT:ProduceResource()
		local SelfPos, Forward, Up, Right, Typ = self:GetPos(), self:GetForward(), self:GetUp(), self:GetRight(), self:GetResourceType()
		local amt = math.Clamp(math.floor(self:GetProgress()), 0, 100)

		if amt <= 0 then return end

		local pos = SelfPos
		local spawnVec = self:WorldToLocal(SelfPos + Forward * 45)
		self:SetProgress(self:GetProgress() - amt)
		JMod.MachineSpawnResource(self, Typ, amt, spawnVec, Angle(0, 0, -90), Forward * 15, 200)
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
		self.DrillPipe = JMod.MakeModel(self, "models/props_pipes/pipe03_straight01_long.mdl")
		self.DrillPipeEnd = JMod.MakeModel(self, "models/props_c17/playgroundTick-tack-toe_block01a.mdl")
		self.PowerBox = JMod.MakeModel(self, "models/props_lab/powerbox02b.mdl")
		self.DrillMat = Material("mechanics/metal2")
		self.CurDepth = 0
	end

	local MiningLazCol = Color(255, 0, 0)

	function ENT:Draw()
		local Up, Right, Forward, Typ, State = self:GetUp(), self:GetRight(), self:GetForward(), self:GetResourceType(), self:GetState()
		local SelfPos, SelfAng = self:GetPos(), self:GetAngles()
		local BoxPos = SelfPos + Right * 5 + Forward * 1
		local PipePos = BoxPos + Right * (-self.CurDepth) + Forward * 4
		local PounderPos = PipePos + Right * -22 - Forward * 4
		--
		if State == STATE_RUNNING then
			local SlamDist = (math.sin(CurTime() * 30) / 2 + .5) * (self:GetSlamDist() / 2)
			self.CurDepth = Lerp(math.ease.InOutExpo(6), self.CurDepth, SlamDist)
		end
		--
		local PowerBoxAng = SelfAng:GetCopy()
		PowerBoxAng:RotateAroundAxis(Forward, 90)
		JMod.RenderModel(self.PowerBox, BoxPos, PowerBoxAng, Vector(2, 2.5, 1.5), nil, self.DrillMat)
		--

		local Obscured = util.TraceLine({start = EyePos(), endpos = SelfPos, filter = {LocalPlayer(), self}, mask = MASK_OPAQUE}).Hit
		local Closeness = LocalPlayer():GetFOV() * (EyePos():Distance(SelfPos))
		local DetailDraw = Closeness < 36000 -- cutoff point is 400 units when the fov is 90 degrees
		local DrillDraw = true
		if State == STATE_BROKEN then 
			DetailDraw = false 
			DrillDraw = false 
		end -- look incomplete to indicate damage, save on gpu comp too

		if DrillDraw then
			local PipeAng = SelfAng:GetCopy()
			PipeAng:RotateAroundAxis(Right, 90)
			--PipeAng:RotateAroundAxis(Up, 180)
			JMod.RenderModel(self.DrillPipe, PipePos, PipeAng, Vector(.5, .4, .5), nil, self.DrillMat)
			local PounderAng = SelfAng:GetCopy()
			PounderAng:RotateAroundAxis(Right, 90)
			PounderAng:RotateAroundAxis(Up, 90)
			JMod.RenderModel(self.DrillPipeEnd, PounderPos, PounderAng, Vector(.8, .8, .8), nil, self.DrillMat)
		end

		if (not(DetailDraw)) and (Obscured) then return end -- if player is far and sentry is obscured, draw nothing
		if Obscured then DetailDraw = false end -- if obscured, at least disable details
		
		if DetailDraw then
			if (Closeness < 40000) and (State == STATE_RUNNING) then
				local DisplayAng = SelfAng:GetCopy()
				DisplayAng:RotateAroundAxis(DisplayAng:Forward(), 180)
				DisplayAng:RotateAroundAxis(DisplayAng:Right(), -90)
				local Opacity = math.random(50, 150)
				cam.Start3D2D(SelfPos + Forward * 12.5 + Up * -37 + Right * 8, DisplayAng, .15)
					draw.SimpleTextOutlined("POWER","JMod-Display",250,-60,Color(255,255,255,Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
					local ElecFrac=self:GetElectricity()/200
					local R,G,B = JMod.GoodBadColor(ElecFrac)
					draw.SimpleTextOutlined(tostring(math.Round(ElecFrac*100)).."%","JMod-Display",250,-30,Color(R,G,B,Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
				cam.End3D2D()
			end
		end
	end
	language.Add("ent_aboot_gmod_ezpounder","EZ Ground-Pounder")
end