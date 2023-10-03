-- AdventureBoots 2023
AddCSLuaFile()
ENT.Base = "ent_jack_gmod_ezgrenade"
ENT.Author = "AdventureBoots"
ENT.PrintName = "EZ Combine Grenade"
ENT.Category = "JMod - EZ HL:2"
ENT.Spawnable = true
---
ENT.JModPreferredCarryAngles = Angle(0, 100, 0)
ENT.Model= "models/weapons/w_npcnade.mdl"
--ENT.Material=""
ENT.HardThrowStr = 450
ENT.SoftThrowStr = 320
ENT.SpoonScale = 2
ENT.DetTime = 1

if(SERVER)then
	function ENT:Prime()
		self:SetState(JMod.EZ_STATE_PRIMED)
		self:EmitSound("weapons/pinpull.wav", 60, 100)
		--self:SetBodygroup(3, 1)
		self.LastSpeed = 0
		self.Ticks = 0
		self.NextTickTime = 0
	end

	function ENT:Arm()
		--self:SetBodygroup(2, 1)
		self:SetState(JMod.EZ_STATE_ON)
		self:SpoonEffect()
		--timer.Simple(4, function()
			--if(IsValid(self))then self:Detonate() end
		--end)
	end

	function ENT:CustomThink(State, Time)
		if (State == JMod.EZ_STATE_ON) then
			local Vel = self:GetPhysicsObject():GetVelocity()
			local Sped = Vel:Length()
			if((Sped - self.LastSpeed) > 300)then
				self:SetState(JMod.EZ_STATE_ARMED)
				if math.random(1, 1000) == 1 then
					util.SpriteTrail( self, 1, Color( 255, 0, 0 ), false, 3, 1, 1, 1 / ( 3 + 1 ) * 0.5, "trails/lol" )
				else
					util.SpriteTrail( self, 1, Color( 255, 0, 0 ), false, 2, 0.1, 1, 1 / ( 2 + 0.1 ) * 0.5, "trails/plasma" )
				end
			else
				self.LastSpeed = Sped
			end
		end
		if (State == JMod.EZ_STATE_ARMED) then
			if (self.NextTickTime < Time) then
				self.NextTickTime = Time + 0.2
				self.Ticks = self.Ticks + 0.2
				self:EmitSound("weapons/grenade/tick1.wav", 100, math.random(90, 110), 1)
				if (self.Ticks >= self.DetTime) then
					self:Detonate()
				end
			end
		end
	end

	function ENT:Detonate()
		if(self.Exploded)then return end
		self.Exploded = true
		local SelfPos = self:GetPos()
		local PowerMult = 0.69
		JMod.Sploom(self.Owner, self:GetPos(), 150, 400)
		JMod.BlastDoors(self.Owner, self:GetPos(), 100, 445, false)
		self:EmitSound("snd_jack_fragsplodeclose.wav", 90, 100)
		local plooie = EffectData()
		plooie:SetOrigin(SelfPos)
		plooie:SetScale(0.5)
		util.Effect("eff_jack_plastisplosion", plooie, true, true)
		util.ScreenShake(SelfPos, 99999, 99999, 1, 750 * 1.75)
		--local OnGround = util.QuickTrace(SelfPos+Vector(0, 0, 5),Vector(0, 0, -15), {self}).Hit
		self:Remove()
	end

	function ENT:OnTakeDamage(dmginfo)
		if self.Exploded then return end
		if dmginfo:GetInflictor() == self then return end
		self:TakePhysicsDamage(dmginfo)
		local Dmg = dmginfo:GetDamage()

		if Dmg >= 4 then
			local Pos, State, DetChance = self:GetPos(), self:GetState(), 0
			if (math.random(1, 10) == 3) and (State ~= JMod.EZ_STATE_BROKEN) and (State ~= JMod.EZ_STATE_ARMED) then
				sound.Play("Metal_Box.Break", Pos)
				self:SetState(JMod.EZ_STATE_BROKEN)
				SafeRemoveEntityDelayed(self, 10)
			end
		end
	end

elseif(CLIENT)then
	function ENT:Initialize()
		self.Spoon = JMod.MakeModel(self, "models/jmod/explosives/grenades/firenade/incendiary_grenade_spoon.mdl")
	end

	function ENT:Draw()
		local State = self:GetState()
		self:DrawModel()
		if (State ~= JMod.EZ_STATE_ARMED) and (State ~= JMod.EZ_STATE_ON) then
			local SpoonAng = self:GetAngles()
			SpoonAng:RotateAroundAxis(self:GetUp(), -90)
			JMod.RenderModel(self.Spoon, self:GetPos() - self:GetUp() * 0.4 - self:GetRight() * 0.2, SpoonAng, Vector(1.5, 1.5, 1.5))
		end
	end

	function ENT:Think()
		local State, Pos, Up = self:GetState(), self:GetPos(), self:GetUp()
		if (State == JMod.EZ_STATE_ARMED) then
			local DLight = DynamicLight(self:EntIndex())

			if DLight then
				DLight.Pos = Pos + Up * 5 + Vector(0, 0, 10)
				DLight.r = 255
				DLight.g = 0
				DLight.b = 0
				DLight.Brightness = 1
				DLight.Size = 80
				DLight.Decay = 15000
				DLight.DieTime = CurTime() + .3
				DLight.Style = 0
			end
		end
	end

	language.Add("ent_aboot_gmod_ezcombinenade","EZ Combine Grenade")
end