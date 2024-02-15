-- AdventureBoots 2022
AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "EZ Health Charger"
ENT.Author = "AdventureBoots"
ENT.Category = "JMod - EZ HL:2"
ENT.Information = "Magnum Opus"
ENT.Base = "ent_jack_gmod_ezmachine_base"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.NoSitAllowed = true
----
ENT.Model = "models/props_combine/health_charger001.mdl"
ENT.Mat = nil
----
ENT.JModPreferredCarryAngles = Angle(0, 180, 0)
ENT.EZconsumes = {JMod.EZ_RESOURCE_TYPES.BASICPARTS, JMod.EZ_RESOURCE_TYPES.POWER, JMod.EZ_RESOURCE_TYPES.MEDICALSUPPLIES}
ENT.EZupgradable = false
ENT.StaticPerfSpecs = {
	MaxSupplies = 100
}

local STATE_BROKEN,STATE_OFF,STATE_CHARGIN = -1,0,1

function ENT:CustomSetupDataTables()
	self:NetworkVar("Int", 2, "Supplies")
end

if(SERVER)then
	function ENT:SpawnFunction(ply,tr)
		local SpawnPos = tr.HitPos
		local Ang = tr.HitNormal:Angle()
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(Ang)
		ent:SetPos(SpawnPos)
		if JMod.Config.Machines.SpawnMachinesFull then
			ent.SpawnFull = true
		end
		ent:Spawn()
		ent:Activate()
		ent.Weld = constraint.Weld(ent, tr.Entity, 0, tr.PhysicsBone, 50000, false, false)
		return ent
	end

	function ENT:CustomInit()
		self:DrawShadow(false)
		self:SetUseType(ONOFF_USE)
		self.User=nil
		self.ChargeSound=CreateSound(self,"items/medcharge4.wav")
		self:SetSubMaterial(1, "models/aboot/health_charger002")
		if self.SpawnFull then
			self:SetSupplies(self.MaxSupplies)
		else
			self:SetSupplies(0)
		end
	end

	function ENT:Use(activator,activatorAgain,onOff)
		local Dude = mactivator or activatorAgain
		local Time = CurTime()
		local State = self:GetState()
		if (State < STATE_OFF) then
			return
		elseif (State == STATE_OFF) then
			if(tobool(onOff))then -- we got pressed
				if (Dude:Health() < 100) and (self:GetSupplies() > 0) then
					self:TurnOn(Dude)
				elseif self:GetSupplies() <= 0 then
					JMod.Hint(activator, "afh supply")
					self:EmitSound("items/medshotno1.wav")
				else
					self:EmitSound("items/medshotno1.wav")
				end
			end
		elseif (State == STATE_CHARGIN) then
			if not(tobool(onOff)) then -- we were released
				self:TurnOff(true)
			end
		end
	end

	function ENT:Think()
		local Time = CurTime()
		local State = self:GetState()
		if State == STATE_BROKEN then return end
		if State == STATE_CHARGIN then

			if((IsValid(self.User))and(self.User:Alive())and(self.User:Health() < 100)and(self:GetSupplies() > 0))then
				local Tr = self.User:GetEyeTrace()

				if((Tr.Hit) and (Tr.Entity == self))and( self.User:GetShootPos():Distance(self:GetPos()) < 100)then

					if self.User.EZbleeding > 0 then
						self.User:PrintMessage(HUD_PRINTCENTER, "stopping bleeding")
						self.User.EZbleeding = math.Clamp(self.User.EZbleeding - 2 * JMod.Config.Tools.Medkit.HealMult, 0, 9e9)
						self:ConsumeSupplies(.5)
					else
						self.User:SetHealth(self.User:Health() + 1)
						self:ConsumeSupplies(1.5)
					end
				else
					self:TurnOff(true)
				end
			else
				self:TurnOff()
			end
		end
		self:NextThink(Time + .1)
		return true
	end

	function ENT:ConsumeSupplies(amt)
		local newAmt = math.Clamp(self:GetSupplies() - amt, 0, self.MaxSupplies)
		--print(newAmt)
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
		if not(released)then self:EmitSound("items/medshotno1.wav") end
		self.User=nil
	end

	local nextOk = 0
	function ENT:TurnOn(dude)
		if self:GetState() > STATE_OFF then return end
		local Time = CurTime()
		if(Time > nextOk)then
			nextOk = Time + 1
			self:EmitSound("items/medshot4.wav")
		end
		self.ChargeSound:Play()
		self.User = dude
		self:SetState(STATE_CHARGIN)
	end

	function ENT:OnRemove()
		self.ChargeSound:Stop()
	end

elseif(CLIENT)then
	function ENT:Initialize()
		local LerpedSupplies = 0
		self:AddCallback("BuildBonePositions", function(ent, numbones)
			local SupplyFrac = LerpedSupplies / 100
			local DrainedFraction = 1 - SupplyFrac
			local Pos, Ang = ent:GetBonePosition(0)
			local Up, Right, Forward = Ang:Up(), Ang:Right(), Ang:Forward()
			--local Vary = math.sin(CurTime()*12)/2+.5
			-- the spinner
			if not(ent:GetBoneName(1)) then
				return
			end
			if(DrainedFraction <= 0.98)then
				local SpinAng = Ang:GetCopy()
				SpinAng:RotateAroundAxis(Up, 360 * DrainedFraction)
				ent:SetBonePosition(2, Pos - Right *5.25 + Up * (6 - DrainedFraction * 5) + Forward * 2.5, SpinAng)
			else
				ent:SetBonePosition(2, Pos-Right * 5.25 + (Up * 0.85) + Forward * 2.5, Ang)
			end
			-- the healthbar (I'll figure it out eventually)
			if ent:GetBoneMatrix(1) then
				local MacTheMatrix = Matrix()
				local BarAng = Ang:GetCopy()
				BarAng:RotateAroundAxis(Forward, -90)
				BarAng:RotateAroundAxis(Right, 90)
				--MacTheMatrix:Translate(Pos + Up * 5.5 + Forward * (7 - DrainedFraction * 6) + Right * 1.1)
				MacTheMatrix:Translate(Pos + Up * 6.2 + Forward * 7 + Right * 1.12)
				MacTheMatrix:Rotate(BarAng)
				MacTheMatrix:Scale(Vector(1, DrainedFraction * -10, 1))
				ent:SetBoneMatrix(1, MacTheMatrix)
				LerpedSupplies = Lerp(math.ease.OutCubic(FrameTime() * 5), LerpedSupplies, self:GetSupplies())
			end
		end)
	end
end
