-- Jackarunda 2021
AddCSLuaFile()
ENT.Base = "ent_jack_gmod_ezgrenade"
ENT.Author = "Jackarunda, AdventureBoots"
ENT.PrintName = "EZ TeleNade"
ENT.Category = "JMod - EZ HL:2"
ENT.Spawnable = true
ENT.JModPreferredCarryAngles = Angle(0, 0, 90)
ENT.Model = "models/aboot/tpnade.mdl"
ENT.Mass = 15
ENT.SpoonScale = 1

if SERVER then
	function ENT:CustomInit()
		self:SetBodygroup(1, 1)
		self.TeleRange = 200
	end

	function ENT:Arm()
		self:SetState(JMod.EZ_STATE_ARMED)
		if IsValid(self.TeleMarker) then 
			self.TeleMarker:SetActivated(true)
		end
		timer.Simple(3, function()
			if IsValid(self) then
				self:Detonate()
			end
		end)
		timer.Simple(2.5, function()
			if not(IsValid(self)) then return end
			self:EmitSound("snd_jack_wormhole.wav", 105, 100, 1)
			local PortalOpen = EffectData()
			PortalOpen:SetOrigin(self:GetPos() + Vector(0, 0, 40))
			PortalOpen:SetScale(self.TeleRange)
			util.Effect("eff_jack_gmod_portalopen", PortalOpen, true, true)
			timer.Simple(0.75, function()
				if not(IsValid(self)) then return end
				local PortalClose = EffectData()
				PortalClose:SetOrigin(self:GetPos() + Vector(0, 0, 40))
				PortalClose:SetScale(self.TeleRange)
				util.Effect("eff_jack_gmod_portalclose", PortalClose, true, true)
			end)
		end)
	end

	function ENT:Prime()
		self:SetState(JMod.EZ_STATE_PRIMED)
		self:EmitSound("snd_jack_cloakon.wav", 60, 100)
		self:SetBodygroup(1, 0)

		local Marker = ents.Create("ent_aboot_gmod_eztelemarker")
		Marker:SetPos(self:GetPos() + Vector(0, 0, 5))
		Marker:SetAngles(self:GetAngles())
		JMod.SetOwner(Marker, self.Owner)
		Marker:Spawn()
		Marker:Activate()
		self.TeleMarker = Marker
		Marker.ToNade = self
		Marker.TeleRange = self.TeleRange
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		local SelfPos, Time = self:GetPos() + Vector(0, 0, 10), CurTime()
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

		for k, v in pairs(ents.FindInSphere(SelfPos, 200)) do
			if v:IsNPC() then
				v.EZNPCincapacitate = Time + math.Rand(3, 5)
			end
		end

		self:SetColor(Color(0, 0, 0))
		JMod.Sploom(self.Owner, self:GetPos(), 20)
		self:EmitSound("snd_jack_fragsplodeclose.wav", 90, 140)
		local plooie = EffectData()
		plooie:SetOrigin(SelfPos)
		util.Effect("eff_jack_gmod_flashbang", plooie, true, true)
		util.ScreenShake(SelfPos, 20, 20, .2, 1000)

		--timer.Simple(.4, function()
			if not IsValid(self) then return end
			util.BlastDamage(self, JMod.GetOwner(self), SelfPos, 500, 1)
			self:EmitSound("weapons/physcannon/energy_sing_explosion2.wav", 90, 140)
		--end)

		timer.Simple(.5, function() 
			if not IsValid(self) then return end
			if not IsValid(self.TeleMarker) then return end 
			for _, v in pairs(ents.FindInSphere(self.TeleMarker:GetPos(), self.TeleRange)) do
				if self.TeleMarker:ShouldTeleport(v) then
					for i = 1, 100 do
						local BBMin, BBMax = v:GetCollisionBounds()
						if v:IsPlayer() and v:Alive() then
							BBMin, BBMax = v:GetHull()
						end
						--print(v, BBMin, BBMax)
						--local RelativeVec = self.TeleMarker:GetPos() - v:GetPos()
						local RandomVec = VectorRand(10, self.TeleRange)
						RandomVec[3] = RandomVec[3] * 0.25 -- We don't need it to go up or down very much.
						local EndVec = SelfPos + RandomVec
						local StartVec = SelfPos + Vector(0, 0, 1 + BBMin[3])

						local BBcheck = util.TraceHull({
							start = StartVec,
							endpos = EndVec,
							mins = BBMin,
							maxs = BBMax,
							mask = MASK_SOLID,
							filter = self
						})
						--Note to self, make striders break on cetain explosions
						--print(v, self:WorldToLocal(RelativeVec), BBcheck.Hit)
						if not BBcheck.StartSolid then
							v:SetPos(BBcheck.HitPos)
							v:GetPhysicsObject():Wake()
							v:SetVelocity(self:GetPhysicsObject():GetVelocity())
							--[[if v:IsPlayer() then
								local HeldEnt = v:GetEntityInUse()
								if IsValid(HeldEnt) and IsValid(HeldEnt:GetPhysicsObject()) then
									HeldEnt:SetPos(v:GetPos() + Vector(10, 10, 30))
								end
							end]]--
							--[[timer.Simple(math.Rand(0.1, 0.5), function()
								if IsValid(v) and v:GetPhysicsObject():IsPenetrating() then
									local DisDmg = DamageInfo()
									DisDmg:SetDamage(100000)
									DisDmg:SetDamageType(DMG_DISSOLVE)
									DisDmg:SetInflictor(self or game.GetWorld())
									DisDmg:SetAttacker(JMod.GetOwner(self))
									v:TakeDamageInfo(DisDmg)
								end
							end)]]--
							break
						end
					end
				end
			end
			self.TeleMarker:SetActivated(false)
		end)
		SafeRemoveEntityDelayed(self, 10)
	end

	function ENT:OnRemove()
		if IsValid(self.TeleMarker) then 
			SafeRemoveEntity(self.TeleMarker)
		end
	end

elseif CLIENT then
	local Pinch = Material("sprites/mat_jack_gravipinch")

	function ENT:Draw()
		local SelfPos = self:GetPos()
		self:DrawModel()
		
		--[[render.SetMaterial(Pinch)
		render.DrawSprite(SelfPos + Vector(0, 0, 40), 200, 200)]]--
	end

	language.Add("ent_jack_gmod_eztelenade", "EZ Teleport Grenade")
end
