-- Jackarunda 2021
AddCSLuaFile()
ENT.Base = "ent_jack_gmod_ezgrenade"
ENT.Author = "AdventureBoots"
ENT.PrintName = "EZ Signal Beacon"
ENT.Category = "JMod - EZ HL:2"
ENT.Spawnable = false
ENT.Model = "models/jmod/explosives/grenades/impactnade/impact_grenade.mdl"
ENT.SpoonModel = "models/jmod/explosives/grenades/impactnade/impact_grenade_cap.mdl"
ENT.SpoonSound = "physics/cardboard/cardboard_box_impact_soft2.wav"
ENT.SpoonBodygroup = {2, 1}
ENT.DetDelay = 2
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)
ENT.JModGUIcolorable = true

if SERVER then
	function ENT:Use(activator, activatorAgain, onOff)
		if self.Exploded then return end
		local Dude = activator or activatorAgain
		JMod.SetEZowner(self, Dude)
		local Time = CurTime()

		if tobool(onOff) then
			local State = self:GetState()
			if State < 0 then return end
			local Alt = JMod.IsAltUsing(Dude)

			if State == JMod.EZ_STATE_OFF and Alt then
				JMod.SetEZowner(self, Dude)
				net.Start("JMod_ColorAndArm")
					net.WriteEntity(self)
				net.Send(Dude)
			end

			JMod.ThrowablePickup(Dude, self, self.HardThrowStr, self.SoftThrowStr)
		end
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		local Tr = util.QuickTrace(self:GetPos(), Vector(0, 0, -5), {self})

		if Tr.Hit then
			self.Weld = constraint.Weld(Tr.Entity, self, 0, 0, 1000, true, false)
		end
		self.FuelLeft = 100
		self:EmitSound("snd_jack_fragsplodeclose.ogg", 70, 150)
	end

	function ENT:CustomThink(State, Time)
		if self.Exploded then
			self:EmitSound("snd_jack_sss.wav", 55, 80)
			self.FuelLeft = self.FuelLeft - .5

			if self.FuelLeft <= 0 then
				SafeRemoveEntityDelayed(self, 1)
			end
		end
	end
elseif CLIENT then
	local BeamMat = Material("cable/physbeam")
	local GlowSprite = Material("sprites/mat_jack_basicglow")

	function ENT:Initialize() 
		self.BeaconProg = -2000
	end

	function ENT:Think()
		if self:GetState() == JMod.EZ_STATE_ARMED then
			self.BeaconProg = math.Clamp(self.BeaconProg + FrameTime() * 2000, -2000, 5000)
		end
	end

	function ENT:Draw()
		self:DrawModel()

		local State = self:GetState()
		if State == JMod.EZ_STATE_ARMED then
			local Col = self:GetColor()
			local SelfPos, Forward, Right, Up = self:GetPos(), self:GetForward(), self:GetRight(), self:GetUp()
			render.SetMaterial(GlowSprite)
			local SpritePos = SelfPos
			local Vec = (SpritePos - EyePos()):GetNormalized()
			render.DrawSprite(SpritePos - Vec * 5, 30, 30, Col)
			render.DrawSprite(SpritePos - Vec * 5, 15, 15, Color(255, 255, 255, 150))
		end
	end

	local BeaconAnim = 0

	hook.Add("PostDrawTranslucentRenderables", "JMod_EZ_SignalBeacon", function()
		for _, beacon in pairs(ents.FindByClass("ent_aboot_gmod_ezcombinebeacon")) do
			local Ply = LocalPlayer()
			local State = beacon:GetState()
			if State == JMod.EZ_STATE_ARMED then
				local Pos, Ang = beacon:GetPos(), beacon:GetAngles()
				local Dir = Vector(0, 0, 1)

				local Tr = util.QuickTrace(Pos, Dir * beacon.BeaconProg, {beacon, Ply})
				local Pos2 = Tr.HitPos
				local Col = beacon:GetColor()
				local DistSightBuff = Ply:GetFOV() * Ply:EyePos():Distance(Pos) / 5000
				render.SetMaterial(BeamMat)
				--render.SetColorModulation(Col.r / 255, Col.g / 255, Col.b / 255)
				render.DrawBeam(Pos, Pos2, 20 + DistSightBuff, BeaconAnim, BeaconAnim + 1, Col)
				render.SetMaterial(GlowSprite)
				render.DrawSprite(Pos2 - (Pos2 - EyePos()):GetNormalized() * 5, 50 + DistSightBuff, 50 + DistSightBuff, Col)
				BeaconAnim = BeaconAnim - 0.01 * FrameTime()

				if BeaconAnim < -1 then
					BeaconAnim = 0
				end
			end
		end
	end)

	language.Add("ent_aboot_gmod_ezcombinebeacon", "EZ Signal Beacon")
end
