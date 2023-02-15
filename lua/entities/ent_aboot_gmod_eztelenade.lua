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

		timer.Simple(.15, function() 
			if not IsValid(self) then return end
			--JMod.Sploom(self.Owner, self:GetPos(), 20)
			self:EmitSound("snd_jack_fragsplodeclose.wav", 90, 140)
			local plooie = EffectData()
			plooie:SetOrigin(SelfPos)
			util.Effect("eff_jack_gmod_flashbang", plooie, true, true)
			util.ScreenShake(SelfPos, 20, 20, .2, 1000)
		end)

		timer.Simple(.4, function()
			if not IsValid(self) then return end
			util.BlastDamage(self, JMod.GetOwner(self), SelfPos, 500, 1)
			self:EmitSound("weapons/physcannon/energy_sing_explosion2.wav", 90, 140)
		end)

		timer.Simple(.5, function() 
			if not IsValid(self) then return end
			if not IsValid(self.TeleMarker) then return end 
			for _, v in pairs(ents.FindInSphere(self.TeleMarker:GetPos(), 245)) do
				if self.TeleMarker:ShouldTeleport(v) then
					local BBMin, BBMax = v:GetCollisionBounds()
					if v:IsPlayer() and v:Alive() then
						BBMin, BBMax = v:GetHull()
					end
					--print(v, BBMin, BBMax)
					local RelativeVec = self.TeleMarker:GetPos() - v:GetPos()--v:LocalToWorld(v:OBBCenter())
					local BBcheck = util.TraceHull({
						start = RelativeVec,
						endpos = RelativeVec,
						mins = BBMin * 1,
						maxs = BBMax * 1,
						mask = MASK_SOLID,
						filter = self
					})
					--print(v, self:WorldToLocal(RelativeVec), BBcheck.Hit)
					if not(BBcheck.Hit) then
						PointsToCheck = {
							Vector(BBMin[1], BBMin[2], BBMin[3]),
							Vector(BBMax[1], BBMin[2], BBMin[3]),
							Vector(BBMin[1], BBMax[2], BBMin[3]),
							Vector(BBMax[1], BBMax[2], BBMin[3]),
							Vector(BBMin[1], BBMin[2], BBMax[3]),
							Vector(BBMax[1], BBMin[2], BBMax[3]),
							Vector(BBMin[1], BBMax[2], BBMax[3]),
							Vector(BBMax[1], BBMax[2], BBMax[3])
						}
						local Good = true
						for _, p in ipairs(PointsToCheck) do
							if (bit.band(util.PointContents(RelativeVec + p), CONTENTS_SOLID) == CONTENTS_SOLID) then
								Good = false
								break
							end
						end
						if Good then
							v:GetPhysicsObject():Wake()
							v:SetPos(self:GetPos() - RelativeVec)
							v:SetVelocity(self:GetPhysicsObject():GetVelocity())
							if isstring(v.EZoldMaterial) then
								print(v.EZoldMaterial)
								v:SetMaterial(v.EZoldMaterial)
								v.EZoldMaterial = nil
							end
						end
					end
				end
			end
		end)
		self.TeleMarker:SetActivated(false)
		SafeRemoveEntityDelayed(self, 10)
	end

	function ENT:OnRemove()
		if IsValid(self.TeleMarker) then 
			SafeRemoveEntity(self.TeleMarker)
		end
	end

elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_jack_gmod_eztelenade", "EZ Teleport Grenade")
end
