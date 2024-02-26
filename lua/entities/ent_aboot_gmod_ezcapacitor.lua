-- AdventureBoots 2023
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Jackarunda"
ENT.Information = "glhfggwpezpznore"
ENT.PrintName = "EZ Capactior"
ENT.Category = "JMod - EZ HL:2"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.Base = "ent_jack_gmod_ezmachine_base"
---
ENT.Model = "models/hunter/blocks/cube05x1x05.mdl"
ENT.Mass = 50
ENT.SpawnHeight = 10
ENT.JModPreferredCarryAngles = Angle(0, 180, -90)
ENT.EZupgradable = false
ENT.StaticPerfSpecs = {
	MaxDurability = 100,
	MaxElectricity = 100
}
ENT.DynamicPerfSpecs = {
	Armor = 1
}

local STATE_BROKEN, STATE_OFF, STATE_CHARGED, STATE_CHARGING = -1, 0, 1, 2
---

if(SERVER)then
	function ENT:CustomInit()
		--
	end

	function ENT:TurnOn(activator)
		if self:GetState() ~= STATE_OFF then return end

		if (self:GetElectricity() > 0) then
			if IsValid(activator) then self.EZstayOn = true end
			self:SetState(STATE_CHARGING)
		else
			JMod.Hint(activator, "nopower")
		end
	end
	
	function ENT:TurnOff(activator)
		if (self:GetState() <= 0) then return end
		if IsValid(activator) then self.EZstayOn = nil end
		self:SetState(STATE_OFF)
	end

	function ENT:Use(activator)
		local State = self:GetState()
		local OldOwner = self.EZowner
		local alt = activator:KeyDown(JMod.Config.General.AltFunctionKey)
		JMod.SetEZowner(self, activator, true)

		if State == STATE_BROKEN then
			JMod.Hint(activator, "destroyed", self)

			return
		elseif State == STATE_OFF then
			self:TurnOn(activator)
		elseif State >= STATE_CHARGED then
			self:TurnOff(activator)
		end
	end
	
	function ENT:OnRemove()
		--
	end
	
	function ENT:Think()
		local State, Time, Prog = self:GetState(), CurTime(), self:GetProgress()
		--local SelfPos, Up, Right, Forward = self:GetPos(), self:GetUp(), self:GetRight(), self:GetForward()

		self:UpdateWireOutputs()

		self:NextThink(Time + 1)
		return true
	end

	function ENT:PostEntityPaste(ply, ent, createdEntities)
		local Time = CurTime()
		JMod.SetEZowner(self, ply, true)
		ent.NextRefillTime = Time + math.Rand(0, 3)
		ent.NextResourceThinkTime = 0
		ent.NextEffectThinkTime = 0
		ent.NextOSHAthinkTime = 0
	end

elseif(CLIENT)then
	function ENT:CustomInit()
		self.MaxElectricity = 100
	end

	function ENT:Think()
		local State, FT = self:GetState(), FrameTime()
		if State == STATE_CHARGED then
		end
	end

	function ENT:Draw()
		local Up, Right, Forward, Message, State = self:GetUp(), self:GetRight(), self:GetForward(), self:GetMessage(), self:GetState()
		local SelfPos, SelfAng = self:GetPos(), self:GetAngles()
		--
		local Obscured = util.TraceLine({start = EyePos(), endpos = MotorPos, filter = {LocalPlayer(), self}, mask = MASK_OPAQUE}).Hit
		local Closeness = LocalPlayer():GetFOV() * (EyePos():Distance(SelfPos))
		local DetailDraw = Closeness < 36000 -- cutoff point is 400 units when the fov is 90 degrees
		if State == STATE_BROKEN then DetailDraw = false end -- look incomplete to indicate damage, save on gpu comp too
		if Obscured then DetailDraw = false end -- if obscured, at least disable details
		--
		self:DrawModel()
		--
		if DetailDraw then
			if (Closeness < 40000) and (State >= STATE_CHARGED) then
				local Opacity = math.random(50, 150)
				cam.Start3D2D(SelfPos + Forward * 13 + Up * -37 + Right * 9, DisplayAng, .15)
					draw.SimpleTextOutlined("POWER", "JMod-Display",250,-60,Color(255,255,255,Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
					local ElecFrac=self:GetElectricity()/self.MaxElectricity
					local R,G,B = JMod.GoodBadColor(ElecFrac)
					draw.SimpleTextOutlined(tostring(math.Round(ElecFrac*100)).."%","JMod-Display",250,-30,Color(R,G,B,Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
					draw.SimpleTextOutlined(Message, "JMod-Display",250,0,Color(255,255,255,Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
				cam.End3D2D()
			end
		end
	end
	language.Add("ent_aboot_gmod_ezpounder","EZ Ground-Pounder")
end