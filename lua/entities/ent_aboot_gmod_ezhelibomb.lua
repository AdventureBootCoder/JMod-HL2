-- AdventureBoots 2024
AddCSLuaFile()
DEFINE_BASECLASS("ent_jack_gmod_ezbomb")
ENT.Base = "ent_jack_gmod_ezbomb"
ENT.Author = "AdventureBoots"
ENT.Category = "JMod - EZ HL:2"
ENT.Information = "glhfggwpezpznore"
ENT.PrintName = "EZ Helicopter Bomb"
ENT.Spawnable = true
ENT.AdminSpawnable = true
---
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)
ENT.EZguidable = false
ENT.EZbombBaySize = 12
ENT.EZbuoyancy = .5
ENT.DetOnImpactEnts = {"npc_helicopter", "npc_gunship", "phys_bone_follower"}
---
ENT.EZguidable = false
ENT.Model = "models/combine_helicopter/helicopter_bomb01.mdl"
ENT.Mass = 100
ENT.DetSpeed = 1000
ENT.DetType = "impactdet"
ENT.Durability = 150
ENT.SpawnHeight = 10

local STATE_BROKEN, STATE_OFF, STATE_ARMED, STATE_COOKING = -1, 0, 1, 2

---
if SERVER then
	function ENT:Initialize()
		BaseClass.Initialize(self)
		self:SetSkin(1)
		self.CookingTicks = 0
	end

	function ENT:PhysicsCollide(data, physobj)
		if not IsValid(self) then return end
		local State = self:GetState()

		if data.DeltaTime > 0.2 then
			if data.Speed > 50 then
				self:EmitSound("Canister.ImpactHard")
			end

			if (data.Speed > 300) and (State == STATE_ARMED) then
				--jprint(data.HitEntity:GetClass())
				if JMod.ShouldAttack(self, data.HitEntity) or (table.HasValue(self.DetOnImpactEnts, data.HitEntity:GetClass())) then
					self:Detonate()
				else
					self:StartCooking()
				end
				
				return
			end

			if State == STATE_COOKING then
				--jprint(data.HitEntity:GetClass())
				if JMod.ShouldAttack(self, data.HitEntity) or (IsValid(data.HitEntity) and table.HasValue(self.DetOnImpactEnts, data.HitEntity:GetClass())) then
					self:Detonate()
				end
			end

			if data.Speed > 2000 then
				self:Break()
			end
		end
	end

	function ENT:Use(activator)
		local State, Time = self:GetState(), CurTime()
		if State < 0 then return end

		if State == STATE_OFF then
			JMod.SetEZowner(self, activator)

			if Time - self.LastUse < .2 then
				self:SetState(STATE_ARMED)
				self:EmitSound("snds_jack_gmod/bomb_arm.ogg", 70, 110)
				self.EZdroppableBombArmedTime = CurTime()
				JMod.Hint(activator, "impactdet")
				self:SetSkin(0)
			else
				JMod.Hint(activator, "double tap to arm")
			end

			self.LastUse = Time
		elseif State == STATE_ARMED then
			JMod.SetEZowner(self, activator)

			if Time - self.LastUse < .2 then
				self:SetState(STATE_OFF)
				self:EmitSound("snds_jack_gmod/bomb_disarm.ogg", 70, 110)
				self.EZdroppableBombArmedTime = nil
				self:SetSkin(1)
			else
				JMod.Hint(activator, "double tap to disarm")
			end

			self.LastUse = Time
		end
	end

	function ENT:StartCooking() 
		if self:GetState() == STATE_COOKING then return end
		self:SetState(STATE_COOKING)

		self.BeepSound = CreateSound(self, "npc/attack_helicopter/aheli_mine_seek_loop1.wav")
		self.BeepSound:Play()
		self.BeepSound:ChangeVolume(1)
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		local SelfPos, Att = self:GetPos() + Vector(0, 0, 60), JMod.GetEZowner(self)
		JMod.Sploom(Att, SelfPos, 150)
		---
		util.ScreenShake(SelfPos, 1000, 3, 2, 4000)
		local Eff = "500lb_ground"

		if not util.QuickTrace(SelfPos, Vector(0, 0, -300), {self}).HitWorld then
			Eff = "500lb_air"
		end

		if self:WaterLevel() >= 3 then
			Eff = "WaterSurfaceExplosion"
		end

		for i = 1, 3 do
			sound.Play("ambient/explosions/explode_" .. math.random(1, 9) .. ".wav", SelfPos + VectorRand() * 1000, 160, math.random(80, 110))
		end

		---
		for k, ply in player.Iterator() do
			local Dist = ply:GetPos():Distance(SelfPos)

			if (Dist > 250) and (Dist < 4000) then
				timer.Simple(Dist / 6000, function()
					ply:EmitSound("snds_jack_gmod/big_bomb_far.ogg", 55, 110)
					sound.Play("ambient/explosions/explode_" .. math.random(1, 9) .. ".wav", ply:GetPos(), 60, 70)
					util.ScreenShake(ply:GetPos(), 1000, 3, 1, 100)
				end)
			end
		end

		---
		util.BlastDamage(game.GetWorld(), Att, SelfPos + Vector(0, 0, 300), 600, 120)

		timer.Simple(.25, function()
			util.BlastDamage(game.GetWorld(), Att, SelfPos, 1000, 100)
		end)

		for k, ent in pairs(ents.FindInSphere(SelfPos, 250)) do
			if ent:GetClass() == "npc_helicopter" then
				ent:Fire("selfdestruct", "", math.Rand(0, 2))
			end
		end

		---
		JMod.WreckBuildings(self, SelfPos, 7)
		JMod.BlastDoors(self, SelfPos, 7)

		---
		timer.Simple(.2, function()
			local Tr = util.QuickTrace(SelfPos + Vector(0, 0, 100), Vector(0, 0, -400))

			if Tr.Hit and not(Eff == "WaterSurfaceExplosion") then
				util.Decal("BigScorch", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
			end
		end)

		---
		self:Remove()

		timer.Simple(.1, function()
			if Eff == "WaterSurfaceExplosion" then
				local Splach = EffectData()
				Splach:SetOrigin(SelfPos)
				Splach:SetNormal(Vector(0, 0, 1))
				Splach:SetScale(100)
				util.Effect("WaterSplash", Splach)
				util.Effect("WaterSurfaceExplosion", Splach)
			else
				ParticleEffect(Eff, SelfPos, Angle(0, 0, 0))
			end
		end)
	end

	function ENT:OnRemove()
		if self.BeepSound then
			self.BeepSound:Stop()
		end 
	end

	--
	function ENT:EZdetonateOverride(detonator)
		self:Detonate()
	end

	function ENT:AeroDragThink()
		local State = self:GetState()
		local Phys = self:GetPhysicsObject()
		--JMod.AeroDrag(self, -self:GetRight(), 6)
		if State == STATE_COOKING then
			self.CookingTicks = self.CookingTicks + .1
			self:SetSkin((self:GetSkin() == 1 and 0) or (self:GetSkin() == 0 and 1))
			--jprint(self.CookingTicks)
			if self.CookingTicks >= 6 then
				self:Detonate()
			end
		end
		self:NextThink(CurTime() + .1)

		return true
	end
elseif CLIENT then
	function ENT:Initialize()
		--
	end

	function ENT:Think()
		--
	end

	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_jack_gmod_ezhelibomb", "EZ Helicopter Bomb")
end
