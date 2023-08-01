-- Jackarunda 2021
AddCSLuaFile()
ENT.Type="anim"
ENT.Base="ent_jack_gmod_ezmachine_base"
ENT.PrintName="EZ Combine Turret"
ENT.Author="AdventureBoots, Jackarunda"
ENT.Category="JMod - EZ HL:2"
ENT.Information="glhfggwpezpznore"
ENT.NoSitAllowed=true
ENT.Spawnable=true
ENT.AdminSpawnable=true
ENT.SpawnHeight=15
ENT.EZconsumes={
    JMod.EZ_RESOURCE_TYPES.AMMO,
    JMod.EZ_RESOURCE_TYPES.POWER,
    JMod.EZ_RESOURCE_TYPES.BASICPARTS,
    JMod.EZ_RESOURCE_TYPES.COOLANT
}
ENT.EZscannerDanger=true
ENT.JModPreferredCarryAngles=Angle(0,0,0)
ENT.EZupgradable=true
ENT.Model="models/aboot/combine/ez_floor_turret.mdl"
--ENT.Mat="models/mat_jack_gmod_ezsentry"
ENT.Mass=nil
ENT.EZcolorable = false
-- config --
ENT.AmmoTypes = {
	["Bullet"] = {TargetingRadius = 1.1}, -- Simple pew pew
	["Pulse Rifle"] = {
		FireRate = 1.2,
		Damage = .35,
		Accuracy = .8,
		BarrelLength = .9,
		MaxAmmo = 1.5,
		TargetingRadius = 1,
		-- make it faster
		SearchSpeed = 1.5,
		TargetLockTime = .5,
		TurnSpeed = 1.5
	},
	["Buckshot"] = {
		FireRate = .4,
		Damage = .35,
		ShotCount = 8,
		Accuracy = .7,
		BarrelLength = .75,
		MaxAmmo = .75,
		TargetingRadius = .75,
		-- make it faster
		SearchSpeed = 1.5,
		TargetLockTime = .5,
		TurnSpeed = 1.5
	}, -- multiple bullets each doing self.Damage
	["API Bullet"] = {
		FireRate = .75,
		Damage = .3
	}, -- Armor Piercing Incendiary, pierces through things and lights fires
	["HE Grenade"] = {
		MaxAmmo = .25,
		FireRate = .3,
		Damage = 3,
		Accuracy = .8,
		BarrelLength = .75
	}, -- explosive projectile
	["Pulse Laser"] = {
		Accuracy = 3,
		Damage = .4,
		MaxElectricity = 2,
		BarrelLength = .75
	}, -- bzew
	["Super Soaker"] = {
		FireRate = 2,
		Damage = 0.01,
		Accuracy = .5,
		BarrelLength = 1,
		MaxAmmo = 1,
		TargetingRadius = 2,
		SearchSpeed = 2,
		TargetLockTime = .1,
		TurnSpeed = 2
	}	
}

--[[
	["bolt"]={ -- crossbow projectile
		MaxAmmo=.75,
		FireRate=.75
	},
	["ion_ball"]={ -- combine ball
		MaxAmmo=.5,
		FireRate=.75
	}--]]
ENT.StaticPerfSpecs = {
	MaxElectricity = 100,
	SearchTime = 7,
	ImmuneDamageTypes = {DMG_POISON, DMG_NERVEGAS, DMG_RADIATION, DMG_DROWN, DMG_DROWNRECOVER},
	ResistantDamageTypes = {DMG_BURN, DMG_SLASH, DMG_SONIC, DMG_ACID, DMG_SLOWBURN, DMG_PLASMA, DMG_DIRECT},
	BlacklistedNPCs = {"npc_enemyfinder", "bullseye_strider_focus", "npc_turret_floor", "npc_turret_ceiling", "npc_turret_ground", "npc_bullseye"},
	WhitelistedNPCs = {"npc_rollermine"},
	SpecialTargetingHeights = {
		["npc_rollermine"] = 15
	},
	MaxDurability = 100,
	ThinkSpeed = 1,
	Efficiency = .8,
	ShotCount = 1,
	BarrelLength = 29,
	MaxCoolant = 100
}
ENT.DynamicPerfSpecs={
	MaxAmmo=200,
	TurnSpeed=60,
	TargetingRadius=20,
	Armor=2,
	FireRate=6,
	Damage=15,
	Accuracy=1,
	SearchSpeed=.5,
	TargetLockTime=5,
	Cooling=1
}
ENT.DynamicPerfSpecExp=1.2
-- All moddable attributes
-- Each mod selected for it is +1, against it is -1
ENT.ModPerfSpecs = {
	MaxAmmo = 0,
	TurnSpeed = 0,
	TargetingRadius = 0,
	Armor = 0,
	FireRate = 0,
	Damage = 0,
	Accuracy = 0,
	SearchSpeed = 0,
	Cooling = 0
}

function ENT:SetMods(tbl, ammoType)
	self.ModPerfSpecs = tbl
	local OldAmmo = self:GetAmmoType()
	self:SetAmmoType(ammoType)
	if (OldAmmo~=ammoType) then
		local AmmoTypeToSpawn = JMod.EZ_RESOURCE_TYPES.AMMO
		if (OldAmmo == "HE Grenade") then
			AmmoTypeToSpawn = JMod.EZ_RESOURCE_TYPES.MUNITIONS
		elseif (OldAmmo == "Super Soaker") then
			AmmoTypeToSpawn = JMod.EZ_RESOURCE_TYPES.WATER
		end
		JMod.MachineSpawnResource(self, AmmoTypeToSpawn, self:GetAmmo(), self:GetForward() * -50 + self:GetUp() * 50, Angle(0, 0, 0), self:GetForward(), true)
	end
	self:InitPerfSpecs(OldAmmo ~= ammoType)
	if(ammoType == "Pulse Laser")then
		self.EZconsumes={JMod.EZ_RESOURCE_TYPES.POWER, JMod.EZ_RESOURCE_TYPES.BASICPARTS, JMod.EZ_RESOURCE_TYPES.COOLANT}
	elseif(ammoType == "HE Grenade")then
		self.EZconsumes = {JMod.EZ_RESOURCE_TYPES.MUNITIONS, JMod.EZ_RESOURCE_TYPES.POWER, JMod.EZ_RESOURCE_TYPES.BASICPARTS, JMod.EZ_RESOURCE_TYPES.COOLANT}
	elseif(ammoType == "Super Soaker")then
		self.EZconsumes = {JMod.EZ_RESOURCE_TYPES.WATER, JMod.EZ_RESOURCE_TYPES.POWER, JMod.EZ_RESOURCE_TYPES.BASICPARTS, JMod.EZ_RESOURCE_TYPES.COOLANT}
	else
		self.EZconsumes = {JMod.EZ_RESOURCE_TYPES.AMMO, JMod.EZ_RESOURCE_TYPES.POWER, JMod.EZ_RESOURCE_TYPES.BASICPARTS, JMod.EZ_RESOURCE_TYPES.COOLANT}
	end
end

function ENT:InitPerfSpecs(removeAmmo)
	local PerfMult=self:GetPerfMult() or 1
	local Grade=self:GetGrade()
	for specName,value in pairs(self.StaticPerfSpecs)do self[specName]=value end
	for specName,value in pairs(self.DynamicPerfSpecs)do self[specName]=value*PerfMult*JMod.EZ_GRADE_BUFFS[Grade]^self.DynamicPerfSpecExp end
	self.MaxAmmo=math.Round(self.MaxAmmo/100)*100 -- a sight for sore eyes, ey jack?-titanicjames
	self.TargetingRadius=self.TargetingRadius*52.493 -- convert meters to source units
	
	local MaxValue=10
	for attrib,value in pairs(self.ModPerfSpecs) do
		local oldVal=self[attrib]
		if value > 0 then
			local ratio = (math.abs(value / MaxValue) + 1) ^ 1.5
			self[attrib] = self[attrib] * ratio
			--print(attrib.." "..value.." ----- "..oldVal.." -> "..self[attrib])
		elseif value < 0 then
			local ratio = (math.abs(value / MaxValue) + 1) ^ 3
			self[attrib] = self[attrib] / ratio
		end
		--print(attrib.." "..value.." ----- "..oldVal.." -> "..self[attrib])
	end

	-- Finally apply AmmoType attributes
	if self.AmmoTypes[self:GetAmmoType()] then
		for attrib, mult in pairs(self.AmmoTypes[self:GetAmmoType()]) do
			--print("applying AmmoType multiplier of "..mult .." to "..attrib..": "..self[attrib].." -> "..self[attrib]*mult)
			self[attrib] = self[attrib] * mult
		end
	end

	if self:GetAmmoType() == "Super Soaker" then
		self.MaxWater = self.MaxAmmo
	end

	if self:GetAmmoType() ~= "Pulse Laser" then
		-- no juking the ammo capacity, fag
		self:SetAmmo((removeAmmo and 0) or math.min(self:GetAmmo(), self.MaxAmmo))
	else
		-- except for lasers cause they don't use ammo
		self:SetAmmo(self.MaxAmmo)
		self.MaxElectricity = self.MaxAmmo / 1.5
	end
end

----
local STATE_BROKEN,STATE_OFF,STATE_WATCHING,STATE_SEARCHING,STATE_ENGAGING,STATE_WHINING,STATE_OVERHEATED,STATE_FALLEN=-1,0,1,2,3,4,5,6
function ENT:CustomSetupDataTables()
	self:NetworkVar("Int",2,"Ammo")
	self:NetworkVar("Float",1,"AimPitch")
	self:NetworkVar("Float",2,"AimYaw")
	self:NetworkVar("Float",3,"PerfMult")
	self:NetworkVar("Float",4,"Coolant")
	self:NetworkVar("String",0,"AmmoType")
end

function ENT:SetWater(amt)
	self:SetAmmo(math.Clamp(amt, 0, self.MaxWater))
end

function ENT:GetWater()
	return self:GetAmmo()
end

if(SERVER)then
	function ENT:CustomInit()
		local phys=self.Entity:GetPhysicsObject()
		if phys:IsValid()then
			phys:SetBuoyancyRatio(.3)
		end

		---
		self:SetAmmoType("Pulse Rifle")
		--JMod.Colorify(self)
		self:SetPerfMult(JMod.Config.Machines.Sentry.PerformanceMult)
		self:InitPerfSpecs()
		---
		self:Point(0, 0)
		self.SearchStageTime = self.SearchTime / 2
		self.NextWhine=0
		self.Heat=0
		self:ResetMemory()
		self:CreateNPCTarget()
		---
		if self.SpawnFull then
			self:SetAmmo(self.MaxAmmo)
			self:SetCoolant(self.MaxCoolant)
		else
			self:SetAmmo(0)
			self:SetCoolant(0)
		end
	end

	function ENT:ResetMemory()
		self.NextFire = 0
		self.NextRealThink = 0
		self.Firing = false
		self.NextTargetSearch = 0
		self.Target = nil
		self.NextTargetReSearch = 0
		self.NextFixTime = 0
		self.NextUseTime = 0
		self.NextPingTime = 0
		self.NextEndPanicTime = 0
		if self.AlertSound then
			self.AlertSound:Stop()
		end

		self.SearchData = {
			LastKnownTarg = nil,
			LastKnownPos = nil,
			LastKnownVel = nil,
			NextDeEsc = 0, -- next de-escalation to the watching state
			NextSearchChange = 0, -- time to move on to the next phase of searching
			State = 0 -- 0=not searching, 1=aiming at last known point, 2=aiming at predicted point
		}
	end
	
	function ENT:PostEntityPaste(ply, ent, createdEntities)
		JMod.SetEZowner(self, ply, true)
		self:ResetMemory()
	end

	function ENT:CreateNPCTarget()
		if not IsValid(self.NPCTarget) then
			self.NPCTarget = ents.Create("npc_bullseye")
			self.NPCTarget:SetPos(self:GetPos() + self:GetUp() * 60 + self:GetForward() * 15)
			self.NPCTarget:SetParent(self)
			self.NPCTarget:Spawn()
			self.NPCTarget:Activate()
			self.NPCTarget:SetNotSolid(true)
			self.NPCTarget:SetHealth(9e9)
			--self.NPCTarget.NoCollideAll=true
			--self.NPCTarget:SetCustomCollisionCheck(true)
		end
	end

	function ENT:RemoveNPCTarget()
		if IsValid(self.NPCTarget) then
			self.NPCTarget:Remove()
		end
	end

	function ENT:MakeHostileToMe(npc)
		if not IsValid(self.NPCTarget) then
			self:CreateNPCTarget()
		end

		if npc.AddEntityRelationship then
			npc:AddEntityRelationship(self.NPCTarget, D_HT, 90)
		end
	end

	function ENT:AddVisualRecoil(amt)
		net.Start("JMod_VisualGunRecoil")
		net.WriteEntity(self)
		net.WriteFloat(amt)
		net.Broadcast()
	end

	function ENT:ConsumeElectricity(amt)
		amt=(amt or .04)
		if(self:GetAmmoType()=="Pulse Laser")then
			amt=amt/JMod.EZ_GRADE_BUFFS[self:GetGrade()]
		end

		local NewAmt = math.Clamp(self:GetElectricity() - amt, 0, self.MaxElectricity)
		self:SetElectricity(NewAmt)

		if NewAmt <= 0 then
			self:TurnOff()
		end
	end

	function ENT:CustomDetermineDmgMult(dmginfo)
		local Mult = 1
		return Mult
	end

	function ENT:OnBreak()
		self:RemoveNPCTarget()
	end

	function ENT:Use(activator)
		if activator:IsPlayer() then
			local State, Alt = self:GetState(), activator:KeyDown(JMod.Config.General.AltFunctionKey)

			if Alt then
				activator:PickupObject(self)
				
				return
			end
			if State == STATE_BROKEN then
				JMod.Hint(activator, "destroyed")

				return
			end

			if (State > 0) and not(IsValid(self.Target) and activator == self.Target) then
				self:TurnOff()
			else
				if self:GetElectricity() > 0 then
					self:TurnOn(activator)
					JMod.Hint(activator, "sentry friends")
				else
					JMod.Hint(activator, "nopower")
				end
			end
		end
	end

	function ENT:TurnOff(autoReactivate)
		if (self:GetState() <= 0) then return end
		self:SetState(STATE_OFF)
		self:EmitSound("npc/turret_floor/die.wav", 65, 100)
		self:ResetMemory()
		self:RemoveNPCTarget()
	end

	function ENT:OnRemove()
		self:RemoveNPCTarget()
	end

	function ENT:TurnOn(activator)
		if self:GetState() > STATE_OFF then return end
		local OldOwner = self.EZowner
		JMod.SetEZowner(self, activator, false)
		self:SetState(STATE_WATCHING)
		self:EmitSound("snds_jack_gmod/ezsentry_startup.wav", 65, 100)
		self:ResetMemory()
		self:CreateNPCTarget()
	end

	function ENT:DetermineTargetAimPoint(ent)
		if not IsValid(ent) then return nil end

		if ent:IsPlayer() then
			if ent:Crouching() then
				return ent:GetShootPos() - Vector(0, 0, 5)
			else
				return ent:GetShootPos() - Vector(0, 0, 15)
			end
		elseif ent:IsNPC() then
			local Class, Height = ent:GetClass(), 0
			local SpecialTargetingHeight = self.SpecialTargetingHeights[Class]

			if SpecialTargetingHeight then
				Height = SpecialTargetingHeight
			else
				Height = ent:OBBMaxs().z - ent:OBBMins().z
			end

			return ent:GetPos() + Vector(0, 0, Height * .5)
		else
			return ent:LocalToWorld(ent:OBBCenter())
		end
	end

	function ENT:GetVel(ent)
		if not IsValid(ent) then return Vector(0, 0, 0) end
		local Phys = (ent.GetPhysicsObject and ent:GetPhysicsObject()) or nil

		if IsValid(Phys) then
			return Phys:GetVelocity()
		else
			return ent:GetVelocity()
		end
	end

	function ENT:CanSee(ent)
		if not IsValid(ent) then return false end
		local TargPos, SelfPos = self:DetermineTargetAimPoint(ent), self:GetPos() + self:GetUp() * 60
		local Dist = TargPos:Distance(SelfPos)
		if Dist > self.TargetingRadius then return false end

		local TargetAngle = self:WorldToLocal(TargPos):Angle().y
		if not((TargetAngle < 40) or (TargetAngle > 320)) then return false end

		local Tr = util.TraceLine({
			start = SelfPos,
			endpos = TargPos,
			filter = {self, ent, self.NPCTarget},
			mask = MASK_SHOT + MASK_WATER
		})

		return not Tr.Hit
	end

	function ENT:ShouldSoak(ent)
		if not IsValid(ent) then return false end
		if ent == self then return false end
		if ent:IsOnFire() then return true end
		if ent.TryLoadResource and ent.GetWater and (ent:GetWater() < 100) then return true end
	end

	function ENT:CanEngage(ent)
		if not IsValid(ent) then return false end
		if ent == self.NPCTarget then return false end

		if self:GetAmmoType() == "Super Soaker" then
			return self:ShouldSoak(ent) and self:CanSee(ent)
		else
			return JMod.ShouldAttack(self, ent) and self:CanSee(ent)
		end
	end

	function ENT:TryFindTarget()
		local Time = CurTime()

		if self.NextTargetSearch > Time then
			if self:CanEngage(self.Target) then return self.Target end
			if self:CanEngage(self.SearchData.LastKnownTarg) then return self.SearchData.LastKnownTarg end

			return nil
		end

		self:ConsumeElectricity(.02)
		self.NextTargetSearch = Time + (.5 / self.SearchSpeed) -- limit searching cause it's expensive
		local SelfPos = self:GetPos()
		local Objects, PotentialTargets = ents.FindInSphere(SelfPos, self.TargetingRadius), {}

		for k, PotentialTarget in pairs(Objects) do
			if self:CanEngage(PotentialTarget) then
				table.insert(PotentialTargets, PotentialTarget)
			end
		end

		if #PotentialTargets > 0 then
			table.sort(PotentialTargets, function(a, b)
				local DistA, DistB = a:GetPos():Distance(SelfPos), b:GetPos():Distance(SelfPos)

				return DistA < DistB
			end)

			for k, v in pairs(PotentialTargets) do
				self:MakeHostileToMe(v)
			end

			return PotentialTargets[1]
		end

		return nil
	end

	function ENT:Engage(target)
		self.Target = target
		self.SearchData.LastKnownTarg = self.Target
		self.SearchData.LastKnownVel = self:GetVel(self.Target)
		self.SearchData.LastKnownPos = self:DetermineTargetAimPoint(self.Target)
		self.NextTargetReSearch = CurTime() + self.TargetLockTime
		self.SearchData.State = 0
		self:SetState(STATE_ENGAGING)
		self:EmitSound("npc/turret_floor/active.wav", 100, 100)
		JMod.Hint(self.EZowner, "sentry upgrade")
	end

	function ENT:Disengage()
		local Time = CurTime()
		self.SearchData.State = 1
		self.SearchData.NextSearchChange = Time + self.SearchStageTime
		self.SearchData.NextDeEsc = Time + self.SearchTime
		self:SetState(STATE_SEARCHING)
		self:EmitSound("npc/turret_floor/ping.wav", 65, 100)
	end

	function ENT:StandDown()
		self.Target = nil
		self.SearchData.State = 0
		self:SetState(STATE_WATCHING)
		self:EmitSound("npc/turret_floor/retract.wav", 65, 100)
		JMod.Hint(self.EZowner, "sentry modify")
	end

	function ENT:Panic()
		--self.PanicSound = CreateSound(self, "npc/turret_floor/alarm.wav")
		--self.PanicSound:Play()
		self:SetState(STATE_FALLEN)
		self.NextEndPanicTime = Time + 3
	end

	function ENT:Think()
		local Time = CurTime()

		if self.NextRealThink < Time then
			local Electricity, Ammo = self:GetElectricity(), self:GetAmmo()
			self.NextRealThink = Time + .25 / self.ThinkSpeed
			self.Firing = false
			local State = self:GetState()
			local SelfAng = self:GetAngles()
			local Tipped = ((SelfAng.p > 60 or SelfAng.p < -60) or (SelfAng.r > 60 or SelfAng.r < -60))

			if State > 0 then
				if self.Heat > 90 then
					if State ~= STATE_OVERHEATED then
						self:SetState(STATE_OVERHEATED)
					end
				elseif State == STATE_OVERHEATED then
					if self.Heat < 45 then
						self:SetState(STATE_WATCHING)
					end
				else
					if Ammo <= 0 then
						if State ~= STATE_WHINING then
							self:SetState(STATE_WHINING)
						end
					elseif State == STATE_WHINING then
						self:SetState(STATE_WATCHING)
					end
				end
				if State ~= STATE_FALLEN and Tipped then
					self:SetState(STATE_FALLEN)
					self:ReturnToForward()
					self.AlertSound = CreateSound(self, "npc/turret_floor/alert.wav")
					self.AlertSound:Play()
					self.NextWhine = Time + math.Rand(1.5, 2)
					timer.Simple(1, function() 
						if IsValid(self) and self.AlertSound then
							self.AlertSound:Stop()
						end
					end)
				elseif State == STATE_FALLEN and not(Tipped) then 
					self:SetState(STATE_WATCHING)
					if self.AlertSound then
						self.AlertSound:Stop()
					end
				end
			end

			if State == STATE_WATCHING then
				local Target = self:TryFindTarget()

				if Target then
					self:Engage(Target)
				else
					self:ReturnToForward()
				end
			elseif State == STATE_SEARCHING then
				if self:CanEngage(self.Target) then
					self:Engage(self.Target)
				else
					local Target = self:TryFindTarget()

					if IsValid(Target) then
						self:Engage(Target)
					else -- use search behavior
						local SearchState = self.SearchData.State

						if SearchState == 0 then
							self:StandDown()
						elseif SearchState == 1 then
							-- aim at last known point
							local NeedTurnPitch, NeedTurnYaw = self:GetTargetAimOffset(self.SearchData.LastKnownPos)

							if (math.abs(NeedTurnPitch) > 0) or (math.abs(NeedTurnYaw) > 0) then
								self:Turn(NeedTurnPitch, NeedTurnYaw)
							end
						elseif SearchState == 2 then
							-- aim at last known predicted point
							local PredictedPos = self.SearchData.LastKnownPos + self.SearchData.LastKnownVel * self.SearchStageTime
							local NeedTurnPitch, NeedTurnYaw = self:GetTargetAimOffset(PredictedPos)

							if (math.abs(NeedTurnPitch) > 0) or (math.abs(NeedTurnYaw) > 0) then
								self:Turn(NeedTurnPitch, NeedTurnYaw)
							end
						end

						if self.NextPingTime < Time then
							self.NextPingTime = Time + 0.75
							self:EmitSound("npc/turret_floor/ping.wav", 80, 100)
						end

						if self.SearchData.NextSearchChange < Time then
							self.SearchData.NextSearchChange = Time + self.SearchStageTime
							self.SearchData.State = self.SearchData.State + 1

							if self.SearchData.State == 3 then
								self:StandDown()
							end
						end

						if self.SearchData.NextDeEsc < Time then
							self:StandDown()
						end
					end
				end
			elseif State == STATE_ENGAGING then
				if self:CanEngage(self.Target) then
					if self.NextTargetReSearch < Time then
						self.NextTargetReSearch = Time + self.TargetLockTime
						local NewTarget = self:TryFindTarget()

						if NewTarget and (NewTarget ~= self.Target) then
							self:Engage(NewTarget)
						end
					else
						local TargPos = self:DetermineTargetAimPoint(self.Target)
						self.SearchData.LastKnownTarg = self.Target
						self.SearchData.LastKnownVel = self:GetVel(self.Target)
						self.SearchData.LastKnownPos = TargPos
						local NeedTurnPitch, NeedTurnYaw = self:GetTargetAimOffset(TargPos)
						local GottaTurnP, GottaTurnY = math.abs(NeedTurnPitch), math.abs(NeedTurnYaw)

						if (GottaTurnP > 0) or (GottaTurnY > 0) then
							self:Turn(NeedTurnPitch, NeedTurnYaw)
						end

						if (GottaTurnP < 5) and (GottaTurnY < 5) then
							self.Firing = true
						end
					end
				else
					local Target = self:TryFindTarget()

					if Target then
						self:Engage(Target)
					else
						self:Disengage()
					end
				end
			elseif State == STATE_BROKEN then
				if Electricity > 0 then
					if math.random(1, 4) == 2 then
						JMod.DamageSpark(self)
					end
				end
			elseif State == STATE_WHINING then
				self:Whine(true)
			elseif State == STATE_FALLEN then
				self:Whine(true)
			end

			if ((Electricity < self.MaxElectricity * .1) or (Ammo < self.MaxAmmo * .1)) and (State > 0) then
				self:Whine()
			end

			if self.NextFixTime < Time then
				self.NextFixTime = Time + 10
				self:GetPhysicsObject():SetBuoyancyRatio(.3)
			end

			---
			if self.Heat > 55 then
				local SelfPos, Up, Right, Forward = self:GetPos(), self:GetUp(), self:GetRight(), self:GetForward()
				local AimAng = SelfAng
				AimAng:RotateAroundAxis(Right, self:GetAimPitch())
				AimAng:RotateAroundAxis(Up, self:GetAimYaw())
				local AimForward = AimAng:Forward()
				local ShootPos = SelfPos + Up * 56 + AimForward * self.BarrelLength
				---
				local Exude = EffectData()
				Exude:SetOrigin(ShootPos)
				Exude:SetStart(self:GetVelocity())
				util.Effect("eff_jack_heatshimmer", Exude)
			end

			local CoolinAmt, Kewlant, Severity = self.Cooling / 3, self:GetCoolant(), self.Heat / 300

			if (Kewlant > 0) and (Severity > .1) then
				self:SetCoolant(Kewlant - Severity ^ 2 * 20)
				CoolinAmt = CoolinAmt * (200 * Severity ^ 2)
			end

			self.Heat = math.Clamp(self.Heat - CoolinAmt, 0, 100)
		end

		if self.Firing then
			if self.NextFire < Time then
				self.NextFire = Time + 1 / self.FireRate --  (1/self.FireRate^1.2+0.05) 
				self:FireAtPoint(self.SearchData.LastKnownPos, self.SearchData.LastKnownVel or Vector(0, 0, 0))
			end
		end

		self:NextThink(Time + .02)

		return true
	end

	function ENT:FireAtPoint(point, targVel)
		if not point then return end
		local Ammo = self:GetAmmo()
		if Ammo <= 0 then return end
		local SelfPos, Up, Right, Forward, ProjType = self:GetPos(), self:GetUp(), self:GetRight(), self:GetForward(), self:GetAmmoType()
		local AimAng = self:GetAngles()
		AimAng:RotateAroundAxis(AimAng:Up(), self:GetAimYaw())
		local AimForward = AimAng:Forward()
		local ShootPos = SelfPos + AimForward * (self.BarrelLength - 12) + AimAng:Up() * 56
		local AmmoConsume, ElecConsume = 1, .02
		local Heat = self.Damage * self.ShotCount / 30
		self:AddVisualRecoil(Heat * 2)

		---
		if ProjType == "Bullet" then
			local ShellAng = AimAng:GetCopy()
			ShellAng:RotateAroundAxis(ShellAng:Up(), -90)
			local Eff = EffectData()
			Eff:SetOrigin(SelfPos + Up * 36 + AimForward * 5)
			Eff:SetAngles(ShellAng)
			Eff:SetEntity(self)
			---
			local Dmg, Inacc = self.Damage, .06 / self.Accuracy
			local Force = Dmg / 5
			local ShootDir = (point - ShootPos):GetNormalized()

			if Dmg >= 60 then
				util.Effect("RifleShellEject", Eff, true, true)
				sound.Play("snds_jack_gmod/sentry_powerful.wav", SelfPos, 70, math.random(90, 110))
				ParticleEffect("muzzle_center_M82", ShootPos, AimAng, self)
			elseif Dmg >= 15 then
				util.Effect("RifleShellEject", Eff, true, true)
				sound.Play("snds_jack_gmod/sentry.wav", SelfPos, 70, math.random(90, 110))
				ParticleEffect("muzzleflash_g3", ShootPos, AimAng, self)
			else
				util.Effect("ShellEject", Eff, true, true)
				sound.Play("snds_jack_gmod/sentry_weak.wav", SelfPos, 70, math.random(90, 110))
				ParticleEffect("muzzleflash_pistol", ShootPos, AimAng, self)
			end

			sound.Play("snds_jack_gmod/sentry_far.wav", SelfPos + Up, 100, math.random(90, 110))
			ShootDir = (ShootDir + VectorRand() * math.Rand(.05, 1) * Inacc):GetNormalized()

			local Ballut = {
				Attacker = self.EZowner or self,
				Callback = nil,
				Damage = Dmg,
				Force = Force,
				Distance = nil,
				HullSize = nil,
				Num = self.ShotCount,
				Tracer = 5,
				TracerName = "eff_jack_gmod_smallarmstracer",
				Dir = ShootDir,
				Spread = Vector(0, 0, 0),
				Src = ShootPos,
				IgnoreEntity = nil
			}

			self:FireBullets(Ballut)
		elseif ProjType == "Pulse Rifle" then
			local ShellAng = AimAng:GetCopy()
			ShellAng:RotateAroundAxis(ShellAng:Up(), -90)
			local Eff = EffectData()
			Eff:SetOrigin(SelfPos + Up * 36 + AimForward * 5)
			Eff:SetAngles(ShellAng)
			Eff:SetFlags(5)
			Eff:SetEntity(self)
			---
			local Dmg, Inacc = self.Damage, .06 / self.Accuracy
			local Force = Dmg / 5
			local ShootDir = (point - ShootPos):GetNormalized()

			util.Effect("MuzzleFlash", Eff)

			sound.Play("weapons/ar2/fire1.wav", SelfPos + Up, 100, math.random(80, 100))
			ShootDir = (ShootDir + VectorRand() * math.Rand(.05, 1) * Inacc):GetNormalized()

			local Ballut = {
				Attacker = self.EZowner or self,
				Callback = nil,
				Damage = Dmg,
				Force = Force,
				Distance = nil,
				HullSize = nil,
				Num = self.ShotCount,
				Tracer = 5,
				TracerName = "AR2Tracer",
				Dir = ShootDir,
				Spread = Vector(0, 0, 0),
				Src = ShootPos,
				IgnoreEntity = nil
			}

			self:FireBullets(Ballut)
		elseif ProjType == "Buckshot" then
			ParticleEffect("muzzleflash_shotgun", ShootPos, AimAng, self)
			local ShellAng = AimAng:GetCopy()
			ShellAng:RotateAroundAxis(ShellAng:Up(), -90)
			local Eff = EffectData()
			Eff:SetOrigin(SelfPos + Up * 36 + AimForward * 5)
			Eff:SetAngles(ShellAng)
			Eff:SetEntity(self)
			---
			local Dmg, Inacc = self.Damage, .06 / self.Accuracy
			local Force = Dmg / 5
			local ShootDir = (point - ShootPos):GetNormalized()
			util.Effect("ShotgunShellEject", Eff, true, true)
			sound.Play("snds_jack_gmod/sentry_shotgun.wav", SelfPos, 70, math.random(90, 110))
			sound.Play("snds_jack_gmod/sentry_far.wav", SelfPos + Up, 100, math.random(90, 110))

			local Ballut = {
				Attacker = self.EZowner or self,
				Callback = nil,
				Damage = Dmg,
				Force = Force,
				Distance = nil,
				HullSize = nil,
				Num = self.ShotCount,
				Tracer = 0,
				Dir = ShootDir,
				Spread = Vector(Inacc, Inacc, Inacc),
				Src = ShootPos,
				IgnoreEntity = nil
			}

			self:FireBullets(Ballut)
		elseif ProjType == "API Bullet" then
			local ShellAng = AimAng:GetCopy()
			ShellAng:RotateAroundAxis(ShellAng:Up(), -90)
			local Eff = EffectData()
			Eff:SetOrigin(SelfPos + Up * 36 + AimForward * 5)
			Eff:SetAngles(ShellAng)
			Eff:SetEntity(self)
			---
			local Dmg, Inacc = self.Damage, .06 / self.Accuracy
			local Force = Dmg / 5
			local ShootDir = (point - ShootPos):GetNormalized()
			util.Effect("RifleShellEject", Eff, true, true)
			sound.Play("snds_jack_gmod/sentry.wav", SelfPos, 70, math.random(90, 110))
			ParticleEffect("muzzleflash_pistol_deagle", ShootPos, AimAng, self)
			sound.Play("snds_jack_gmod/sentry_far.wav", SelfPos + Up, 100, math.random(90, 110))
			ShootDir = (ShootDir + VectorRand() * math.Rand(.05, 1) * Inacc):GetNormalized()

			JMod.RicPenBullet(self, ShootPos, ShootDir, Dmg, false, false, 1, 15, "eff_jack_gmod_smallarmstracer", function(att, tr, dmg)
				local ent = tr.Entity
				local Poof = EffectData()
				Poof:SetOrigin(tr.HitPos)
				Poof:SetScale(1)
				Poof:SetNormal(tr.HitNormal)
				util.Effect("eff_jack_gmod_incbullet", Poof, true, true)
				---
				local DmgI = DamageInfo()
				DmgI:SetDamage(dmg:GetDamage())
				DmgI:SetDamageType(DMG_BURN)
				DmgI:SetDamageForce(dmg:GetDamageForce())
				DmgI:SetAttacker(dmg:GetAttacker())
				DmgI:SetInflictor(dmg:GetInflictor())
				DmgI:SetDamagePosition(dmg:GetDamagePosition())

				if ent.TakeDamageInfo then
					ent:TakeDamageInfo(DmgI)
				end

				---
				if not ent:IsWorld() and ent.GetPhysicsObject then
					local Mass = 100
					local Phys = ent:GetPhysicsObject()

					if IsValid(Phys) and Phys.GetMass then
						Mass = Phys:GetMass()
					end

					local Chance = (Dmg / Mass) * 3

					if math.Rand(0, 1) < Chance then
						ent:Ignite(math.random(1, 5))
					end
				end
			end)
		elseif ProjType == "HE Grenade" then
			local Dmg, Inacc = self.Damage, .06 / self.Accuracy
			sound.Play("snds_jack_gmod/sentry_gl.wav", SelfPos, 70, math.random(90, 110))
			ParticleEffect("muzzleflash_m79", ShootPos, AimAng, self)
			sound.Play("snds_jack_gmod/sentry_far.wav", SelfPos + Up, 100, math.random(90, 110))
			local Shell = ents.Create("ent_jack_gmod_ez40mmshell")
			Shell:SetPos(SelfPos + Up * 36 + AimForward * 5)
			Shell:SetAngles(AngleRand())
			Shell:Spawn()
			Shell:Activate()
			constraint.NoCollide(Shell, self, 0, 0)
			Shell:GetPhysicsObject():SetVelocity(self:GetVelocity() + Up * 100 - AimForward * 100 + Right * 100 + VectorRand() * 100)
			-- leading calcs --
			local Speed, Gravity = 2000, 600
			local TargetVec = point - ShootPos
			local Distance = TargetVec:Length()
			local FlightTime = Distance / Speed
			local CorrectedFirePosition = point + targVel * FlightTime
			local ShootDir = (CorrectedFirePosition - ShootPos):GetNormalized()
			-- ballistic calcs --
			local Theta = math.deg(math.asin(Distance * Gravity / Speed ^ 2) / 2)

			-- target too far away, no mathematical solution possible, shoot at 45 degrees
			if Theta ~= Theta then
				Theta = 45
			end

			Theta = Theta * (1 - math.abs(TargetVec:GetNormalized().z)) --reduce angle compensation to account for vertical displacement

			if Theta > 45 then
				Theta = 45
			end

			local ShootAng = ShootDir:Angle()
			ShootAng:RotateAroundAxis(ShootAng:Right(), Theta ^ 1.1)
			ShootDir = ShootAng:Forward()
			-- end calcs --
			ShootDir = (ShootDir + VectorRand() * math.Rand(.05, 1) * Inacc):GetNormalized()
			local Gnd = ents.Create("ent_jack_gmod_ezprojectilenade")
			Gnd:SetPos(ShootPos)
			ShootAng:RotateAroundAxis(ShootAng:Right(), -90)
			Gnd:SetAngles(ShootAng)
			JMod.SetEZowner(Gnd, self.EZowner or self)
			Gnd.Dmg = Dmg
			Gnd:Spawn()
			Gnd:Activate()
			Gnd:GetPhysicsObject():SetVelocity(self:GetVelocity() + ShootDir * Speed)
		elseif ProjType == "Pulse Laser" then
			local Dmg, Inacc = self.Damage, .06 / self.Accuracy
			local Force = Dmg / 5
			local ShootDir = (point - ShootPos):GetNormalized()
			sound.Play("snds_jack_gmod/sentry_laser" .. math.random(1, 2) .. ".wav", SelfPos, 70, math.random(90, 110))
			sound.Play("snds_jack_gmod/sentry_far.wav", SelfPos + Up, 100, math.random(90, 110))
			ShootDir = (ShootDir + VectorRand() * math.Rand(.05, 1) * Inacc):GetNormalized()
			local Zap = EffectData()
			Zap:SetOrigin(ShootPos)
			Zap:SetNormal(ShootDir)
			Zap:SetStart(self:GetVelocity())
			util.Effect("eff_jack_gmod_pulselaserfire", Zap, true, true)

			local Tr = util.TraceLine({
				start = ShootPos,
				endpos = ShootPos + ShootDir * 20000,
				mask = -1,
				filter = {self}
			})

			if Tr.Hit then
				local Derp = EffectData()
				Derp:SetStart(ShootPos)
				Derp:SetOrigin(Tr.HitPos)
				Derp:SetScale(1)
				util.Effect("eff_jack_heavylaserbeam", Derp, true, true)
				local Derp2 = EffectData()
				Derp2:SetOrigin(Tr.HitPos + Tr.HitNormal * 2)
				Derp2:SetScale(1)
				Derp2:SetNormal(Tr.HitNormal)
				util.Effect("eff_jack_heavylaserbeamimpact", Derp2, true, true)
				---
				local DmgInfo = DamageInfo()
				DmgInfo:SetAttacker(self.EZowner or self)
				DmgInfo:SetInflictor(self)

				if Tr.Entity:IsOnFire() then
					DmgInfo:SetDamageType(DMG_DIRECT)
				else
					DmgInfo:SetDamageType(DMG_BURN)
				end

				DmgInfo:SetDamagePosition(Tr.HitPos)
				DmgInfo:SetDamageForce(ShootDir * Dmg)
				DmgInfo:SetDamage(Dmg)

				if Tr.Entity.TakeDamageInfo then
					Tr.Entity:TakeDamageInfo(DmgInfo)
				end

				util.Decal("FadingScorch", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
				sound.Play("snd_jack_heavylaserburn.wav", Tr.HitPos, 60, math.random(90, 110))
			end

			Heat = Heat * 3
			AmmoConsume = 0
			ElecConsume = .025 * Dmg
		elseif ProjType == "Super Soaker" then
			local ShellAng = AimAng:GetCopy()
			ShellAng:RotateAroundAxis(ShellAng:Up(), -90)
			local Eff = EffectData()
			Eff:SetOrigin(SelfPos + Up * 36 + AimForward * 5)
			Eff:SetAngles(ShellAng)
			Eff:SetFlags(5)
			Eff:SetEntity(self)
			---
			local ShootDir = (point - ShootPos):GetNormalized()

			util.Effect("MuzzleFlash", Eff)

			sound.Play("physics/surfaces/underwater_impact_bullet"..math.random(1, 3)..".wav", SelfPos + Up, 100, math.random(80, 100))
			
			local EntsToWet = ents.FindInSphere(point, 256)
			for i = 1, #EntsToWet do
				local Ent = EntsToWet[i]
				if Ent:IsOnFire() then
					if math.random(1, 2) == 2 then
						Ent:Extinguish() 
					end

					break
				elseif Ent.GetWater and Ent:GetWater() < 100 then
					Ent:SetWater(math.Clamp(Ent:GetWater() + 1, 0, 100))

					break
				end
			end
			Heat = 0
			AmmoConsume = 2
			ElecConsume = 0.1
		end

		---
		if math.random(1, 2) == 2 then
			local Force = -AimForward * 15 * self.Damage * self.ShotCount * 2

			if Force:Length() > 2000 then
				self:GetPhysicsObject():ApplyForceCenter(Force)
			end
		end

		self.Heat = math.Clamp(self.Heat + Heat, 0, 100)
		self:SetAmmo(Ammo - AmmoConsume)
		self:ConsumeElectricity(ElecConsume)
	end

	function ENT:GetTargetAimOffset(point)
		if not point then return nil, nil end
		local SelfPos = self:GetPos() + self:GetUp() * 35
		local TargAng = self:WorldToLocalAngles((point - SelfPos):Angle())
		local GoalPitch, GoalYaw = -TargAng.p, TargAng.y
		local CurPitchOffset, CurYawOffset = self:GetAimPitch(), self:GetAimYaw()

		return -(CurPitchOffset - GoalPitch), CurYawOffset - GoalYaw
	end

	function ENT:RandomMove()
		local X, Y = self:GetAimYaw(), self:GetAimPitch()
		self:Point(Y + math.Rand(-1, 1) * self.TurnSpeed / 8, X + math.Rand(-1, 1) * self.TurnSpeed / 4)
		self:ConsumeElectricity()
		-- todo, find a use for this
	end

	function ENT:ReturnToForward()
		local X, Y = self:GetAimYaw(), self:GetAimPitch()
		if (X == 0) and (Y == 0) then return end
		local TurnAmtPitch = math.Clamp(-Y, -self.TurnSpeed / 8, self.TurnSpeed / 8)
		local TurnAmtYaw = math.Clamp(X, -self.TurnSpeed / 4, self.TurnSpeed / 4)
		self:Point(Y + TurnAmtPitch, X - TurnAmtYaw)

		if (math.abs(TurnAmtPitch) > .5) or (math.abs(TurnAmtYaw) > .5) then
			sound.Play("snds_jack_gmod/ezsentry_turn.wav", self:GetPos(), 60, math.random(65, 80))
		end

		self:ConsumeElectricity()
	end

	function ENT:Turn(pitch, yaw)
		local X, Y = self:GetAimYaw(), self:GetAimPitch()
		local TurnAmtPitch = math.Clamp(pitch, -self.TurnSpeed / 8, self.TurnSpeed / 8)
		local TurnAmtYaw = math.Clamp(yaw, -self.TurnSpeed / 4, self.TurnSpeed / 4)
		self:Point(Y + TurnAmtPitch, X - TurnAmtYaw)

		if (math.abs(TurnAmtPitch) > .5) or (math.abs(TurnAmtYaw) > .5) then
			sound.Play("snds_jack_gmod/ezsentry_turn.wav", self:GetPos(), 60, math.random(65, 80))
		end

		self:ConsumeElectricity()
	end

	function ENT:Point(pitch, yaw)
		if pitch ~= nil then
			if pitch > 45 then
				pitch = 45
			end

			if pitch < -45 then
				pitch = -45
			end

			self:SetAimPitch(pitch)
		end

		if yaw ~= nil then
			if yaw > 60 then
				yaw = 60
			end

			if yaw < -60 then
				yaw = -60
			end

			self:SetAimYaw(yaw)
		end
	end
elseif(CLIENT)then
	function ENT:CustomInit()
		self.MachineGun=JMod.MakeModel(self,"models/jmod/ez/sentrygun.mdl")
		---
		self.CurAimPitch = 0
		self.CurAimYaw = 0
		self.CurPlateAng = 0
		self.CurGunOut = 0
		self.VisualRecoil = 0
		---
		self.LastAmmoType = ""
		self.RenderGun = true
	end

	function ENT:AddVisualRecoil(amt)
		self.VisualRecoil = math.Clamp(self.VisualRecoil + amt, 0, 5)
	end

	local GlowSprite = Material("sprites/mat_jack_basicglow")

	local GradeColors = {Vector(.3, .3, .3), Vector(.2, .2, .2), Vector(.2, .2, .2), Vector(.2, .2, .2), Vector(.2, .2, .2)}

	local AmmoBGs = {
		["Bullet"] = 0,
		["Pulse Rifle"] = 0,
		["API Bullet"] = 0,
		["Buckshot"] = 1,
		["HE Grenade"] = 2,
		["Pulse Laser"] = 3,
		["Super Soaker"] = 0
	}

	local FirstFrame = true

	function ENT:Draw()
		local SelfPos, SelfAng, AimPitch, AimYaw, State, Grade = self:GetPos(), self:GetAngles(), self:GetAimPitch(), self:GetAimYaw(), self:GetState(), self:GetGrade()
		local Up, Right, Forward, FT, AmmoType = SelfAng:Up(), SelfAng:Right(), SelfAng:Forward(), FrameTime(), self:GetAmmoType()
		local PlateAng, GunOut = 0, 0
		self.CurAimPitch = Lerp(FT * 3, self.CurAimPitch, AimPitch)
		self.CurAimYaw = Lerp(FT * 3, self.CurAimYaw, AimYaw)

		-- no snap-swing resets
		if math.abs(self.CurAimPitch - AimPitch) > 45 then
			self.CurAimPitch = AimPitch
		end

		if math.abs(self.CurAimYaw - AimYaw) > 90 then
			self.CurAimYaw = AimYaw
		end

		---
		local BasePos = SelfPos + Up * 32

		local Obscured = util.TraceLine({
			start = EyePos(),
			endpos = BasePos,
			filter = {LocalPlayer(), self},
			mask = MASK_OPAQUE
		}).Hit

		local Closeness = LocalPlayer():GetFOV() * EyePos():Distance(SelfPos)
		local DetailDraw = Closeness < 36000 -- cutoff point is 400 units when the fov is 90 degrees
		if (not DetailDraw) and Obscured then return end -- if player is far and sentry is obscured, draw nothing

		-- if obscured, at least disable details
		if Obscured then
			DetailDraw = false
		end

		-- look incomplete to indicate damage, save on gpu comp too
		if State == STATE_BROKEN then
			DetailDraw = false
		end

		---
		self:DrawModel()
		---
		if AmmoType ~= self.LastAmmoType then
			self.LastAmmoType = AmmoType
			self.MachineGun:SetBodygroup(0, AmmoBGs[AmmoType])
			if AmmoType == "Pulse Rifle" then
				self.RenderGun = false

				return
			else
				self.RenderGun = true
			end
		end
		---
		if self.RenderGun then
			local GunMaxy = self:GetBoneMatrix(2)
			local AimAngle = GunMaxy:GetAngles():GetCopy()
			AimAngle:RotateAroundAxis(AimAngle:Forward(), -90)
			AimAngle:RotateAroundAxis(AimAngle:Up(), -90)
			local AimUp, AimRight, AimForward = AimAngle:Up(), AimAngle:Right(), AimAngle:Forward()
			local GunPos = GunMaxy:GetTranslation()

			JMod.RenderModel(self.MachineGun, GunPos - AimForward * (6 + self.VisualRecoil) - AimRight * 1.5, AimAngle, Vector(0.75, 0.75, 0.75))
			CurPlateAng = 0
			CurGunOut = 0
		else
			if (State == STATE_ENGAGING) or (State == STATE_SEARCHING) then
				PlateAng = 20
				GunOut = 8
			else
				PlateAng = 0
				GunOut = 0
			end
		end
		self.VisualRecoil = math.Clamp(self.VisualRecoil - FT * 4, 0, 5)
		---
		self.CurPlateAng = Lerp(FT * 3, self.CurPlateAng, PlateAng)
		self.CurGunOut = Lerp(FT * 3, self.CurGunOut, GunOut)
		self:ManipulateBoneAngles(4, Angle(self.CurPlateAng, 0, 0))
		self:ManipulateBonePosition(3, Vector(0, 0, self.CurGunOut))
		---
		self:ManipulateBoneAngles(2, Angle(0, 0, -self.CurAimPitch))
		self:ManipulateBoneAngles(1, Angle(self.CurAimYaw, 0, 0))
		---

		if FirstFrame == true then
			FirstFrame = false
			return
		end
		if DetailDraw then
			---
			if (Closeness < 20000) and (State > 0) then
				local LeftRightMaxy = self:GetBoneMatrix(1)
				local DisplayAng = LeftRightMaxy:GetAngles():GetCopy()
				local DisplayPos = LeftRightMaxy:GetTranslation()
				DisplayAng:RotateAroundAxis(DisplayAng:Right(), 85)
				local Opacity = math.random(50, 150)
				cam.Start3D2D(DisplayPos + DisplayAng:Up() * 3 + DisplayAng:Forward() * 7 + DisplayAng:Right() * -7, DisplayAng, .075)
					surface.SetDrawColor(10, 10, 10, Opacity + 20)
					surface.DrawRect(-100, -140, 128, 128)
					JMod.StandardRankDisplay(Grade, -35, -75, 118, Opacity + 20)

					if AmmoType ~= "Pulse Laser" then
						local Ammo, AmmoName = self:GetAmmo(), "AMMO"
						local AmmoFrac = Ammo / self.MaxAmmo
						local R, G, B = JMod.GoodBadColor(AmmoFrac)
						if AmmoType == "Super Soaker" then
							AmmoName = "WATER"
						elseif AmmoType == "HE Grenade" then
							AmmoName = "MUNI"
						end
						draw.SimpleTextOutlined(AmmoName, "JMod-Display", -50, 0, Color(255, 255, 255, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
						draw.SimpleTextOutlined(tostring(Ammo), "JMod-Display", -50, 30, Color(R, G, B, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
					end

				cam.End3D2D()
				---
				DisplayAng:RotateAroundAxis(DisplayAng:Right(), 185)
				---
				cam.Start3D2D(DisplayPos + DisplayAng:Up() * 3 + DisplayAng:Forward() * -5 + DisplayAng:Right() * -12, DisplayAng, .075)
					draw.SimpleTextOutlined("POWER", "JMod-Display", 0, 0, Color(255, 255, 255, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
					local ElecFrac = self:GetElectricity() / self.MaxElectricity
					local R, G, B = JMod.GoodBadColor(ElecFrac)
					draw.SimpleTextOutlined(tostring(math.Round(ElecFrac * 100)) .. "%", "JMod-Display", 0, 30, Color(R, G, B, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))

					local CoolFrac = self:GetCoolant() / 100
					draw.SimpleTextOutlined("COOLANT", "JMod-Display", 0, 60, Color(255, 255, 255, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
					local R, G, B = JMod.GoodBadColor(CoolFrac)
					draw.SimpleTextOutlined(tostring(math.Round(CoolFrac * 100)) .. "%", "JMod-Display", 0, 90, Color(R, G, B, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
				cam.End3D2D()
			end
		end

		---
		local LightColor = nil

		if State == STATE_WATCHING then
			LightColor = Color(0, 255, 0)
		elseif State == STATE_SEARCHING then
			LightColor = Color(255, 255, 0)
		elseif State == STATE_ENGAGING then
			LightColor = Color(255, 0, 0)
		elseif State == STATE_WHINING or State == STATE_FALLEN then
			local Mul = math.sin(CurTime() * 5) / 2 + .5
			LightColor = Color(255 * Mul, 255 * Mul, 0)
		elseif State == STATE_OVERHEATED then
			local Mul = math.sin(CurTime() * 5) / 2 + .5
			LightColor = Color(255 * Mul, 255 * Mul, 0)
		end

		if LightColor and self:GetAttachment(4) ~= nil then
			render.SetMaterial(GlowSprite)
			render.DrawSprite(self:GetAttachment(4).Pos, 7, 7, LightColor)
		end
	end

	language.Add("ent_aboot_gmod_ezcombinesentry", "EZ Combine Sentry")
end
