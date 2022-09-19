AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "EZ Suit Charger"
ENT.Author = "AdventureBoots"
ENT.Category = "JMod - EZ Misc."
ENT.Information = ""
ENT.Base = "ent_jack_gmod_ezmachine_base"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.NoSitAllowed = true
----
ENT.EZconsumes = {JMod.EZ_RESOURCE_TYPES.BASICPARTS, JMod.EZ_RESOURCE_TYPES.POWER}
ENT.EZupgradable = false

local STATE_BROKEN,STATE_EMPTY,STATE_IDLE,STATE_CHARGIN = -1,0,1,2

if(SERVER)then
	function ENT:SpawnFunction(ply,tr)
		local SpawnPos = tr.HitPos
		local Ang = tr.HitNormal:Angle()
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(Ang)
		ent:SetPos(SpawnPos)
		JMod.Owner(ent,ply)
		ent:Spawn()
		ent:Activate()
		ent.Weld = constraint.Weld(ent, tr.Entity, 0, tr.PhysicsBone, 5000, false, false)
		return ent
	end

	function ENT:CustomInit()
		self:SetModel("models/props_combine/suit_charger001.mdl")
		self:SetMaterial("models/aboot/suit_charger002_sheet")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(ONOFF_USE)
		self:SetState(STATE_IDLE)
		self.User=nil
		self.ChargeSound=CreateSound(self,"items/suitcharge1.wav")
	end

	local nextOk = 0
	function ENT:Use(activator,activatorAgain,onOff)
		local Dude=activator or activatorAgain
		local time = CurTime()
		if(self:GetState() < 0)then return end
		if(tobool(onOff))then -- we got pressed
			if((Dude:Armor() < 100) and (self:GetElectricity()>0))then
				if(time > nextOk)then
					nextOk = time + 1
					self:EmitSound("items/suitchargeok1.wav")
				end
				self.ChargeSound:Play()
				self.User=Dude
				self:SetState(STATE_CHARGIN)
			else
				Dude:SetArmor(0)
				self:EmitSound("items/suitchargeno1.wav")
			end
		else -- we were released
			self:TurnOff(true)
		end
	end

	function ENT:Think()
		local time = CurTime()
		local state = self:GetState()
		if(state == STATE_CHARGIN)then
			if((IsValid(self.User)) and (self.User:Alive()) and (self.User:Armor()<100) and (self:GetElectricity()>0))then
				local Tr=self.User:GetEyeTrace()
				if((Tr.Hit)and(Tr.Entity==self))and(self.User:GetShootPos():Distance(self:GetPos()) < 150)then
					self.User:SetArmor(self.User:Armor() + 1)
					self:ConsumeElectricity(1.334)
					if not(self.ChargeSound:IsPlaying())then
						self.ChargeSound:Play()
					end
				else
					self:TurnOff(true)
				end
			else
				self:TurnOff()
			end
		end
		self:NextThink(time + 0.01)
	end

	function ENT:TurnOff(released)
		if(self:GetElectricity() <= 0)then
			self:SetState(STATE_EMPTY)
		else
			self:SetState(STATE_IDLE)
		end
		self.ChargeSound:FadeOut(0.5)
		timer.Simple(0.5, function()
			if(IsValid(self))then
				self.ChargeSound:Stop()
			end
		end)
		if not(released)then 
			self:EmitSound("items/suitchargeno1.wav") 
		end
		self.User=nil
	end

	function ENT:OnRemove()
		self.ChargeSound:Stop()
	end

elseif(CLIENT)then
	function ENT:Initialize()
		local LerpedElec = self:GetElectricity()
		self:AddCallback("BuildBonePositions",function(ent,numbones)
			local ElecFrac = LerpedElec / 100
			local DrainedFraction = 1 - ElecFrac -- this should be a float that goes from 0 to 1 as the device's power is drained
			local Up,Right,Forward=ent:GetUp(),ent:GetRight(),ent:GetForward()
			local Vary=math.sin(CurTime()*12)/5
			-- the booper
			local BooperPos,BooperAng=ent:GetBonePosition(1)
			if(DrainedFraction>=1)then
				ent:SetBonePosition(1,BooperPos-Forward*1.2,BooperAng)
			elseif(self:GetState() == STATE_CHARGIN)then -- this conditional should be true when the device is in use
				ent:SetBonePosition(1,BooperPos-Forward*Vary,BooperAng)
			end
			-- the toober
			local TooberPos,TooberAng=ent:GetBonePosition(2)
			ent:SetBonePosition(2,TooberPos+Up*DrainedFraction*5.75,TooberAng)
			LerpedElec = Lerp(FrameTime()*10, LerpedElec, self:GetElectricity())
		end)
	end
end