-- Jackarunda 2021
AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_gmod_ezaidradio"
ENT.PrintName = "EZ Combine Radio"
ENT.Author = "AdventureBoots"
ENT.Category = "JMod - EZ HL:2"
ENT.Information = "glhfggwpezpznore"
ENT.Spawnable = false
ENT.AdminSpawnable = true
ENT.NoSitAllowed = true
ENT.Model = "models/props_combine/breenconsole.mdl"
--ENT.Mat = "models/mat_jack_gmod_ezradio"
ENT.Mass = 150
----
ENT.JModPreferredCarryAngles = Angle(0,0,0)
ENT.SpawnHeight = 20
ENT.EZradio = true
----
ENT.StaticPerfSpecs = {
	MaxDurability = 100,
	Armor = 1
}
----
local STATE_BROKEN,STATE_OFF,STATE_CONNECTING=-1,0,1
if(SERVER)then
	--- I'm basically inheriting everything here

elseif(CLIENT)then
	function ENT:CustomInit()
		self.Dish = JMod.MakeModel(self,"models/props_rooftop/satellitedish02.mdl")
		self.Panel = JMod.MakeModel(self,"models/props_lab/reciever01a.mdl",nil,.8)
		self.Headset = JMod.MakeModel(self,"models/lt_c/sci_fi/headset_2.mdl")
		self.MaxElectricity = 100
		local Files, Folders = file.Find("sound/npc/combine_soldier/vo/*.wav","GAME")
		self.Voices = Files
	end

	local function ColorToVector(col)
		return Vector(col.r / 255, col.g / 255, col.b / 255)
	end

	local GlowSprite, StateMsgs = Material("sprites/mat_jack_basicglow"), {
		[STATE_CONNECTING] = "Connecting...",
		[JMod.EZ_STATION_STATE_READY] = "Ready",
		[JMod.EZ_STATION_STATE_DELIVERING] = "Delivering",
		[JMod.EZ_STATION_STATE_BUSY] = "Busy"
	}

	function ENT:Draw()
		local SelfPos, SelfAng, State = self:GetPos(), self:GetAngles(), self:GetState()
		local Up, Right, Forward, FT = SelfAng:Up(), SelfAng:Right(), SelfAng:Forward(), FrameTime()
		---
		local BasePos = SelfPos + Up * 32

		local Obscured = util.TraceLine({
			start = EyePos(),
			endpos = BasePos,
			filter = {LocalPlayer(), self},
			mask = MASK_OPAQUE
		}).Hit

		local Closeness = LocalPlayer():GetFOV() * EyePos():Distance(SelfPos)
		local DetailDraw = Closeness < 36000 -- cutoff point is 400 units when the fov is 90 degrees
		if (not DetailDraw) and Obscured then return end -- if player is far and sentry is obscured, draw nothing

		-- if obscured, at least disable details
		if Obscured then
			DetailDraw = false
		end

		-- look incomplete to indicate damage, save on gpu comp too
		if State == STATE_BROKEN then
			DetailDraw = false
		end

		---
		self:DrawModel()
		---
		local DishAng = SelfAng:GetCopy()
		DishAng:RotateAroundAxis(Right, 20)
		JMod.RenderModel(self.Dish, BasePos + Up * 8 + Forward * 8, DishAng, nil, Vector(.7, .7, .7))

		---
		if DetailDraw then
			local PanelAng = SelfAng:GetCopy()
			PanelAng:RotateAroundAxis(Right, 90)
			JMod.RenderModel(self.Panel, BasePos - Up * 15 - Forward * 6, PanelAng, nil, Vector(.7, .7, .7))
			---
			local HeadsetAng = SelfAng:GetCopy()
			HeadsetAng:RotateAroundAxis(Right, -110)
			JMod.RenderModel(self.Headset, BasePos - Up * 4, HeadsetAng, nil, ColorToVector(self:GetColor()))
			---

			if (Closeness < 20000) and (State > 0) then
				local DisplayAng = SelfAng:GetCopy()
				DisplayAng:RotateAroundAxis(DisplayAng:Right(), 80)
				DisplayAng:RotateAroundAxis(DisplayAng:Up(), -90)
				local Opacity = math.random(50, 150)
				cam.Start3D2D(SelfPos + Up * 38 - Forward * 5, DisplayAng, .075)

				if State > 1 then
					draw.SimpleTextOutlined("Connected to:", "JMod-Display", 0, 0, Color(255, 255, 255, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0, 0, 0, Opacity))
					draw.SimpleTextOutlined("J.I. Radio Outpost " .. self:GetOutpostID(), "JMod-Display", 0, 40, Color(255, 255, 255, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0, 0, 0, Opacity))
				end

				local ElecFrac = self:GetElectricity() / self.MaxElectricity
				local R, G, B = JMod.GoodBadColor(ElecFrac)
				draw.SimpleTextOutlined("Power: " .. math.Round(ElecFrac * 100) .. "%", "JMod-Display", 0, 70, Color(R, G, B, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0, 0, 0, Opacity))
				draw.SimpleTextOutlined(StateMsgs[State], "JMod-Display", 0, 100, Color(255, 255, 255, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0, 0, 0, Opacity))

				if State == JMod.EZ_STATION_STATE_READY then
					draw.SimpleTextOutlined('say "supply radio: help"', "JMod-Display-S", 0, 140, Color(255, 255, 255, Opacity / 2), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, Opacity / 2))
				end

				cam.End3D2D()
			end
		end
	end

	language.Add("ent_aboot_gmod_ezcombineradio", "EZ Combine Radio")
end
