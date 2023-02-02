-- Jackarunda 2021
AddCSLuaFile()
ENT.Base = "ent_jack_gmod_ezgrenade"
ENT.Author = "Jackarunda, AdventureBoots"
ENT.PrintName = "EZ TeleNade"
ENT.Category = "JMod - EZ HL:2"
ENT.Spawnable = true
ENT.JModPreferredCarryAngles = Angle(90, 0, 0)
ENT.Model = "models/props_lab/labpart_physics.mdl"
ENT.SpoonScale = 2

if SERVER then
	function ENT:Arm()
		self:SetBodygroup(2, 1)
		self:SetState(JMod.EZ_STATE_ARMED)

		timer.Simple(2, function()
			if IsValid(self) then
				self:Detonate()
			end
		end)
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		local SelfPos, Time = self:GetPos() + Vector(0, 0, 10), CurTime()
		--JMod.Sploom(self.Owner, self:GetPos(), 20)
		--self:EmitSound("snd_jack_fragsplodeclose.wav", 90, 140)
		--self:EmitSound("snd_jack_fragsplodeclose.wav", 90, 140)
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
		end)

		timer.Simple(1, function() 
			if not IsValid(self) then return end
			if IsValid(self.Owner) and self.Owner:Alive() then 
				local PlyHullMin, PlyHullMax = self.Owner:GetHull()
				for i = 1, 100 do
					local RandVec = SelfPos + VectorRand(0, 100)
					local BBcheck = util.TraceHull({
						start = RandVec,
						endpos = RandVec,
						mins = PlyHullMin,
						maxs = PlyHullMin,
					})
					if not BBcheck.Hit then
						PrintTable(BBcheck)
						self.Owner:SetPos(SelfPos)
						break
					end
				end
			end
		end)

		SafeRemoveEntityDelayed(self, 10)
	end
elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_jack_gmod_eztelenade", "EZ Teleport Grenade")
end
