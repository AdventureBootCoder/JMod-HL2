-- Jackarunda 2021
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "AdventureBoots"
ENT.PrintName = "EZ Big Thumper"
ENT.Category = "JMod - EZ HL:2"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Base = "ent_jack_gmod_ezmachine_base"
ENT.AutomaticFrameAdvance = true
ENT.EZconsumes = {
	JMod.EZ_RESOURCE_TYPES.BASICPARTS,
	JMod.EZ_RESOURCE_TYPES.POWER
}
--
ENT.Model = "models/props_combine/combinethumper001a.mdl"
ENT.Mass = 6000
ENT.SpawnHeight = 0
--
ENT.EZcolorable = false
ENT.EZupgradable = true
ENT.StaticPerfSpecs = {
	MaxDurability = 350,
	MaxElectricity = 800
}
ENT.DynamicPerfSpecs = {
	Armor = 2.5
}
ENT.BackupRecipe = {[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 100}
--
--ENT.WhitelistedResources = {}
ENT.BlacklistedResources = {"geothermal", "geo"}

local STATE_BROKEN, STATE_OFF, STATE_RUNNING = -1, 0, 1
---
function ENT:CustomSetupDataTables()
	self:NetworkVar("Float", 1, "Progress")
	self:NetworkVar("String", 0, "ResourceType")
end
---
if(SERVER)then
	function ENT:CustomInit()
		self:SetProgress(0)
		self.DepositKey = 0
		self.LastState = 0
		timer.Simple(0.01, function() 
			self:TryPlace()
		end)
		self:NextThink(1)
		self.EZupgradable = true
		--self:SetMaterial("models/aboot/aboot_combinethumper002_mat.vmt")
		timer.Simple(0, function() 
			self:TryPlace()
			self:SetColor(Color(255, 255, 255))
		end)
		self.NextUseTime = 0
		self.NextSoundTime = 0
	end

	function ENT:TryPlace()
		local Tr = util.QuickTrace(self:GetPos() + Vector(0, 0, 100), Vector(0, 0, -500), self)
		if (Tr.Hit) and (Tr.HitWorld) then
			local GroundIsSolid = true
			for i = 1, 50 do
				local Contents = util.PointContents(Tr.HitPos - Vector(0, 0, 10 * i))
				if(bit.band(util.PointContents(self:GetPos()), CONTENTS_SOLID) == CONTENTS_SOLID)then GroundIsSolid = false break end
			end

			self:UpdateDepositKey()

			if not(self.DepositKey)then
				JMod.Hint(self.EZowner, "thumper")
			end

			if(GroundIsSolid)then
				local SelfAng = self:GetAngles()
				local Roll = Tr.HitNormal:Angle().z
				local Yaw = Tr.HitNormal:Angle().y
				self:SetAngles(Angle(0, Yaw - 90, 0))
				self:SetPos(Tr.HitPos + Tr.HitNormal * self.SpawnHeight)
				---
				self:GetPhysicsObject():EnableMotion(false)
				self.EZinstalled = true
				---
				self:TurnOn(self.EZowner)
			else
				if self:GetState() > STATE_OFF then
					self:TurnOff()
				end
				JMod.Hint(self.EZowner, "machine mounting problem")
			end
		end
	end

	function ENT:TurnOn(activator)
		if self:GetState() > STATE_OFF then return end
		local SelfPos, Forward, Right = self:GetPos(), self:GetForward(), self:GetRight()

		if self.EZinstalled then
			if (self:GetElectricity() > 0) then
				self:EmitSound("ambient/machines/thumper_startup1.wav", 100)
				timer.Simple(2.8, function()
					if not(IsValid(self)) or not(self.EZinstalled) then return end
					self:SetState(STATE_RUNNING)
					self.SoundLoop = CreateSound(self, "ambient/machines/thumper_amb.wav")
					self.SoundLoop:SetSoundLevel(65)
					self.SoundLoop:Play()
					self:SetProgress(0)
				end)
			else
				JMod.Hint(activator, "nopower")
			end
		else
			self:TryPlace()
		end
	end

	function ENT:TurnOff()
		if (self:GetState() <= 0) then return end
		self:SetState(STATE_OFF)
		self:ProduceResource()

		if self.SoundLoop then
			self.SoundLoop:Stop()
		end

		self:EmitSound("ambient/machines/thumper_shutdown1.wav")
	end

	function ENT:Use(activator)
		local Time = CurTime()
		if self.NextUseTime > Time then return end
		self.NextUseTime = Time + 2
		local State = self:GetState()
		local OldOwner = self.EZowner
		local alt = activator:KeyDown(JMod.Config.General.AltFunctionKey)
		JMod.SetEZowner(self, activator)

		if State == STATE_BROKEN then
			JMod.Hint(activator, "destroyed", self)

			return
		elseif State == STATE_OFF then
			self:TurnOn(activator)
		elseif State == STATE_RUNNING then
			if alt then
				self:ProduceResource()

				return
			end
			self:TurnOff()
		end
	end
	
	function ENT:OnRemove()
		if(self.SoundLoop)then self.SoundLoop:Stop() end
	end
	
	function ENT:Think()
		local State, Time = self:GetState(), CurTime()
		local Phys = self:GetPhysicsObject()

		if self.EZinstalled then
			if Phys:IsMotionEnabled() or self:IsPlayerHolding() then
				self.EZinstalled = false
				self:TurnOff()

				return
			end
		end

		if State == STATE_BROKEN then
			if self.SoundLoop then self.SoundLoop:Stop() end
			if self.LastState ~= State then
				self:ResetSequence("idle")
				self:ResetSequenceInfo()
				self:SetPlaybackRate(0)
			end

			if self:GetElectricity() > 0 then
				if math.random(1,4) == 2 then JMod.DamageSpark(self) end
			end

			return
		elseif State == STATE_RUNNING then
			if not self.EZinstalled then self:TurnOff() return end

			if not JMod.NaturalResourceTable[self.DepositKey] then 
				self:SetResourceType("N/A")
			end

			self:ConsumeElectricity(.04)
			if self.LastState ~= State then
				self:SetSequence("idle")
				self:ResetSequenceInfo()
			end

			if self:IsSequenceFinished() then
				self:EmitSound("ambient/machines/thumper_hit.wav", 120, 90)
				util.ScreenShake(self:GetPos(), 100, 60, 0.8, 1000)
				local Eff = EffectData()
				Eff:SetOrigin(self:GetAttachment(1).Pos)
				Eff:SetScale(508)
				util.Effect("ThumperDust", Eff, true, true)
				self:EmitSound("ambient/machines/thumper_dust.wav")
				self:ResetSequenceInfo()

				if self:GetResourceType() ~= "N/A" then
					-- This is just the rate at which we pump
					local pumpRate = (JMod.EZ_GRADE_BUFFS[self:GetGrade()]^2) * 1.5
					
					-- Here's where we do the rescource deduction, and barrel production
					-- If it's a flow (i.e. water)
					if JMod.NaturalResourceTable[self.DepositKey].rate then
						-- We get the rate
						local flowRate = JMod.NaturalResourceTable[self.DepositKey].rate
						-- and set the progress to what it was last tick + our ability * the flowrate
						self:SetProgress(self:GetProgress() + pumpRate * flowRate)

						-- If the progress exceeds 100
						if self:GetProgress() >= 100 then
							-- Spawn barrel
							local amtToPump = math.min(self:GetProgress(), 100)
							self:ProduceResource()
						end
					else
						self:SetProgress(self:GetProgress() + pumpRate)

						if self:GetProgress() >= 100 then
							local amtToPump = math.min(JMod.NaturalResourceTable[self.DepositKey].amt, 100)
							self:ProduceResource()
							JMod.DepleteNaturalResource(self.DepositKey, amtToPump)
						end
					end
				end
			end

			if self.NextSoundTime <= Time then
				self.NextSoundTime = Time + 3
				JMod.EmitAIsound(self:GetPos(), 1000, 3, 256)
			end

		else
			if self.LastState ~= State then
				self:ResetSequence("idle")
				self:ResetSequenceInfo()
				self:SetPlaybackRate(0)
			end
		end
		
		self.LastState = State
		self:NextThink(CurTime() + 0.1)
		return true
	end
	
	function ENT:ProduceResource()
		local SelfPos, Forward, Up, Right, Typ = self:GetPos(), self:GetForward(), self:GetUp(), self:GetRight(), self:GetResourceType()
		local amt = math.min(self:GetProgress(), 100)

		if amt <= 0 then return end

		local spawnVec = self:WorldToLocal(Vector(SelfPos) + Up * 135 + Right * 80)
		JMod.MachineSpawnResource(self, self:GetResourceType(), amt, spawnVec, Angle(0, 0, 0), Forward*100, true, 200)
		self:SetProgress(self:GetProgress() - amt)
	end

elseif(CLIENT)then
	function ENT:CustomInit()
		--[[local LerpedThump = 0
		self:AddCallback("BuildBonePositions", function(ent, numbones)
			local State = ent:GetState()
			if State == STATE_RUNNING then
				local Vary = math.sin(CurTime() * 1)/2
				LerpedThump = Lerp(math.ease.OutCubic(FrameTime() * 5), LerpedThump, Vary)
			end
		end)]]--
		self.Screen = JMod.MakeModel(self, "models/props_combine/combine_intmonitor003.mdl")
	end
	
	function ENT:Draw()
		self:DrawModel()
		local Up, Right, Forward, Grade, Typ, State = self:GetUp(), self:GetRight(), self:GetForward(), self:GetGrade(), self:GetResourceType(), self:GetState()
		local SelfPos, SelfAng = self:GetPos(), self:GetAngles()
		--
		local BasePos = SelfPos + Up * 32
		local Obscured = util.TraceLine( {
			start = EyePos(),
			endpos = BasePos,
			filter = {
				LocalPlayer(),
				self
			}, 
			mask = MASK_OPAQUE
		}).Hit
	
		local Closeness = LocalPlayer():GetFOV()*(EyePos():Distance(SelfPos))
		local DetailDraw = Closeness < 200000
		if((not(DetailDraw)) and (Obscured))then return end -- if player is far and sentry is obscured, draw nothing
		if(Obscured)then DetailDraw=false end -- if obscured, at least disable details
		if(State == STATE_BROKEN)then DetailDraw = false end -- look incomplete to indicate damage, save on gpu comp too
		if(DetailDraw)then
			local ScreenAng = SelfAng:GetCopy()
			ScreenAng:RotateAroundAxis(ScreenAng:Up(), 90)
			local ScreenPos = SelfPos + Up * 60 - Right * 50 + Forward
			JMod.RenderModel(self.Screen, ScreenPos, ScreenAng, Vector(.5, .75, .75), nil, JMod.EZ_GRADE_MATS[self:GetGrade()])
			if (Closeness < 36000) and (State == STATE_RUNNING) then
				local DisplayAng = SelfAng:GetCopy()
				DisplayAng:RotateAroundAxis(DisplayAng:Right(), 0)
				DisplayAng:RotateAroundAxis(DisplayAng:Up(), 180)
				DisplayAng:RotateAroundAxis(DisplayAng:Forward(), 90)
				local Opacity = math.random(50,150)
				cam.Start3D2D(ScreenPos - Right * 15 + Forward * 25 + Up * 12, DisplayAng, .1)
                    surface.SetDrawColor(10, 10, 10, Opacity + 50)
                    surface.DrawRect(184, -200, 128, 128)
                    JMod.StandardRankDisplay(Grade, 248, -140, 118, Opacity + 50)
                    draw.SimpleTextOutlined("EXTRACTING", "JMod-Display", 250, -60, Color(255, 255, 255, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
                    local ExtractCol = Color(100, 255, 100, Opacity)
                    draw.SimpleTextOutlined(string.upper(Typ), "JMod-Display", 250, -30, ExtractCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
                    draw.SimpleTextOutlined("POWER", "JMod-Display", 250, 0, Color(255, 255, 255, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
                    local ElecFrac=self:GetElectricity()/800
                    local R,G,B=JMod.GoodBadColor(ElecFrac)
                    draw.SimpleTextOutlined(tostring(math.Round(ElecFrac * 100)).."%", "JMod-Display", 250, 30, Color(R, G, B, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
                    draw.SimpleTextOutlined("PROGRESS", "JMod-Display", 250, 60, Color(255, 255, 255, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
                    local ProgressFrac = self:GetProgress() / 100
					local PR, PG, PB = JMod.GoodBadColor(ElecFrac)
                    draw.SimpleTextOutlined(tostring(math.Round(ProgressFrac * 100)).."%", "JMod-Display", 250, 90, Color(PR, PG, PB, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
                    --local CoolFrac=self:GetCoolant()/100
                    --draw.SimpleTextOutlined("COOLANT","JMod-Display",90,0,Color(255,255,255,Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
                    --local R,G,B=JMod.GoodBadColor(CoolFrac)
                    --draw.SimpleTextOutlined(tostring(math.Round(CoolFrac*100)).."%","JMod-Display",90,30,Color(R,G,B,Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
				cam.End3D2D()
			end
		end
	end
	language.Add("ent_aboot_gmod_ezthumperlarge","EZ Thumper-Large")
end