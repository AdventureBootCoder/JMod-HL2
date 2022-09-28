AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "EZ Health Charger"
ENT.Author = "AdventureBoots"
ENT.Category = "JMod - EZ HL:2"
ENT.Information = ""
ENT.Base = "ent_jack_gmod_ezmachine_base"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.NoSitAllowed = true
----
ENT.Model = "models/props_combine/health_charger001.mdl"
ENT.Mat = nil
----
ENT.EZconsumes = {JMod.EZ_RESOURCE_TYPES.BASICPARTS, JMod.EZ_RESOURCE_TYPES.POWER, JMod.EZ_RESOURCE_TYPES.MEDICALSUPPLIES}
ENT.EZupgradable = false
ENT.StaticPerfSpecs = {
	MaxSupplies = 100
}

local STATE_BROKEN,STATE_OFF,STATE_CHARGIN = -1,0,1

function ENT:CustomSetupDataTables()
	self:NetworkVar("Int",2,"Supplies")
end

if(SERVER)then
	function ENT:SpawnFunction(ply,tr)
		local SpawnPos = tr.HitPos
		local Ang = tr.HitNormal:Angle()
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(Ang)
		ent:SetPos(SpawnPos)
		ent:Spawn()
		ent:Activate()
		ent.Weld = constraint.Weld(ent, tr.Entity, 0, tr.PhysicsBone, 50000, false, false)
		return ent
	end

	function ENT:CustomInit()
		self:DrawShadow(false)
		self:SetUseType(ONOFF_USE)
		self:SetSupplies(self.MaxSupplies)
		self.User=nil
		self.ChargeSound=CreateSound(self,"items/suitcharge1.wav")
		self:SetSubMaterial(1, "models/aboot/health_charger002")
	end

	function ENT:Use(activator,activatorAgain,onOff)
		local Dude=activator or activatorAgain
		local Time=CurTime()
		local State=self:GetState()
		if(State<0)then
			return
		elseif(State==STATE_OFF)then
			if(tobool(onOff))then -- we got pressed
				if((Dude:Health()<100)and(self:GetElectricity()>0)and(self:GetSupplies()>0))then
					self:TurnOn(Dude)
				else
					self:EmitSound("items/suitchargeno1.wav")
				end
			end
		elseif(State==STATE_CHARGIN)then
			if not(tobool(onOff))then -- we were released
				self:TurnOff(true)
			end
		end
	end

	function ENT:Think()
		local Time=CurTime()
		local State=self:GetState()
		if(State==STATE_CHARGIN)then
			if((IsValid(self.User))and(self.User:Alive())and(self.User:Health()<100)and(self:GetElectricity()>0)and(self:GetSupplies()>0))then
				local Tr=self.User:GetEyeTrace()
				if((Tr.Hit)and(Tr.Entity==self))and(self.User:GetShootPos():Distance(self:GetPos())<70)then
					self.User:SetHealth(self.User:Health()+1)
					self:ConsumeElectricity(0.656)
					self:ConsumeSupplies(1.334)
				else
					self:TurnOff(true)
				end
			else
				self:TurnOff()
			end
		end
		self:NextThink(Time+.1)
		return true
	end

	function ENT:ConsumeSupplies(amt)
		local newAmt = math.Clamp(self:GetSupplies() - amt, 0, self.MaxSupplies)
		self:SetSupplies(newAmt)
		if(self:GetSupplies() <= 0)then
			self:TurnOff()
		end
	end

	function ENT:TurnOff(released)
		self:SetState(STATE_OFF)
		self.ChargeSound:FadeOut(.5)
		timer.Simple(0.5, function()
			if(IsValid(self))then self.ChargeSound:Stop() end
		end)
		if not(released)then self:EmitSound("items/suitchargeno1.wav") end
		self.User=nil
	end

	local nextOk=0
	function ENT:TurnOn(dude)
		local Time=CurTime()
		if(Time>nextOk)then
			nextOk=Time+1
			self:EmitSound("items/suitchargeok1.wav")
		end
		self.ChargeSound:Play()
		self.User=dude
		self:SetState(STATE_CHARGIN)
	end

	function ENT:OnRemove()
		self.ChargeSound:Stop()
	end

elseif(CLIENT)then
	function ENT:Initialize()
		local LerpedElec=0
		self:AddCallback("BuildBonePositions",function(ent,numbones)
			local ElecFrac = LerpedElec / 100
			LerpedElec=Lerp(math.ease.OutCubic(FrameTime()*5),LerpedElec,self:GetElectricity())
		end)
	end
end
