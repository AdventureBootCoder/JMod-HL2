-- AdventureBoots 2023
AddCSLuaFile()
SWEP.PrintName = "EZ Welder"
SWEP.Author = "AdventureBoots"
SWEP.Purpose = ""
JMod.SetWepSelectIcon(SWEP, "entities/ent_jack_gmod_eztoolbox")
SWEP.Spawnable = false
SWEP.UseHands = true
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.EZdroppable = true
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/hl2ep2/welding_torch.mdl"
SWEP.BodyHolsterModel = "models/hl2ep2/welding_torch.mdl"
SWEP.BodyHolsterSlot = "hips"
SWEP.BodyHolsterAng = Angle(-100, 0, 100)
SWEP.BodyHolsterAngL = Angle(-70, -10, -30)
SWEP.BodyHolsterPos = Vector(0, -10, 8)
SWEP.BodyHolsterPosL = Vector(0, -10, -8)
SWEP.BodyHolsterScale = 1
SWEP.ViewModelFOV = 60
SWEP.Slot = 0
SWEP.SlotPos = 5
SWEP.InstantPickup = true -- Fort Fights compatibility
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.ShowWorldModel = false
SWEP.EZconsumes = {JMod.EZ_RESOURCE_TYPES.POWER, JMod.EZ_RESOURCE_TYPES.GAS}
SWEP.MaxElectricity = 100
SWEP.MaxGas = 100
---
SWEP.MaxRange = 150

--[[function SWEP:FrontSight()
	local Flicker = math.Rand(.5,1)
	if(self:GetElectricity() < self.MaxElectricity * .01) or (self:GetGas() < self.MaxGas * .01) then Flicker = math.Rand(0,.5) end
	surface.DrawCircle(0, 0, 80, Color(255,255,255,150*Flicker))
end--]]

SWEP.VElements = {
	["welder"] = {
		type = "Model",
		model = "models/hl2ep2/welding_torch.mdl",
		bone = "ValveBiped.Bip01_R_Hand",
		rel = "",
		pos = Vector(3.5, 2.5, 3),
		angle = Angle(0, -20, 180),
		size = Vector(1, 1, 1),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	},
	["pliers"] = {
		type = "Model",
		model = "models/props_c17/tools_pliers01a.mdl",
		bone = "ValveBiped.Bip01_L_Hand",
		rel = "",
		pos = Vector(2.8, 2.4, -2.5),
		angle = Angle(0, 180, 90),
		size = Vector(1, 1, 1),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	},
	--["sightty"]={ type="Quad", bone="ValveBiped.Bip01_R_Hand", rel="", pos=Vector(10, 3.7, -6), angle=Angle(0, -100, 90), size=0.025, draw_func=SWEP.FrontSight}
}

SWEP.WElements = {
	["pliers"] = {
		type = "Model",
		model = "models/props_c17/tools_pliers01a.mdl",
		bone = "ValveBiped.Bip01_L_Hand",
		rel = "",
		pos = Vector(4.675, 0, -1.558),
		angle = Angle(0, 0, 90),
		size = Vector(1, 1, 1),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	},
	["torch"] = {
		type = "Model",
		model = "models/props_silo/welding_torch.mdl",
		bone = "ValveBiped.Bip01_R_Hand",
		rel = "",
		pos = Vector(-0.5, 2.5, 0.9),
		angle = Angle(95, 0, -50),
		size = Vector(1, 1, 1),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	}
}

SWEP.LastSalvageAttempt = 0
SWEP.NextSwitch = 0

function SWEP:Initialize()
	self:SetHoldType("slam")
	self:SCKInitialize()
	self.NextIdle = 0
	self.Snd1 = CreateSound(self, "snds_jack_gmod/plasmaloop1.wav")
	self.Snd2 = CreateSound(self, "snds_jack_gmod/plasmaloop_reversed.wav")
	self:Deploy()

	self:SetGas(0)
	self:SetElectricity(0)
end

function SWEP:PreDrawViewModel(vm, wep, ply)
	vm:SetMaterial("engine/occlusionproxy") -- Hide that view model with hacky material
end

function SWEP:ViewModelDrawn()
	self:SCKViewModelDrawn()
	local Ply = LocalPlayer()
	local VM = self.Owner:GetViewModel()
	local Bone = VM:LookupBone("ValveBiped.Grenade_body")
	if not Bone then return end
	local Pos, Ang = VM:GetBonePosition(Bone)
	Ang:RotateAroundAxis(Ang:Up(), -10)
	Pos = Pos - Ang:Up()*5
	local Dir = self.Owner:GetAimVector()

	local ShootPos = self.Owner:GetShootPos() + self.Owner:GetRight() * 1 - self.Owner:GetUp()
	local Tracey = util.QuickTrace(ShootPos, Dir * 100, {self, Ply})
	if Tracey.Hit then
		local HitAngy = Dir:Angle()
		HitAngy:RotateAroundAxis(HitAngy:Right(), -90)
		cam.Start3D2D(Tracey.HitPos, HitAngy, 0.5 * Tracey.Fraction)
			surface.DrawCircle(0, 0, 10, 200, 200, 0, 200)
		cam.End3D2D()
	end

	if self:GetWelding() then
		local effectdata = EffectData()
		effectdata:SetOrigin(Pos)
		effectdata:SetAngles(Ang)
		effectdata:SetScale(0.5)
		util.Effect( "MuzzleEffect", effectdata, true, true )

		local WeldingMask = JMod.PlyHasArmorEff(Ply, "flashresistant")
		local dlight = DynamicLight(self:EntIndex())
		if(dlight)then
			dlight.MinLight=0
			dlight.Pos = Pos + Dir * 5
			dlight.r = 175
			dlight.g = 200
			dlight.b = 255
			dlight.Brightness = 6
			dlight.Size = 500
			dlight.Decay = 10000
			dlight.DieTime = CurTime() + .2
			dlight.Style = 0
		end--]]
		
		if WeldingMask then
			Ply.EZautoDarken = 1
		elseif math.random(1, 5) == 1 then
			local plooie = EffectData()
			plooie:SetOrigin(ShootPos)
			plooie:SetScale(.1)
			util.Effect("eff_jack_gmod_flashbang", plooie, true, true)
		end
	end
end

function SWEP:DrawWorldModel()
	self:SCKDrawWorldModel()
	if self:GetWelding() then
		local Ply = LocalPlayer()
		local Pos, Ang = self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		Pos = Pos + Ang:Right()*2 - Ang:Up()*1
		local Dir = self.Owner:GetAimVector()

		local WeldingMask = JMod.PlyHasArmorEff(Ply, "flashresistant")
		local dlight = DynamicLight(self:EntIndex())
		if(dlight)then
			dlight.MinLight=0
			dlight.Pos = Pos + Dir * 5
			dlight.r = 175
			dlight.g = 200
			dlight.b = 255
			dlight.Brightness = 6
			dlight.Size = 500
			dlight.Decay = 10000
			dlight.DieTime = CurTime() + .2
			dlight.Style = 0
		end--]]
		if (EyePos():Distance(Pos) < 400)  then 
			if WeldingMask then
				Ply.EZautoDarken = 400 / EyePos():Distance(Pos)
			elseif math.random(1, 5) == 1 then
				local plooie = EffectData()
				plooie:SetOrigin(Pos)
				plooie:SetScale(.1)
				util.Effect("eff_jack_gmod_flashbang", plooie, true, true)
			end
		end
	end
end

local Downness = 0

function SWEP:GetViewModelPosition(pos, ang)
	local FT = FrameTime()

	if (self.Owner:KeyDown(IN_SPEED)) or (self.Owner:KeyDown(IN_ZOOM)) then
		Downness = Lerp(FT * 2, Downness, 10)
	else
		Downness = Lerp(FT * 2, Downness, 0)
	end

	ang:RotateAroundAxis(ang:Right(), -Downness * 5)

	return pos, ang
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "Electricity")
	self:NetworkVar("Float", 1, "Gas")
	self:NetworkVar("Bool", 0, "Welding")
	self:NetworkVar("String", 0, "StatusMessage")
end

function SWEP:UpdateNextIdle()
	local vm = self.Owner:GetViewModel()
	self.NextIdle = CurTime() + vm:SequenceDuration()
end

function SWEP:GetEZsupplies(resourceType)
	local AvaliableResources = {
		[JMod.EZ_RESOURCE_TYPES.POWER] = math.floor(self:GetElectricity()),
		[JMod.EZ_RESOURCE_TYPES.GAS] = math.floor(self:GetGas())
	}
	if resourceType then
		if AvaliableResources[resourceType] and AvaliableResources[resourceType] > 0 then
			return AvaliableResources[resourceType]
		else
			return 
		end
	else
		return AvaliableResources
	end
end

function SWEP:SetEZsupplies(typ, amt, setter)
	if not SERVER then print("[JMOD] - You can't set EZ supplies on client") return end
	local ResourceSetMethod = self["Set"..JMod.EZ_RESOURCE_TYPE_METHODS[typ]]
	if ResourceSetMethod then
		ResourceSetMethod(self, amt)
	end
end

function SWEP:Msg(msg)
	self.Owner:PrintMessage(HUD_PRINTCENTER, msg)
end

function SWEP:WhomIlookinAt()
	local Filter = {self.Owner}

	for k, v in pairs(ents.FindByClass("npc_bullseye")) do
		table.insert(Filter, v)
	end

	local Tr = util.QuickTrace(self.Owner:GetShootPos(), self.Owner:GetAimVector() * 100, Filter)

	return Tr.Entity, Tr.HitPos, Tr.HitNormal
end

function SWEP:TryLoadResource(typ, amt)
	if amt < 1 then return 0 end
	local Accepted = 0

	for _, v in pairs(self.EZconsumes) do
		if typ == v then
			local CurAmt = self:GetEZsupplies(typ) or 0
			local Take = math.min(amt, self.MaxElectricity - CurAmt)
			
			if Take > 0 then
				self:SetEZsupplies(typ, CurAmt + Take)
				sound.Play("snds_jack_gmod/gas_load.ogg", self:GetPos(), 65, math.random(90, 110))
				Accepted = Take
			end
		end
	end

	return Accepted
end

--
function SWEP:OnDrop()
	local Kit = ents.Create("ent_aboot_gmod_ezwelder")
	Kit:SetPos(self:GetPos())
	Kit:SetAngles(self:GetAngles())
	Kit:Spawn()
	Kit:Activate()

	Kit:SetElectricity(self:GetElectricity())
	Kit:SetGas(self:GetGas())

	local Phys = Kit:GetPhysicsObject()

	if Phys then
		Phys:SetVelocity(self:GetPhysicsObject():GetVelocity() / 2)
	end

	self:Remove()
end

function SWEP:OnRemove()
	self:SCKHolster()

	if IsValid(self.Owner) and CLIENT and self.Owner:IsPlayer() then
		local vm = self.Owner:GetViewModel()

		if IsValid(vm) then
			vm:SetMaterial("")
		end
	end

	if IsValid(self.Snd1)then
		self.Snd1:Stop()
	end
	if IsValid(self.Snd2)then
		self.Snd2:Stop()
	end

	-- ADDED :
	if CLIENT then
		-- Removes V Models
		for k, v in pairs(self.VElements) do
			local model = v.modelEnt

			if v.type == "Model" and IsValid(model) then
				model:Remove()
			end
		end

		-- Removes W Models
		for k, v in pairs(self.WElements) do
			local model = v.modelEnt

			if v.type == "Model" and IsValid(model) then
				model:Remove()
			end
		end
	end
end

function SWEP:Holster(wep)
	-- Not calling OnRemove to keep the models
	self:SCKHolster()

	if IsValid(self.Owner) and CLIENT and self.Owner:IsPlayer() then
		local vm = self.Owner:GetViewModel()

		if IsValid(vm) then
			vm:SetMaterial("")
		end
	end

	return true
end

function SWEP:Deploy()
	if not IsValid(self.Owner) then return end
	local vm = self.Owner:GetViewModel()

	if IsValid(vm) and vm.LookupSequence then
		--vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
		vm:SendViewModelMatchingSequence(vm:LookupSequence("draw"))
		self:UpdateNextIdle()
		self:EmitSound("snds_jack_gmod/toolbox" .. math.random(1, 7) .. ".ogg", 65, math.random(90, 110))
	end

	if SERVER then
		JMod.Hint(self.Owner, "building")
	end

	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)

	return true
end

function SWEP:PrimaryAttack()
	if self.Owner:KeyDown(IN_SPEED) then return end
	self:SetNextPrimaryFire(CurTime() + .01)
	self:SetNextSecondaryFire(CurTime() + .01)
end

function SWEP:SecondaryAttack()
	if self.Owner:KeyDown(IN_SPEED) then return end
	self:SetNextPrimaryFire(CurTime() + .01)
	self:SetNextSecondaryFire(CurTime() + .01)
end

local WeldMats = {MAT_METAL, MAT_VENT, MAT_GRATE, MAT_TILE}

function SWEP:Think()
	local Time = CurTime()
	local Ply = self.Owner
	local vm = Ply:GetViewModel()
	local idletime = self.NextIdle

	if idletime > 0 and Time > idletime then
		--vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_idle_0" .. math.random(1, 2)))
		vm:SendViewModelMatchingSequence(vm:LookupSequence("idle01" .. math.random(1, 2)))
		self:UpdateNextIdle()
	end

	local Alt = JMod.IsAltUsing(Ply)

	if (Ply:KeyDown(IN_SPEED)) or (Ply:KeyDown(IN_ZOOM)) then
		self:SetHoldType("normal")
		self:SetWelding(false)
	else
		if (self:GetElectricity() <= 0) or (self:GetGas() <= 0) then
			self:Msg("You need power and/or gas")
			self:SetWelding(false)
		elseif Ply:KeyDown(IN_ATTACK2) and (self:GetNextSecondaryFire() <= Time) then
			local Ent, Pos, Norm = self:WhomIlookinAt()

			if IsValid(Ent) and (hook.Run("JModHL2_ShouldWeldFix", Ply, Ent, Pos)) then
				--if (SERVER) then
				local PowerConsume, GasConsume, Message = hook.Run("JModHL2_WeldFix", Ply, Ent, Pos)
				if PowerConsume and (PowerConsume > 0) then
					self:SetElectricity(math.max(self:GetElectricity() - PowerConsume, 0))
				end
				if GasConsume and (GasConsume > 0) then
					self:SetGas(math.max(self:GetGas() - GasConsume, 0))
				end
				if Message then
					self:SetStatusMessage(Message)
				end
				self:WeldEffect()
				self:SetWelding(true)
				self:SetHoldType("pistol")
			end
		elseif Ply:KeyDown(IN_ATTACK) and (self:GetNextPrimaryFire() <= Time) then
			self:SetHoldType("pistol")
			--
			if (SERVER) then
				local BaseShootPos = self.Owner:GetShootPos()
				local ShootPos = BaseShootPos + self.Owner:GetRight() * 4 - self.Owner:GetUp() * 1
				local AimVec = self.Owner:GetAimVector()
				local WeldTable = {}
				local WeldPos = nil
				local WeldNorm = nil
				for i = 1, 2 do
					local Tress=util.TraceLine({
						start = BaseShootPos, 
						endpos = ShootPos + AimVec * math.Rand(10, 100),
						filter = self.Owner,
						mask = MASK_SHOT
					})
					if(Tress.Hit) then
						if (table.HasValue(WeldMats, Tress.MatType) or JMod.IsDoor(Tress.Entity)) then
							WeldTable[i] = Tress.Entity
							WeldPos = Tress.HitPos
							WeldNorm = Tress.HitNormal
						elseif IsValid(Tress.Entity) then
							self:WeldBurn(Tress.Entity, Tress.HitPos, AimVec * 100)
						end
						self:WeldEffect(Tress)
					else
						--self:SetWelding(false)
						--[[local FireVec = (self:GetVelocity() / 1000 + self.Owner:GetAimVector()):GetNormalized()
						local Flame = ents.Create("ent_jack_gmod_eznapalm")
						Flame:SetPos(self.Owner:GetShootPos() + FireVec)
						Flame:SetAngles(FireVec:Angle())
						Flame:SetOwner(JMod.GetEZowner(self))
						JMod.SetEZowner(Flame, self.EZowner or self)
						Flame.SpeedMul = 5
						Flame.Creator = self.Owner
						Flame.HighVisuals = math.random(1, 5) == 1
						Flame:Spawn()
						Flame:Activate()--]]
					end
				end
				self:SetElectricity(math.max(self:GetElectricity() - .05, 0))
				self:SetGas(math.max(self:GetGas() - .02, 0))
				self:SetWelding(true)

				if(math.random(1, 3) == 2)then
					local EntOne = WeldTable[1]
					local EntTwo = WeldTable[2]
					if Alt then --Deweld
						if IsValid(EntOne) and IsValid(EntOne:GetPhysicsObject()) then 
							MassOne = EntOne:GetPhysicsObject():GetMass()
							if math.random(0, MassOne) >= (MassOne * 0.9) then
								if JMod.IsDoor(EntOne) then EntOne:Fire("unlock", "", 0) end
								local ConTable = constraint.FindConstraint(EntOne, "Weld")
								if ConTable and ConTable.Constraint then
									SafeRemoveEntity(ConTable.Constraint)
								end
							end
						end
						if IsValid(EntTwo) and IsValid(EntTwo:GetPhysicsObject()) then 
							MassTwo = EntTwo:GetPhysicsObject():GetMass()
							if math.random(0, MassTwo) >= (MassTwo * 0.9) then 
								if JMod.IsDoor(EntTwo) then EntOne:Fire("unlock", "", 0) end
								local ConTable = constraint.FindConstraint(EntTwo, "Weld")
								if ConTable and ConTable.Constraint then
									SafeRemoveEntity(ConTable.Constraint)
								end
							end
						end
					else --Weld
						if IsValid(EntOne) and JMod.IsDoor(EntOne)then EntOne:Fire("lock", "", 0) end
						if IsValid(EntTwo) and JMod.IsDoor(EntTwo)then EntTwo:Fire("lock", "", 0) end
						if((IsValid(EntOne) or (EntOne and EntOne:IsWorld())) and (IsValid(EntTwo) or (EntOne and EntOne:IsWorld())))then
							if (EntOne ~= EntTwo) then
								local Strength = math.random(1, 20000)
								Strength = Strength + math.random(1, 20000)
								Strength = Strength + math.random(1, 20000)
								Strength = Strength + math.random(1, 20000)
								Strength = Strength + math.random(1, 20000)
								constraint.Weld(EntOne, EntTwo, 0, 0, Strength, false)
								local effectdata = EffectData()
								effectdata:SetOrigin(WeldPos)
								effectdata:SetNormal(WeldNorm)
								effectdata:SetMagnitude(8) --amount and shoot hardness
								effectdata:SetScale(2) --length of strands
								effectdata:SetRadius(2) --thickness of strands
								util.Effect("Sparks",effectdata,true,true)
							end
						end
					end
					local WeldingMask = JMod.PlyHasArmorEff(Ply, "flashresistant")
					if not(WeldingMask) and (math.random(1, 5) == 1) then
						self:WeldBurn(Ply, Ply:GetShootPos())
					end
				end

				if(math.random(1, 2) == 2)then
					if(self.Owner:WaterLevel()==3)then
						local Blamo=EffectData()
						Blamo:SetOrigin(ShootPos+AimVec*30)
						Blamo:SetStart(AimVec)
						util.Effect("eff_jack_plasmajetwater",Blamo,true,true)
					end
				end
			end
		else
			self:SetHoldType("slam")
			self:SetWelding(false)
			self:SetStatusMessage("")
		end
	end
	if (SERVER) then
		--jprint(self.WasWelding)
		if self:GetWelding() and not(self.WasWelding) then
			sound.Play("snd_jack_plasmapop.ogg", self.Owner:GetPos(), 75, math.random(95, 110), .5)
			timer.Simple(0.1, function()
				if IsValid(self) and (self:GetWelding()) then
					self.Snd1:Play()
					self.Snd2:Play()
				end
			end)
			self.WasWelding = true
		elseif not(self:GetWelding()) and self.WasWelding then
			self.Snd1:Stop()
			self.Snd2:Stop()
			--sound.Play("snd_jack_plasmapop.ogg", self.Owner:GetPos(), 75, math.random(95, 110), .5)
			self.WasWelding = false
		end
	end
end

function SWEP:WeldBurn(target, pos, dir)
	local Burrn = DamageInfo()
	Burrn:SetDamage(math.Rand(0.2, 0.5))
	if pos then
		Burrn:SetDamagePosition(pos)
	end
	if dir then
		Burrn:SetDamageForce(dir)
	end
	Burrn:SetAttacker(self.Owner)
	Burrn:SetInflictor(self)
	if(target:IsOnFire())then
		Burrn:SetDamageType(DMG_GENERIC)
	elseif(math.random(1, 9) == 5)then
		Burrn:SetDamageType(DMG_BURN)
	else
		Burrn:SetDamageType(DMG_DIRECT)
	end
	target:TakeDamageInfo(Burrn)
end

function SWEP:WeldEffect(Tr)
	local ShootPos, AimVec = self.Owner:GetShootPos(), self.Owner:GetAimVector()
	if not istable(Tr) then
		Tr = util.QuickTrace(ShootPos, AimVec * 100, self.Owner)
	end
	local Pos, Norm = Tr.HitPos, Tr.HitNormal

	local effectdata = EffectData()
	effectdata:SetOrigin(Pos)
	effectdata:SetNormal(Norm)
	util.Effect("stunstickimpact", effectdata, true, true )

	if not(self.NextBurnSoundEmitTime)then self.NextBurnSoundEmitTime=CurTime() end
	if(self.NextBurnSoundEmitTime < CurTime())then
		self.NextBurnSoundEmitTime = CurTime()+math.random(.5, 1)--.075
		--sound.Play("snd_jack_heavylaserburn.ogg", Tr.HitPos, 65, math.random(90, 110))
		self.Snd1:ChangePitch(math.random(90, 110))
		self.Snd2:ChangePitch(math.random(90, 110))
	end
	
	if(math.random(1,2)==1)then
		local Poof=EffectData()
		Poof:SetOrigin(Tr.HitPos)
		Poof:SetScale(2)
		Poof:SetNormal(Tr.HitNormal)
		if((Tr.MatType==MAT_CONCRETE)or(Tr.MatType==MAT_METAL)or(Tr.MatType==MAT_COMPUTER)or(Tr.MatType==MAT_GRATE)or(Tr.MatType==MAT_TILE)or(Tr.MatType==MAT_GLASS)or(Tr.MatType==MAT_SAND))then
			Poof:SetStart(Tr.Entity:GetVelocity())
			Poof:SetNormal(Tr.HitNormal)
			util.Effect("eff_jack_tinymelt",Poof,true,true)
			Poof:SetScale(.07)
			util.Effect("eff_jack_fadingmelt",Poof,true,true)
		else
			util.Effect("eff_jack_tinyburn",Poof,true,true)
		end
	end
end

local function GetLVS(self)
	local ply = self:GetOwner()

	if not IsValid( ply ) then return NULL end

	local ent = ply:GetEyeTrace().Entity

	if not IsValid( ent ) then return NULL end

	if ent.LVS then return ent end

	if not ent.GetBase then return NULL end

	ent = ent:GetBase()

	if IsValid( ent ) and ent.LVS then return ent end

	return NULL
end

local function FindClosestArmor(self)
	local lvsEnt = GetLVS(self)

	if not IsValid( lvsEnt ) then return NULL end

	local ply = self:GetOwner()

	if ply:InVehicle() then return end

	local ShootPos = ply:GetShootPos()
	local AimVector = ply:GetAimVector()

	local ClosestDist = self.MaxRange
	local ClosestPiece = NULL

	for _, entity in pairs( lvsEnt:GetChildren() ) do
		if entity:GetClass() ~= "lvs_wheeldrive_armor" then continue end

		local boxOrigin = entity:GetPos()
		local boxAngles = entity:GetAngles()
		local boxMins = entity:GetMins()
		local boxMaxs = entity:GetMaxs()

		local HitPos, _, _ = util.IntersectRayWithOBB( ShootPos, AimVector * 1000, boxOrigin, boxAngles, boxMins, boxMaxs )

		if isvector( HitPos ) then
			local Dist = (ShootPos - HitPos):Length()

			if Dist < ClosestDist then
				ClosestDist = Dist
				ClosestPiece = entity
			end
		end
	end

	return ClosestPiece
end

hook.Add("JModHL2_ShouldWeldFix", "JMODHL2_LVS_CAR_REPAIR", function(ply, target, pos) 
	local Welder = ply:GetActiveWeapon()
	local ArmorMode = false
	local Target = GetLVS(Welder)

	if IsValid(ply) and ply:KeyDown(IN_RELOAD) then
		Target = FindClosestArmor(Welder)
		ArmorMode = true
	end

	
	if IsValid(Target) then
		local HP = Target:GetHP()
		local MaxHP = Target:GetMaxHP()
		--jprint(Target, HP)
		if not ArmorMode then
			ply:PrintMessage(HUD_PRINTCENTER, "Hold R for Armor Mode")
		end

		return (HP < MaxHP)
	end
end)

hook.Add("JModHL2_WeldFix", "JMODHL2_LVS_CAR_REPAIR", function(ply, target, pos) 
	if not IsValid(ply) then return end
	local Welder = ply:GetActiveWeapon()
	local ArmorMode = false
	local Target = GetLVS(Welder)

	if ply:KeyDown(IN_RELOAD) then
		Target = FindClosestArmor(Welder)
		ArmorMode = true
	end

	if not IsValid(Target) then
		local ent = ply:GetEyeTrace().Entity
	
		if IsValid( ent ) and (ent:GetPos() - ply:GetShootPos()):Length() < Welder.MaxRange and ent:GetClass() == "lvs_item_mine" then
			if SERVER then timer.Simple(0, function() if not IsValid( ent ) then return 0.02, 0.01 end ent:Detonate() end ) end
		end
		return 0, 0
	end
	
	local HP = Target:GetHP()
	local MaxHP = Target:GetMaxHP()
	
	if CLIENT then return end
	
	Target:SetHP( math.min(math.Round(HP + 3), MaxHP ) )
	
	if not ArmorMode then return 0.03, 0.02, "Frame: "..HP.."/"..MaxHP end
	
	if Target:GetDestroyed() then Target:SetDestroyed( false ) end
	
	Target:OnRepaired()
	return 0.03, 0.02, "Armor: "..HP.."/"..MaxHP
end)


local LastProg = 0
local InfoTextColor, ManualTextColor, OutlineColor =  Color(255, 255, 255, 100), Color(255, 255, 255, 30), Color(0, 0, 0, 10)

function SWEP:DrawHUD()
	if GetConVar("cl_drawhud"):GetBool() == false then return end
	local Ply = self.Owner
	if Ply:ShouldDrawLocalPlayer() then return end
	local W, H = ScrW(), ScrH()

	draw.SimpleTextOutlined("Power: "..math.floor(self:GetElectricity()), "Trebuchet24", W * .1, H * .5, InfoTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, 50))
	draw.SimpleTextOutlined("Gas: "..math.floor(self:GetGas()), "Trebuchet24", W * .1, H * .5 + 30, InfoTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, 50))

	draw.SimpleTextOutlined("LMB: weld", "Trebuchet24", W * .4, H * .7, ManualTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, OutlineColor)
	draw.SimpleTextOutlined("ALT+LMB: de-weld", "Trebuchet24", W * .4, H * .7 + 20, ManualTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, OutlineColor)
	draw.SimpleTextOutlined("RMB: repair", "Trebuchet24", W * .4, H * .7 + 40, ManualTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, OutlineColor)
	draw.SimpleTextOutlined("Backspace: drop kit", "Trebuchet24", W * .4, H * .7 + 60, ManualTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, OutlineColor)

	if self:GetStatusMessage() then
		draw.SimpleTextOutlined(self:GetStatusMessage(), "Trebuchet24", W * .5, H * .4, InfoTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, OutlineColor)
	end

	local Tr = util.QuickTrace(Ply:EyePos(), Ply:GetAimVector() * 80, {Ply})
	local Ent = Tr.Entity
	if IsValid(Ent) and Ent.IsJackyEZmachine then
		draw.SimpleTextOutlined((Ent.PrintName and tostring(Ent.PrintName)) or tostring(Ent), "Trebuchet24", W * .7, H * .5, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, 50))
		if Ent.MaxDurability then
		draw.SimpleTextOutlined("Durability: "..tostring(math.Round(Ent:GetNW2Float("EZdurability", 0)) + Ent.MaxDurability * 2).."/"..Ent.MaxDurability*3, "Trebuchet24", W * .7, H * .5 + 30, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, 50))
		end
		if Ent.GetGrade and Ent:GetGrade() > 0 then
		draw.SimpleTextOutlined("Grade: "..tostring(Ent:GetGrade()), "Trebuchet24", W * .7, H * .5 + 60, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, 50))
		end
	end

	--surface.DrawCircle(W * .5, H * .5, 100, 255, 255, 255, 200)
end

----------------- sck -------------------
function SWEP:SCKHolster()
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()

		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
end

function SWEP:SCKInitialize()
	if CLIENT then
		-- Create a new table for every weapon instance
		self.VElements = table.FullCopy(self.VElements)
		self.WElements = table.FullCopy(self.WElements)
		self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods)
		self:CreateModels(self.VElements) -- create viewmodels
		self:CreateModels(self.WElements) -- create worldmodels

		-- init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()

			if IsValid(vm) then
				self:ResetBonePositions(vm)
			end

			-- Init viewmodel visibility
			if self.ShowViewModel == nil or self.ShowViewModel then
				if IsValid(vm) then
					vm:SetColor(Color(255, 255, 255, 255))
				end
			else
				-- we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
				vm:SetColor(Color(255, 255, 255, 1))
				-- ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
				-- however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
				vm:SetMaterial("Debug/hsv")
			end
		end
	end
end

if CLIENT then
	SWEP.vRenderOrder = nil

	function SWEP:SCKViewModelDrawn()
		local vm = self.Owner:GetViewModel()
		if not IsValid(vm) then return end
		if not self.VElements then return end
		self:UpdateBonePositions(vm)

		if not self.vRenderOrder then
			-- we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs(self.VElements) do
				if v.type == "Model" then
					table.insert(self.vRenderOrder, 1, k)
				elseif v.type == "Sprite" or v.type == "Quad" then
					table.insert(self.vRenderOrder, k)
				end
			end
		end

		for k, name in ipairs(self.vRenderOrder) do
			local v = self.VElements[name]

			if not v then
				self.vRenderOrder = nil
				break
			end

			if v.hide then continue end
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			if not v.bone then continue end
			local pos, ang = self:GetBoneOrientation(self.VElements, v, vm)
			if not pos then continue end

			if v.type == "Model" and IsValid(model) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix("RenderMultiply", matrix)

				if v.material == "" then
					model:SetMaterial("")
				elseif model:GetMaterial() ~= v.material then
					model:SetMaterial(v.material)
				end

				if v.skin and v.skin ~= model:GetSkin() then
					model:SetSkin(v.skin)
				end

				if v.bodygroup then
					for k, v in pairs(v.bodygroup) do
						if model:GetBodygroup(k) ~= v then
							model:SetBodygroup(k, v)
						end
					end
				end

				if v.surpresslightning then
					render.SuppressEngineLighting(true)
				end

				render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
				render.SetBlend(v.color.a / 255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)

				if v.surpresslightning then
					render.SuppressEngineLighting(false)
				end
			elseif v.type == "Sprite" and sprite then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
			elseif v.type == "Quad" and v.draw_func then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func(self)
				cam.End3D2D()
			end
		end
	end

	SWEP.wRenderOrder = nil

	function SWEP:SCKDrawWorldModel()
		if self.ShowWorldModel == nil or self.ShowWorldModel then
			self:DrawModel()
		end

		if not self.WElements then return end

		if not self.wRenderOrder then
			self.wRenderOrder = {}

			for k, v in pairs(self.WElements) do
				if v.type == "Model" then
					table.insert(self.wRenderOrder, 1, k)
				elseif v.type == "Sprite" or v.type == "Quad" then
					table.insert(self.wRenderOrder, k)
				end
			end
		end

		local bone_ent

		if IsValid(self.Owner) then
			bone_ent = self.Owner
		else
			-- when the weapon is dropped
			bone_ent = self
		end

		for k, name in pairs(self.wRenderOrder) do
			local v = self.WElements[name]

			if not v then
				self.wRenderOrder = nil
				break
			end

			if v.hide then continue end
			local pos, ang

			if v.bone then
				pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent)
			else
				pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand")
			end

			if not pos then continue end
			local model = v.modelEnt
			local sprite = v.spriteMaterial

			if v.type == "Model" and IsValid(model) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix("RenderMultiply", matrix)

				if v.material == "" then
					model:SetMaterial("")
				elseif model:GetMaterial() ~= v.material then
					model:SetMaterial(v.material)
				end

				if v.skin and v.skin ~= model:GetSkin() then
					model:SetSkin(v.skin)
				end

				if v.bodygroup then
					for k, v in pairs(v.bodygroup) do
						if model:GetBodygroup(k) ~= v then
							model:SetBodygroup(k, v)
						end
					end
				end

				if v.surpresslightning then
					render.SuppressEngineLighting(true)
				end

				render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
				render.SetBlend(v.color.a / 255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)

				if v.surpresslightning then
					render.SuppressEngineLighting(false)
				end
			elseif v.type == "Sprite" and sprite then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
			elseif v.type == "Quad" and v.draw_func then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func(self)
				cam.End3D2D()
			end
		end
	end

	function SWEP:GetBoneOrientation(basetab, tab, ent, bone_override)
		local bone, pos, ang

		if tab.rel and tab.rel ~= "" then
			local v = basetab[tab.rel]
			if not v then return end
			-- Technically, if there exists an element with the same name as a bone
			-- you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation(basetab, v, ent)
			if not pos then return end
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
		else
			bone = ent:LookupBone(bone_override or tab.bone)
			if not bone then return end
			pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
			local m = ent:GetBoneMatrix(bone)

			if m then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end

			if IsValid(self.Owner) and self.Owner:IsPlayer() and ent == self.Owner:GetViewModel() and self.ViewModelFlip then
				ang.r = -ang.r -- Fixes mirrored models
			end
		end

		return pos, ang
	end

	function SWEP:CreateModels(tab)
		if not tab then return end

		-- Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs(tab) do
			if v.type == "Model" and v.model and v.model ~= "" and (not IsValid(v.modelEnt) or v.createdModel ~= v.model) and string.find(v.model, ".mdl") and file.Exists(v.model, "GAME") then
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)

				if IsValid(v.modelEnt) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
			elseif v.type == "Sprite" and v.sprite and v.sprite ~= "" and (not v.spriteMaterial or v.createdSprite ~= v.sprite) and file.Exists("materials/" .. v.sprite .. ".vmt", "GAME") then
				local name = v.sprite .. "-"

				local params = {
					["$basetexture"] = v.sprite
				}

				-- make sure we create a unique name based on the selected options
				local tocheck = {"nocull", "additive", "vertexalpha", "vertexcolor", "ignorez"}

				for i, j in pairs(tocheck) do
					if v[j] then
						params["$" .. j] = 1
						name = name .. "1"
					else
						name = name .. "0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name, "UnlitGeneric", params)
			end
		end
	end

	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		if self.ViewModelBoneMods then
			if not vm:GetBoneCount() then return end
			local loopthrough = self.ViewModelBoneMods

			if not hasGarryFixedBoneScalingYet then
				allbones = {}

				for i = 0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)

					if self.ViewModelBoneMods[bonename] then
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = {
							scale = Vector(1, 1, 1),
							pos = Vector(0, 0, 0),
							angle = Angle(0, 0, 0)
						}
					end
				end

				loopthrough = allbones
			end

			for k, v in pairs(loopthrough) do
				local bone = vm:LookupBone(k)
				if not bone then continue end
				local s = Vector(v.scale.x, v.scale.y, v.scale.z)
				local p = Vector(v.pos.x, v.pos.y, v.pos.z)
				local ms = Vector(1, 1, 1)

				if not hasGarryFixedBoneScalingYet then
					local cur = vm:GetBoneParent(bone)

					while cur >= 0 do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end

				if vm:GetManipulateBoneScale(bone) ~= s then
					vm:ManipulateBoneScale(bone, s)
				end

				if vm:GetManipulateBoneAngles(bone) ~= v.angle then
					vm:ManipulateBoneAngles(bone, v.angle)
				end

				if vm:GetManipulateBonePosition(bone) ~= p then
					vm:ManipulateBonePosition(bone, p)
				end
			end
		else
			self:ResetBonePositions(vm)
		end
	end

	function SWEP:ResetBonePositions(vm)
		if not vm:GetBoneCount() then return end

		for i = 0, vm:GetBoneCount() do
			vm:ManipulateBoneScale(i, Vector(1, 1, 1))
			vm:ManipulateBoneAngles(i, Angle(0, 0, 0))
			vm:ManipulateBonePosition(i, Vector(0, 0, 0))
		end
	end
end
