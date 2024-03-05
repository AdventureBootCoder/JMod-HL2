-- Jackarunda 2021
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "AdventureBoots"
ENT.Category = "JMod - EZ HL:2"
ENT.Information = "glhfggwpezpznore"
ENT.PrintName = "EZ RPG round"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.CollisionGroup = COLLISION_GROUP_NONE
ENT.NoPhys = true
ENT.IsEZrocket = true
local ThinkRate = 66 --Hz

---
if SERVER then
	function ENT:Initialize()
		self:SetMoveType(MOVETYPE_NONE)
		self:DrawShadow(false)
		self:SetCollisionBounds(Vector(-20, -20, -10), Vector(20, 20, 10))
		self:PhysicsInitBox(Vector(-20, -20, -10), Vector(20, 20, 10))
		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableCollisions(false)
		end

		self:SetNotSolid(true)
		self.NextDet = 0
		self.FuelLeft = 100
		timer.Simple(0, function()
			if not(IsValid(self)) then return end
			if self.Guided then
				self.DieTime = CurTime() + 30
			else
				self.DieTime = CurTime() + 10
			end
		end)
		self.SoundLoop = CreateSound(self, "weapons/rpg/rocket1.wav")
		self.SoundLoop:Play()
		self.SoundLoop:ChangeVolume(1)
		self.SoundLoop:SetSoundLevel(120)
		self.NextThrust = 0
		local SelfOwner = self.Owner
		if IsValid(SelfOwner) and SelfOwner.GetShootPos then
			self.OwnerTr = util.QuickTrace(SelfOwner:GetShootPos(), SelfOwner:GetAimVector() * 9e9, {self, SelfOwner})
		end
		self:Think()
	end

	function ENT:Detonate(tr)
		if self.NextDet > CurTime() then return end
		if self.Exploded then return end
		self.Exploded = true
		local SelfPos, Att, Dir = (tr and tr.HitPos + tr.HitNormal * 5) or self:GetPos() + Vector(0, 0, 30), self.EZowner or self, -self:GetRight()
		JMod.Sploom(Att, SelfPos, 100)
		---
		util.ScreenShake(SelfPos, 1000, 3, 2, 700)
		self:EmitSound("snd_jack_fragsplodeclose.wav", 90, 100)
		---
		util.BlastDamage(game.GetWorld(), Att, SelfPos + Vector(0, 0, 50), self.BlastRadius or 150, self.Damage or 200)

		for k, ent in pairs(ents.FindInSphere(SelfPos, 200)) do
			if ent:GetClass() == "npc_helicopter" then
				if math.random(1, 3) == 1 then
					ent:Fire("selfdestruct", "", math.Rand(0, 2))
				end
			end
		end

		---
		JMod.WreckBuildings(self, SelfPos, .4)
		JMod.BlastDoors(self, SelfPos, 2)

		---
		timer.Simple(.2, function()
			local Tr = util.QuickTrace(SelfPos - Dir * 100, Dir * 300)

			if Tr.Hit then
				util.Decal("Scorch", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
			end
		end)

		---
		self:Remove()
		local Ang = self:GetAngles()
		Ang:RotateAroundAxis(Ang:Forward(), -90)

		timer.Simple(.1, function()
			ParticleEffect("50lb_air", SelfPos - Dir * 20, Ang)
			ParticleEffect("50lb_air", SelfPos - Dir * 50, Ang)
		end)
	end

	function ENT:OnRemove()
		if self.SoundLoop then
			self.SoundLoop:Stop()
		end
	end

	--
	local LastTime = 0

	function ENT:Think()
		local Time, SelfPos, Dir, Speed, SelfOwner = CurTime(), self:GetPos(), self.CurVel:GetNormalized(), self.CurVel:Length(), self.Owner
		if IsValid(SelfOwner) and SelfOwner.GetActiveWeapon then
			local Wep = SelfOwner:GetActiveWeapon()
			if IsValid(Wep) and Wep.EZrocket and Wep.EZrocket == self then
				self.OwnerTr = util.QuickTrace(SelfOwner:GetShootPos(), SelfOwner:GetAimVector() * 9e9, {self, SelfOwner})
			end
		end

		local Tr
		if self.InitialTrace then
			Tr = self.InitialTrace
			self.InitialTrace = nil
		else
			local Filter = {self}

			table.insert(Filter, SelfOwner)
			--Tr=util.TraceLine({start=SelfPos,endpos=SelfPos+self.CurVel/ThinkRate,filter=Filter})
			local Mask, HitWater, HitChainLink = MASK_SHOT, false, true

			if HitWater then
				Mask = Mask + MASK_WATER
			end

			if HitChainLink then
				Mask = nil
			end

			Tr = util.TraceHull({
				start = SelfPos,
				endpos = SelfPos + self.CurVel / ThinkRate,
				filter = Filter,
				mins = Vector(-3, -3, -3),
				maxs = Vector(3, 3, 3),
				mask = Mask
			})
		end

		if Tr.Hit then
			if Tr.HitSky then
				self:Remove() -- It'd be interesting to have an effect for it leaving map.

				return
			end

			self:Detonate(Tr)
		else
			self:SetPos(SelfPos + self.CurVel / ThinkRate)
			--local AngleToBe = self.CurVel:GetNormalized():Angle()
			local AimPos = (self.OwnerTr and self.OwnerTr.HitPos) or self.Owner.GuidePos
			if not AimPos or (AimPos:Distance(self:GetPos()) < 10) then
				self:Detonate()

				return
			end
			local AngleToBe = (AimPos - self:GetPos()):GetNormalized():Angle()
			AngleToBe:RotateAroundAxis(AngleToBe:Up(), -90)
			self:SetAngles(AngleToBe)
			local RandomDir = VectorRand() * 2000
			if self.Guided then
				--local NewDir = (AimPos - self:GetPos()):GetNormalized() * 600
				local NewDir = AngleToBe:Right() * -60000
				self.CurVel = NewDir / ThinkRate
			else
				self.CurVel = self.CurVel + (physenv.GetGravity() + RandomDir) / ThinkRate * .2
			end

			---
			if (self.FuelLeft > 0) and (self.NextThrust < Time) then
				self.NextThrust = Time + .02
				if self.Guided then
					self.CurVel = self.CurVel --+ self.CurVel:GetNormalized() * 50
					--self.FuelLeft = self.FuelLeft - 1
				else
					self.CurVel = self.CurVel + self.CurVel:GetNormalized() * 200
					self.FuelLeft = self.FuelLeft - 5
				end
				---
				local Eff = EffectData()
				Eff:SetOrigin(self:GetPos())
				Eff:SetNormal(-self.CurVel:GetNormalized())
				Eff:SetScale(1)
				util.Effect("eff_jack_gmod_thrustsmoke", Eff, true, true)
			end
		end

		if IsValid(self) then
			if (self.DieTime or Time) < Time then
				self:Detonate()

				return
			end

			self:NextThink(Time + (1 / ThinkRate))
		end

		LastTime = Time

		return true
	end
elseif CLIENT then
	function ENT:Initialize()
		self.Mdl = ClientsideModel("models/weapons/w_missile_launch.mdl")
		self.Mdl:SetSkin(1)
		self.Mdl:SetPos(self:GetPos())
		self.Mdl:SetParent(self)
		self.Mdl:SetNoDraw(true)
		self.RenderPos = self:GetPos()
		self.NextRender = CurTime() + .05
	end

	function ENT:Remove()
		if IsValid(self.Mdl) then
			self.Mdl:Remove()
		end
	end

	function ENT:Think()
	end

	--
	local GlowSprite = Material("mat_jack_gmod_glowsprite")

	function ENT:Draw()
		if self.NextRender > CurTime() then return end
		local Pos, Ang, Dir = self.RenderPos, self:GetAngles(), self:GetRight()
		Ang:RotateAroundAxis(Ang:Up(), 90)
		--self:DrawModel()
		self.Mdl:SetRenderOrigin(Pos + Ang:Up() * 1.5 - Ang:Right() * 0 - Ang:Forward() * 1)
		self.Mdl:SetRenderAngles(Ang)
		--[[local Matricks = Matrix()
		Matricks:Scale(Vector(.2, .4, .4))
		self.Mdl:EnableMatrix("RenderMultiply", Matricks)]]--
		self.Mdl:DrawModel()
		--
		self.BurnoutTime = self.BurnoutTime or CurTime() + 30

		if self.BurnoutTime > CurTime() then
			render.SetMaterial(GlowSprite)

			for i = 1, 10 do
				local Inv = 10 - i
				render.DrawSprite(Pos + Dir * (i * 5 + math.random(30, 40) - 15), 3 * Inv, 3 * Inv, Color(255, 255 - i * 10, 255 - i * 20, 255))
			end

			local dlight = DynamicLight(self:EntIndex())

			if dlight then
				dlight.pos = Pos + Dir * 35
				dlight.r = 255
				dlight.g = 175
				dlight.b = 100
				dlight.brightness = 1
				dlight.Decay = 200
				dlight.Size = 400
				dlight.DieTime = CurTime() + .5
			end
		end

		self.RenderPos = LerpVector(FrameTime() * 20, self.RenderPos, self:GetPos())
	end
end
