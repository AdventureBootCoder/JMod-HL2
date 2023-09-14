-- AdventureBoots 2023
AddCSLuaFile()
ENT.Base="ent_jack_gmod_ezgrenade"
ENT.Author="AdventureBoots"
ENT.PrintName="EZ Combine Grenade"
ENT.Category="JMod - EZ HL:2"
ENT.Spawnable=false
ENT.JModPreferredCarryAngles=Angle(0,100,0)
ENT.Model="models/weapons/w_grenade.mdl"
--ENT.Material=""
ENT.HardThrowStr=350
ENT.SoftThrowStr=250
ENT.SpoonScale=2
if(SERVER)then
	function ENT:Prime()
		self:SetState(JMod.EZ_STATE_PRIMED)
		self:EmitSound("weapons/pinpull.wav", 60, 100)
		self:SetBodygroup(3, 1)
	end
	function ENT:Arm()
		self:SetBodygroup(2, 1)
		self:SetState(JMod.EZ_STATE_ARMED)
		self:SpoonEffect()
		timer.Simple(4, function()
			if(IsValid(self))then self:Detonate() end
		end)
	end
	function ENT:Detonate()
		if(self.Exploded)then return end
		self.Exploded=true
		local SelfPos=self:GetPos()
		local PowerMult=0.69
		JMod.Sploom(self.Owner,self:GetPos(),150,400)
		JMod.BlastDoors(self.Owner, self:GetPos(), 100, 445, false)
		self:EmitSound("snd_jack_fragsplodeclose.wav",90,100)
		local plooie=EffectData()
		plooie:SetOrigin(SelfPos)
		plooie:SetScale(0.5)
		util.Effect("eff_jack_plastisplosion",plooie,true,true)
		util.ScreenShake(SelfPos,99999,99999,1,750*1.75)
		local OnGround=util.QuickTrace(SelfPos+Vector(0,0,5),Vector(0,0,-15),{self}).Hit
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
	function ENT:Draw()
		self:DrawModel()
	end
	language.Add("ent_aboot_gmod_ezcombinenade","EZ Standered Overwatch Grenade")
end