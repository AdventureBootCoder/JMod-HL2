-- Jackarunda 2021
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Jackarunda"
ENT.PrintName = "EZ Thumper"
ENT.Category = "JMod - EZ HL:2"
ENT.Spawnable = true -- Temporary, until the next phase of Econ2
ENT.AdminOnly = false
ENT.Base = "ent_jack_gmod_ezmachine_base"
ENT.AutomaticFrameAdvance = true
ENT.EZconsumes = {"power", "parts"}
--
ENT.Model = "models/props_combine/combinethumper002.mdl"
ENT.Mass = 1000
ENT.StaticPerfSpecs = {
	MaxDurability = 100,
	MaxElectricity = 100
}
ENT.DynamicPerfSpecs = {
	Armor = 2
}
--
--ENT.WhitelistedResources = {}
ENT.BlacklistedResources = {"geothermal", "geo"}

local STATE_BROKEN, STATE_OFF, STATE_RUNNING = -1, 0, 1
---
function ENT:CustomSetupDataTables()
	self:NetworkVar("Float", 1, "Progress")
	self:NetworkVar("String", 0, "ResourceType")
end
if(SERVER)then
	function ENT:SpawnFunction(ply, tr)
		local SpawnPos = tr.HitPos + tr.HitNormal * 10
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(Angle(0, 0, 0))
		ent:SetPos(SpawnPos)
		JMod.SetOwner(ent, ply)
		JMod.Colorify(ent)
		ent:Spawn()
		ent:Activate()

		return ent
	end


	function ENT:CustomInit()
		self:SetProgress(0)
		self:SetState(STATE_OFF)
		self:TryPlace()
		self.DepositKey = 0
		self:NextThink(1)
		self.LastState = 0
	end

	function ENT:UpdateDepositKey()
		local SelfPos = self:GetPos()
		-- first, figure out which deposits we are inside of, if any
		local DepositsInRange = {}

		for k, v in pairs(JMod.NaturalResourceTable)do
			-- Make sure the resource is on the whitelist
			local Dist = SelfPos:Distance(v.pos)

			-- store they desposit's key if we're inside of it
			if (Dist <= v.siz) and (not(table.HasValue(self.BlacklistedResources, v.typ))) then 
				if (v.rate) or (v.amt > 0) then
					table.insert(DepositsInRange, k)
				end
			end
		end

		-- now, among all the deposits we are inside of, let's find the closest one
		local ClosestDeposit, ClosestRange = nil, 9e9

		if #DepositsInRange > 0 then
			for k, v in pairs(DepositsInRange)do
				local DepositInfo = JMod.NaturalResourceTable[v]
				local Dist = SelfPos:Distance(DepositInfo.pos)

				if(Dist < ClosestRange)then
					ClosestDeposit = v
					ClosestRange = Dist
				end
			end
		end
		if(ClosestDeposit)then 
			self.DepositKey = ClosestDeposit 
			self:SetResourceType(JMod.NaturalResourceTable[self.DepositKey].typ)
			--print("Our deposit is "..self.DepositKey) --DEBUG
		else 
			self.DepositKey = 0 
			--print("No valid deposit") --DEBUG
		end
	end

	function ENT:TryPlace()
		local Tr = util.QuickTrace(self:GetPos() + Vector(0, 0, 100), Vector(0, 0, -500), self)
		if((Tr.Hit)and(Tr.HitWorld))then
			local Yaw = self:GetAngles().y
			self:SetAngles(Angle(0, Yaw,0))
			self:SetPos(Tr.HitPos + Tr.HitNormal * 0.1)
			--
			local GroundIsSolid = true
			for i = 1, 50 do
				local Contents = util.PointContents(Tr.HitPos - Vector(0, 0, 10 * i))
				if(bit.band(util.PointContents(self:GetPos()), CONTENTS_SOLID) == CONTENTS_SOLID)then GroundIsSolid=false break end
			end
			self:UpdateDepositKey()
			if not self.DepositKey then
				JMod.Hint(self.Owner, "oil derrick")
			elseif(GroundIsSolid)then
				if not(IsValid(self.Weld))then self.Weld = constraint.Weld(self, Tr.Entity, 0, 0, 50000, false, false) end
				if(IsValid(self.Weld) and self.DepositKey)then
					self:TurnOn(self.Owner)
				else
					if self:GetState() > STATE_OFF then
						self:TurnOff()
					end
					JMod.Hint(self.Owner, "machine mounting problem")
				end
			end
		end
	end

	function ENT:TurnOn(activator)
		if(self:GetElectricity() > 0)then
			self:EmitSound("ambient/machines/thumper_startup1.wav", 100)
			self:SetProgress(0)
			timer.Simple(2.8, function()
				if IsValid(self) and self:GetState() == STATE_OFF then
					self:SetState(STATE_RUNNING)
					self.SoundLoop = CreateSound(self, "ambient/machines/thumper_amb.wav")
					self.SoundLoop:Play()
				end
			end)
		else
			JMod.Hint(activator,"nopower")
		end
	end
	
	function ENT:TurnOff()
		self:SetState(STATE_OFF)
		self:ProduceResource(self:GetProgress())
		self:EmitSound("ambient/machines/thumper_shutdown1.wav", 100)

		if self.SoundLoop then
			self.SoundLoop:Stop()
		end
	end

	function ENT:Use(activator)
		local State = self:GetState()
		local OldOwner = self.Owner
		local alt = activator:KeyDown(JMod.Config.AltFunctionKey)
		JMod.SetOwner(self,activator)
		if(IsValid(self.Owner))then
			if(OldOwner ~= self.Owner)then -- if owner changed then reset team color
				JMod.Colorify(self)
			end
		end

		if State == STATE_BROKEN then
			JMod.Hint(activator, "destroyed", self)

			return
		elseif State == STATE_OFF then
			self:TryPlace()
		elseif State == STATE_RUNNING then
			if alt then
				self:ProduceResource(self:GetProgress())

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
			if not IsValid(self.Weld) then
				self.DepositKey = nil
				self.WellPos = nil
				self.Weld = nil
				self:TurnOff()
				print("[HL:2 - JMOD] Invalid weld")
				return
			end

			if not JMod.NaturalResourceTable[self.DepositKey] then 
				self:TurnOff()
				print("[HL:2 - JMOD] Invalid deposit key")
				return
			end

			self:ConsumeElectricity(.02)
			if self.LastState ~= State then
				self:SetSequence("idle")
				self:ResetSequenceInfo()
			end

			if self:IsSequenceFinished() then
				self:EmitSound("ambient/machines/thumper_hit.wav")
				util.ScreenShake(self:GetPos(), 100, 60, 0.8, 1000)
				local Eff = EffectData()
				Eff:SetOrigin(self:GetAttachment(1).Pos)
				Eff:SetScale(254)
				util.Effect("ThumperDust", Eff, true, true)
				self:EmitSound("ambient/machines/thumper_dust.wav")
				self:ResetSequenceInfo()

				-- This is just the rate at which we pump
				local pumpRate = JMod.EZ_GRADE_BUFFS[self:GetGrade()]^2
				
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
						self:ProduceResource(amtToPump)
					end
				else
					self:SetProgress(self:GetProgress() + pumpRate)

					if self:GetProgress() >= 100 then
						local amtToPump = math.min(JMod.NaturalResourceTable[self.DepositKey].amt, 100)
						self:ProduceResource(amtToPump)
						JMod.DepleteNaturalResource(self.DepositKey, amtToPump)
					end
				end
			end

			JMod.EmitAIsound(self:GetPos(), 1000, .5, 256)

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

		local pos = SelfPos
		local spawnVec = self:WorldToLocal(Vector(SelfPos) + Up * 30 + Right * 80)
		JMod.MachineSpawnResource(self, self:GetResourceType(), amt, spawnVec, Angle(0, 0, 0), Forward*100, true, 200)
		self:SetProgress(self:GetProgress() - amt)
	end

elseif(CLIENT)then
	function ENT:Initialize()
		--[[local LerpedThump = 0
		self:AddCallback("BuildBonePositions", function(ent, numbones)
			local State = ent:GetState()
			if State == STATE_RUNNING then
				local Vary = math.sin(CurTime() * 1)/2
				LerpedThump = Lerp(math.ease.OutCubic(FrameTime() * 5), LerpedThump, Vary)
			end
		end)]]--
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
		local DetailDraw = Closeness<36000 -- cutoff point is 400 units when the fov is 90 degrees
		if((not(DetailDraw)) and (Obscured))then return end -- if player is far and sentry is obscured, draw nothing
		if(Obscured)then DetailDraw=false end -- if obscured, at least disable details
		if(State == STATE_BROKEN)then DetailDraw = false end -- look incomplete to indicate damage, save on gpu comp too
		if(DetailDraw)then
			if (Closeness < 20000) and (State == STATE_RUNNING) then
				local DisplayAng = SelfAng:GetCopy()
				DisplayAng:RotateAroundAxis(DisplayAng:Right(), 0)
				DisplayAng:RotateAroundAxis(DisplayAng:Up(), 180)
				DisplayAng:RotateAroundAxis(DisplayAng:Forward(), 90)
				local Opacity = math.random(50,150)
				cam.Start3D2D(SelfPos + Up * 40 - Right * 30 + Forward * 35, DisplayAng, .1)
                    surface.SetDrawColor(10, 10, 10, Opacity + 50)
                    surface.DrawRect(184, -200, 128, 128)
                    JMod.StandardRankDisplay(Grade, 248, -140, 118, Opacity + 50)
                    draw.SimpleTextOutlined("EXTRACTING", "JMod-Display", 250, -60, Color(255, 255, 255, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
                    local ExtractCol = Color(100, 255, 100, Opacity)
                    draw.SimpleTextOutlined(string.upper(Typ) or "N/A", "JMod-Display", 250, -30, ExtractCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
                    draw.SimpleTextOutlined("POWER", "JMod-Display", 250, 0, Color(255, 255, 255, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
                    local ElecFrac=self:GetElectricity()/100
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
	language.Add("ent_jack_gmod_ezdrill","EZ Dill")
end