﻿-- Jackarunda 2021
AddCSLuaFile()
SWEP.PrintName = "EZ OSINC"
SWEP.Author = "Jackarunda, AdventureBoots"
SWEP.Purpose = ""
JMod.SetWepSelectIcon(SWEP, "entities/ent_aboot_gmod_ezosinc")
SWEP.Spawnable = false
SWEP.UseHands = true
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.EZdroppable = true
SWEP.ViewModel	= "models/weapons/c_physcannon.mdl"
SWEP.WorldModel	= "models/aboot/weapons/w_nc1.mdl"
SWEP.BodyHolsterModel = "models/aboot/weapons/w_nc1.mdl"
SWEP.BodyHolsterSlot = "back"
SWEP.BodyHolsterAng = Angle(-70, 0, 200)
SWEP.BodyHolsterAngL = Angle(-70, 0, 200)
SWEP.BodyHolsterPos = Vector(0, -15, 10)
SWEP.BodyHolsterPosL = Vector(0, -15, 10)
SWEP.BodyHolsterScale = 1
SWEP.ViewModelFOV = 55
SWEP.Slot = 4
SWEP.SlotPos = 3
SWEP.InstantPickup = true -- Fort Fights compatibility
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.ShowWorldModel = true

SWEP.EZconsumes = {JMod.EZ_RESOURCE_TYPES.FUEL}
SWEP.MaxFuel = 50

SWEP.VElements = {
	["OSINC"] = {
		type = "Model",
		model = "models/aboot/weapons/w_nc1.mdl",
		bone = "ValveBiped.Bip01_L_Hand",
		rel = "",
		pos = Vector(3.301, -3.307, -4.094), 
		angle = Angle(90, 0, 90), 
		size = Vector(1, 1, 1),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	}
}

SWEP.WElements = {
	--[[["osinc"] = {
		type = "Model",
		model = "models/props_c17/tools_wrench01a.mdl",
		bone = "ValveBiped.Bip01_R_Hand",
		rel = "",
		pos = Vector(3.5, 1.5, 0),
		angle = Angle(0, 90, -90),
		size = Vector(1, 1, 1),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	},--]]
}

SWEP.ViewModelBoneMods = {
	["Base"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-3.385, 4.9, -1.816), angle = Angle(23, 27, 2) },
	["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -14.464, 0) },
	["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -40.999, 0) },
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -51.067, 0) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-60.876, -54.481, -135.301) },
	["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -19.316, 0) }
}

SWEP.LastSalvageAttempt = 0
SWEP.NextSwitch = 0

SWEP.NextExtinguish = 0
SWEP.NextIgniteTry = 0
SWEP.EffectiveRange = 300

local STATE_NOTHIN, STATE_IGNITIN, STATE_FLAMIN = 0, 1, 2

function SWEP:Initialize()
	self:SetHoldType("shotgun")
	self:SCKInitialize()
	self.NextIdle = 0
	self:Deploy()

	self:SetFuel(0)
end

function SWEP:PreDrawViewModel(vm, wep, ply)
	vm:SetMaterial("engine/occlusionproxy") -- Hide that view model with hacky material
end

local GlowSprite = Material("mat_jack_gmod_glowsprite")

function SWEP:ViewModelDrawn()
	self:SCKViewModelDrawn()

	if self:GetFuel() <= 0 then return end
	local State = self:GetState()
	render.SetMaterial(GlowSprite)
	local FlamePos, FlameAng = self:GetNozzle()

	if not (FlamePos and FlameAng) then return end
	if (State == STATE_FLAMIN) then
		local Dir = FlameAng:Forward()
		local Pos = FlamePos + FlameAng:Up()--self.Owner:GetShootPos() + self.Owner:GetRight() * 18 - self.Owner:GetUp() * 18
		for i = 1, 10 do
			local Inv = 10 - i
			render.DrawSprite(Pos + Dir * (i * 10 + math.random(0, 10)), 2 * Inv, 2 * Inv, Color(255, 150, 100, 255))
		end
		local dlight = DynamicLight(self:EntIndex())
		if dlight then
			dlight.pos = Pos + Dir * 50
			dlight.r = 255
			dlight.g = 150
			dlight.b = 100
			dlight.brightness = 4
			dlight.Decay = 200
			dlight.Size = 400
			dlight.DieTime = CurTime() + .5
		end
	else
		local Mult = (State == STATE_IGNITIN) and 2 or 1
		local FireAng = FlameAng:GetCopy()
		FireAng:RotateAroundAxis(FireAng:Up(), 45)
		local Dir = FireAng:Forward()
		local Pos = FlamePos + Dir * 1
		for i = 1, 5 do
			local Inv = (5 - i)
			render.DrawSprite(Pos + Dir * (i * Mult * .1 + math.random(0, 0.1)), Mult * Inv, Mult * Inv, Color(255, 150, 100, 255))
		end
	end
end

function SWEP:DrawWorldModel()
	self:SCKDrawWorldModel()

	if self:GetFuel() <= 0 then return end
	local State = self:GetState()
	render.SetMaterial(GlowSprite)
	local Dir = self:GetAttachment(1).Ang:Forward()
	local Pos = self:GetAttachment(1).Pos

	if (State == STATE_FLAMIN) then
		for i = 1, 10 do
			local Inv = 10 - i
			render.DrawSprite(Pos + Dir * (i * 2 + math.random(0, 20)), 2 * Inv, 2 * Inv, Color(255, 150, 100, 255))
		end
		local dlight = DynamicLight(self:EntIndex())
		if dlight then
			dlight.pos = Pos + Dir * 1
			dlight.r = 255
			dlight.g = 150
			dlight.b = 100
			dlight.brightness = 4
			dlight.Decay = 200
			dlight.Size = 400
			dlight.DieTime = CurTime() + .5
		end
	else
		local Mult = (State == STATE_IGNITIN) and 2 or 1
		local FireAng = self:GetAttachment(1).Ang
		FireAng:RotateAroundAxis(FireAng:Up(), 35)
		Dir = FireAng:Forward()
		Pos = Pos + FireAng:Right()
		for i = 1, 5 do
			local Inv = 5 - i
			render.DrawSprite(Pos + Dir * (i * Mult + math.random(0, 0.1)), Mult * Inv, Mult * Inv, Color(255, 150, 100, 255))
		end
	end
end

local Downness = 0
local Backness = 0

function SWEP:GetViewModelPosition(pos, ang)
	local FT = FrameTime()

	if not IsValid(self.Owner) then return pos, ang end
	if (self.Owner:KeyDown(IN_SPEED)) or (self.Owner:KeyDown(IN_ZOOM)) then
		Downness = Lerp(FT * 2, Downness, 10)
	else
		Downness = Lerp(FT * 2, Downness, 0)
	end

	local Flamin = (self:GetState() == STATE_FLAMIN)

	if (Flamin) then
		Backness = Lerp(FT * 2, Backness, 3)
	else
		Backness = Lerp(FT * 2, Backness, 0)
	end

	ang:RotateAroundAxis(ang:Right(), -Downness * 5)
	pos = pos - ang:Forward() * Backness
	if (Flamin) then pos = pos + VectorRand() * .01 end

	return pos, ang
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "Fuel")
	self:NetworkVar("Int", 0, "State")
end

function SWEP:UpdateNextIdle()
	if not(self.Owner:IsPlayer()) then return end
	local vm = self.Owner:GetViewModel()
	self.NextIdle = CurTime() + vm:SequenceDuration()
end

function SWEP:GetEZsupplies(resourceType)
	local AvaliableResources = {
		[JMod.EZ_RESOURCE_TYPES.FUEL] = self:GetFuel()
	}
	if resourceType then
		if AvaliableResources[resourceType] and AvaliableResources[resourceType] > 0 then
			return AvaliableResources[resourceType]
		else
			return nil
		end
	else
		return AvaliableResources
	end
end

function SWEP:SetEZsupplies(typ, amt, setter)
	if not SERVER then  return end
	local ResourceSetMethod = self["Set"..JMod.EZ_RESOURCE_TYPE_METHODS[typ]]
	if ResourceSetMethod then
		ResourceSetMethod(self, amt)
	end
end

function SWEP:Cease()
	self:SetState(STATE_NOTHIN)
	if (self.SoundLoop) then self.SoundLoop:Stop() end
end

function SWEP:GetNozzle()
	if not(IsValid(self.Owner) and self.Owner:IsPlayer()) then return end
	local AimVec = self.Owner:GetAimVector()
	local FirePos, FireAng
	
	if CLIENT then
		local NozzleAtt = self.VElements["OSINC"].modelEnt:GetAttachment(1)
		if NozzleAtt then
			FirePos, FireAng = NozzleAtt.Pos + NozzleAtt.Ang:Right() * 2, NozzleAtt.Ang
		end
	elseif SERVER then
		FireAng = AimVec:Angle()
		FireAng:RotateAroundAxis(FireAng:Right(), 5)

		local NozzleAtt = self:GetAttachment(1)
		FirePos = NozzleAtt.Pos + FireAng:Right() * -30 + FireAng:Up() * 26 + FireAng:Forward() * 70
	end

	if SERVER or not(FirePos and FireAng) then
		--FireAng = (AimVec + VectorRand(-.1, .1)):GetNormalized():Angle()
		--FirePos = self.Owner:GetShootPos() + (FireAng:Forward() * 15 + FireAng:Right() * 4 + FireAng:Up() * -4)
	end

	return FirePos, FireAng, AimVec
end

function SWEP:PrimaryAttack()
	local Time = CurTime()
	local NextAttackTime = .05
	self:SetNextPrimaryFire(Time + NextAttackTime)

	if SERVER then
		local Fuel, State = self:GetFuel(), self:GetState()
		local HasFuel = (Fuel > 0)

		if not(HasFuel) then
			self:Cease()
			self:Msg("Out of fuel!\nPress Alt+Use on resource container to refill.")
		else
			local FirePos, FireAng, AimVec = self:GetNozzle()
			if ((State == STATE_NOTHIN) or (State == STATE_IGNITIN)) and not(self.Owner:IsPlayer() and self.Owner:IsSprinting()) then
				self:SetState(STATE_FLAMIN)
				if self.SoundLoop then self.SoundLoop:Stop() end
				self.SoundLoop = CreateSound(self, "snds_jack_gmod/flamethrower_loop.wav")
				self.SoundLoop:SetSoundLevel(75)
				self.SoundLoop:Play()
			elseif (State == STATE_FLAMIN) then
				self.Owner:MuzzleFlash()
				local Foof = EffectData()
				Foof:SetOrigin(FirePos)
				Foof:SetNormal(FireAng:Forward())
				Foof:SetScale(2)
				Foof:SetStart(FireAng:Forward() * 800)
				util.Effect("eff_jack_gmod_fire", Foof, true, true)
			end

			if (State == STATE_FLAMIN) and (math.Rand(0, 1) > .3) then
				if self.Owner:IsPlayer() then self.Owner:LagCompensation(true) end
				self:Pawnch()
				local Spread = 20
				for i = 1, 10 do
					local RandAng = AngleRand(-Spread, Spread)
					local Tracer = util.QuickTrace(self.Owner:GetShootPos(), self.Owner:GetAimVector() * self.EffectiveRange + RandAng:Forward() * Spread * 2, self.Owner)
					for _, Ent in ipairs(ents.FindInSphere(Tracer.HitPos, 20)) do
						if Ent ~= self.Owner then
							local DmgInfo = DamageInfo()
							DmgInfo:SetAttacker(self.Owner)
							DmgInfo:SetInflictor(self)
							DmgInfo:SetDamage(math.random(1, 5))
							DmgInfo:SetDamageType(DMG_BURN)
							Ent:TakeDamageInfo(DmgInfo)
							if (math.random(1, 5) == 1) then Ent:Ignite(math.random(5, 10), 50) end
						end
					end
					
					if math.random(1, 20) == 1 then
						util.Decal("Scorch", Tracer.HitPos + Tracer.HitNormal, Tracer.HitPos - Tracer.HitNormal)
					end
				end
				if self.Owner:IsPlayer() then self.Owner:LagCompensation(false) end
				self:SetEZsupplies(JMod.EZ_RESOURCE_TYPES.FUEL, Fuel - 0.5)
			end
			self.NextExtinguishTime = Time + NextAttackTime * 2
		end
	end
end

function SWEP:SecondaryAttack()
	local Time = CurTime()
	local NextAttackTime = .05
	self:SetNextSecondaryFire(CurTime() + NextAttackTime)
	if self.Owner:IsPlayer() and (self.Owner:IsSprinting() or self.Owner:KeyDown(IN_ZOOM)) then return end
	if (State == STATE_FLAMIN) then return end
	if self:GetFuel() <= 0 then return end
	
	if SERVER then
		local State = self:GetState()

		if (State == STATE_NOTHIN) then
			self:SetState(STATE_IGNITIN)
			if self.SoundLoop then self.SoundLoop:Stop() end
			self.SoundLoop = CreateSound(self, "snds_jack_gmod/flareburn.wav")
			self.SoundLoop:SetSoundLevel(75)
			self.SoundLoop:Play()
		elseif (State == STATE_IGNITIN) then
			local FirePos, FireAng = self:GetNozzle()
			local IgniteTr = util.QuickTrace(FirePos, FireAng:Forward() * 80, self.Owner)
			if IgniteTr.Hit then
				for k, v in pairs(ents.FindInSphere(IgniteTr.HitPos, 20)) do
					if v.JModHighlyFlammableFunc then
						JMod.SetEZowner(v, self.EZowner)
						local Func = v[v.JModHighlyFlammableFunc]
						Func(v)
					end
				end
			end
		end
		if (State ~= STATE_SPRAYIN) then
			self.NextExtinguishTime = Time + NextAttackTime * 2
		end
	end
end

function SWEP:Msg(msg)
	self.Owner:PrintMessage(HUD_PRINTCENTER, msg)
end

function SWEP:Pawnch()
	self.Owner:ViewPunch(AngleRand(-.2, .2))
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:UpdateNextIdle()
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
			local Take = math.min(amt, self.MaxFuel - CurAmt)
			
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
	local Pack = ents.Create("ent_aboot_gmod_ezosinc")
	Pack:SetPos(self:GetPos())
	Pack:SetAngles(self:GetAngles())
	Pack:Spawn()
	Pack:Activate()

	Pack:SetFuel(self:GetFuel())

	local Phys = Pack:GetPhysicsObject()

	if Phys then
		Phys:SetVelocity(self:GetPhysicsObject():GetVelocity() / 2)
	end

	self:Remove()
end

function SWEP:OnRemove()
	self:SCKHolster()

	self:Cease()

	if IsValid(self.Owner) and CLIENT and self.Owner:IsPlayer() then
		local vm = self.Owner:GetViewModel()

		if IsValid(vm) then
			vm:SetMaterial("")
		end
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

	self:Cease()

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

	local Time = CurTime()
	self:SetNextPrimaryFire(Time + 1)
	self:SetNextSecondaryFire(Time + 1)
	self.NextExtinguishTime = Time

	if not(self.Owner:IsPlayer()) then return end
	local vm = self.Owner:GetViewModel()

	if IsValid(vm) and vm.LookupSequence then
		Downness = 10
		self:UpdateNextIdle()
		self:EmitSound("snds_jack_gmod/toolbox" .. math.random(1, 7) .. ".ogg", 65, math.random(90, 110))
	end

	return true
end

function SWEP:Think()
	local Time = CurTime()
	local idletime = self.NextIdle
	local State = self:GetState()

	if idletime > 0 and Time > idletime then
		self:UpdateNextIdle()
	end

	if self.Owner:IsPlayer() and (self.Owner:IsSprinting() or self.Owner:KeyDown(IN_ZOOM)) then
		self:SetHoldType("shotgun")
		if (State > STATE_NOTHIN) then
			self:Cease()
		end
	else
		--self:SetHoldType("shotgun")
	end

	if SERVER then
		if ((State == STATE_FLAMIN) and (self.Owner:IsPlayer() and not self.Owner:KeyDown(IN_ATTACK))) or ((State > STATE_NOTHIN) and (self.NextExtinguishTime < Time)) then
			if self.Owner:IsPlayer() and self.Owner:KeyDown(IN_ATTACK2) then
				self:SetState(STATE_IGNITIN)
				if self.SoundLoop then self.SoundLoop:Stop() end
				self.SoundLoop = CreateSound(self, "snds_jack_gmod/flareburn.wav")
				self.SoundLoop:SetSoundLevel(75)
				self.SoundLoop:Play()
			else
				self:Cease()
			end
		end
	end
end

function SWEP:Sprint()
end

function SWEP:DrawHUD()
	if GetConVar("cl_drawhud"):GetBool() == false then return end
	local Ply = self.Owner
	if Ply:ShouldDrawLocalPlayer() then return end
	local W, H = ScrW(), ScrH()

	draw.SimpleTextOutlined("Fuel: "..math.floor(self:GetFuel()), "Trebuchet24", W * .1, H * .5 + 30, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, 50))
end

----------------- sck -------------------
function SWEP:SCKHolster()
	if CLIENT and IsValid(self.Owner) and self.Owner:IsPlayer() then
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
		if IsValid(self.Owner) and self.Owner:IsPlayer() then
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
		if not self.Owner:IsPlayer() then return end
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
