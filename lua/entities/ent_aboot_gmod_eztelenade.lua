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

		timer.Simple(2, function()
			if IsValid(self) then
				self:Detonate()
			end
		end)
	end

	function ENT:Prime()
		self:SetState(JMod.EZ_STATE_PRIMED)
		self:EmitSound("snd_jack_cloakon.wav", 60, 100)
		self:SetBodygroup(1, 0)
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		local SelfPos, Time = self:GetPos() + Vector(0, 0, 10), CurTime()
		--JMod.Sploom(self.Owner, self:GetPos(), 20)
		--self:EmitSound("snd_jack_fragsplodeclose.wav", 90, 140)
		self:EmitSound("weapons/physcannon/energy_sing_explosion2.wav", 90, 140)
		local plooie = EffectData()
		plooie:SetOrigin(SelfPos)
		util.Effect("eff_jack_gmod_flashbang", plooie, true, true)
		util.ScreenShake(SelfPos, 20, 20, .2, 1000)

		for k, v in pairs(ents.FindInSphere(SelfPos, 200)) do
			if v:IsNPC() then
				v.EZNPCincapacitate = Time + math.Rand(3, 5)
			end
		end

		self:SetColor(Color(0, 0, 0))

		timer.Simple(.1, function()
			if not IsValid(self) then return end
			util.BlastDamage(self, self.Owner or self, SelfPos, 1000, 2)
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		end)

		timer.Simple(.5, function() 
			if not IsValid(self) then return end
			if IsValid(self.Owner) and self.Owner:Alive() then 
				local PlyHullMin, PlyHullMax = self.Owner:GetHull()
				--print(PlyHullMin, PlyHullMax)
				for i = 1, 200 do
					local RandVec = SelfPos + VectorRand(16, 100)
					local BBcheck = util.TraceHull({
						start = SelfPos + Vector(0, 0, 2),
						endpos = RandVec,
						mins = PlyHullMin * 1.1,
						maxs = PlyHullMax * 1.1,
						mask = MASK_SOLID,
						filter = self
					})
					if not(BBcheck.Hit) then
						PointsToCheck = {
							Vector(PlyHullMin[1], PlyHullMin[2], PlyHullMin[3]),
							Vector(PlyHullMax[1], PlyHullMin[2], PlyHullMin[3]),
							Vector(PlyHullMin[1], PlyHullMax[2], PlyHullMin[3]),
							Vector(PlyHullMax[1], PlyHullMax[2], PlyHullMin[3]),
							Vector(PlyHullMin[1], PlyHullMin[2], PlyHullMax[3]),
							Vector(PlyHullMax[1], PlyHullMin[2], PlyHullMax[3]),
							Vector(PlyHullMin[1], PlyHullMax[2], PlyHullMax[3]),
							Vector(PlyHullMax[1], PlyHullMax[2], PlyHullMax[3])
						}
						local Good = true
						for _, v in ipairs(PointsToCheck) do
							local PointCheck = util.IsInWorld(RandVec + v)
							if not PointCheck then
								Good = false
								break
							end
						end
						if Good then
							self.Owner:SetPos(SelfPos)
							self.Owner:SetVelocity(self:GetPhysicsObject():GetVelocity())
							break
						end
					end
				end
			end
		end)

		SafeRemoveEntityDelayed(self, 10)
	end

	function util.IsAllInWorld( ent )
		if IsValid( ent ) and IsEntity( ent ) then
			local inworld = ent:IsInWorld()
			local vec1, vec2 = ent:GetCollisionBounds()
			local realvec1, realvec2 = ent:WorldToLocal( vec1 ), ent:WorldToLocal( vec2 )
			if inworld and util.IsInWorld( realvec1 ) and util.IsInWorld( realvec2 ) then
				return true
			end
		end
		return false
	end

elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_jack_gmod_eztelenade", "EZ Teleport Grenade")
end
