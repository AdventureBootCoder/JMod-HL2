-- AdventureBoots 2023
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Jackarunda"
ENT.Information = "glhfggwpezpznore"
ENT.PrintName = "EZ Airboat Gun"
ENT.Category = "JMod - EZ HL:2"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.Base = "ent_jack_gmod_ezmachine_base"
---
ENT.Model = "models/aboot/ezgrinder01.mdl"
ENT.Mass = 35
ENT.SpawnHeight = 10
ENT.EZcolorable = false
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)
ENT.EZupgradable = false
ENT.StaticPerfSpecs = {
	MaxDurability = 100,
	MaxAmmo = 100,
	MaxElectricity = 0
}
ENT.DynamicPerfSpecs = {
	Armor = 1
}

local STATE_BROKEN, STATE_OFF, STATE_HELD = -1, 0, 1
---
function ENT:CustomSetupDataTables()
	self:NetworkVar("Float", 0, "Coolant")
	self:NetworkVar("Int", 0, "Ammo")
end

if(SERVER)then
	function ENT:CustomInit()
	end

	function ENT:Use(activator)
		local State = self:GetState()
		local OldOwner = JMod.GetEZowner(self)
		local alt = activator:KeyDown(JMod.Config.General.AltFunctionKey)
		JMod.SetEZowner(self, activator, true)
	end

	function ENT:OnBreak()
	end

	function ENT:OnRepair()
	end
	
	function ENT:OnRemove()
	end
	
	function ENT:Think()
		local State, Time, Prog = self:GetState(), CurTime(), self:GetProgress()
		local SelfPos, SelfUp, SelfRight, Forward = self:GetPos(), self:GetUp(), self:GetRight(), self:GetForward()
		local Phys = self:GetPhysicsObject()

		self:UpdateWireOutputs()

		self:NextThink(CurTime() + .1)
		return true
	end

	function ENT:PostEntityPaste(ply, ent, createdEntities)
		local Time = CurTime()
		JMod.SetEZowner(self, ply, true)
	end

elseif(CLIENT)then
	function ENT:CustomInit()
		self.MaxElectricity = 0
	end

	function ENT:Think()
		--
	end

	function ENT:Draw()
		local Up, Right, Forward, State = self:GetUp(), self:GetRight(), self:GetForward(), self:GetState()
		local SelfPos, SelfAng = self:GetPos(), self:GetAngles()
		--
		self:DrawModel()
		--
		local Obscured = util.TraceLine({start = EyePos(), endpos = MotorPos, filter = {LocalPlayer(), self}, mask = MASK_OPAQUE}).Hit
		local Closeness = LocalPlayer():GetFOV() * (EyePos():Distance(SelfPos))
		local DetailDraw = Closeness < 36000 -- cutoff point is 400 units when the fov is 90 degrees
		local DrillDraw = true
		if State == STATE_BROKEN then 
			DetailDraw = false 
			DrillDraw = false 
		end -- look incomplete to indicate damage, save on gpu comp too

		if (not(DetailDraw)) and (Obscured) then return end -- if player is far and sentry is obscured, draw nothing
		if Obscured then DetailDraw = false end -- if obscured, at least disable details
		
		if DetailDraw then
			if (Closeness < 40000) and (State == STATE_RUNNING) then
				local DisplayAng = SelfAng:GetCopy()
				DisplayAng:RotateAroundAxis(DisplayAng:Forward(), 90)
				DisplayAng:RotateAroundAxis(DisplayAng:Up(), 180)
				local Opacity = math.random(50, 150)
				cam.Start3D2D(SelfPos + Up * 25 + Right * 15, DisplayAng, .15)
					--draw.SimpleTextOutlined("POWER", "JMod-Display",0,0,Color(255,255,255,Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
					--local ElecFrac=self:GetElectricity()/self.MaxElectricity
					--local R,G,B = JMod.GoodBadColor(ElecFrac)
					--draw.SimpleTextOutlined(tostring(math.Round(ElecFrac*100)).."%","JMod-Display",0,-30,Color(R,G,B,Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
				cam.End3D2D()
			end
		end
	end
	language.Add("ent_aboot_gmod_ezpounder","EZ Ground-Pounder")
end