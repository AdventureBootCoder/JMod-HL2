-- Jackarunda 2021
AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_gmod_ezaidradio"
ENT.PrintName = "EZ Combine Radio"
ENT.Author = "AdventureBoots"
ENT.Category = "JMod - EZ HL:2"
ENT.Information = "glhfggwpezpznore"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.NoSitAllowed = true
ENT.Model = "models/props_combine/breenconsole.mdl"
ENT.Mat = "models/aboot/combine/combine_radio001"
ENT.Mass = 150
ENT.EZcolorable = false
----
ENT.JModPreferredCarryAngles = Angle(0,-90,0)
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
	function ENT:TryFindSky()
		local SelfPos = self:LocalToWorld(Vector(0, 0, 50))

		for i = 1, 3 do
			local Dir = self:LocalToWorldAngles(Angle(-165 + i * 25, 90, 0)):Forward()

			local HitSky = util.TraceLine({
				start = SelfPos,
				endpos = SelfPos + Dir * 9e9,
				filter = {self},
				mask = MASK_OPAQUE
			}).HitSky

			if HitSky then return true end
		end

		return false
	end
elseif(CLIENT)then
	function ENT:CustomInit()
		self.Dish = JMod.MakeModel(self,"models/props_rooftop/satellitedish02.mdl")
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
		local BasePos = SelfPos + Up * 50

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
		--local DishAng = SelfAng:GetCopy()
		--DishAng:RotateAroundAxis(Right, 20)
		--DishAng:RotateAroundAxis(Up, 90)
		--JMod.RenderModel(self.Dish, BasePos + Up * 8 + Forward * 8, DishAng, nil, Vector(.7, .7, .7))
		--
		--local DebugPos = self:LocalToWorld(Vector(0, 0, 50))
		--for i = 1, 5 do
		--	local Dir = self:LocalToWorldAngles(Angle(-165 + i * 25, 90, 0)):Forward()
			--debugoverlay.Line(DebugPos, Dir * 9e9, 1, Color(255, 255, 255), false)
		--end

		---
		if DetailDraw then
			local HeadsetAng = SelfAng:GetCopy()
			HeadsetAng:RotateAroundAxis(Right, -130)
			HeadsetAng:RotateAroundAxis(Up, 90)
			HeadsetAng:RotateAroundAxis(HeadsetAng:Forward(), 30)
			JMod.RenderModel(self.Headset, BasePos - Up * 7 - Forward * 15, HeadsetAng, nil, ColorToVector(self:GetColor()))
			---

			if (Closeness < 20000) and (State > 0) then
				local DisplayAng = SelfAng:GetCopy()
				DisplayAng:RotateAroundAxis(DisplayAng:Up(), 0)
				DisplayAng:RotateAroundAxis(DisplayAng:Forward(), 45)
				local Opacity = math.random(50, 150)
				cam.Start3D2D(SelfPos + Up * 45 + Right * 5, DisplayAng, .075)

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

local function FindEZradios() 
	local Radios = {}
	for _, v in ipairs(ents.GetAll()) do
		if v.EZradio == true then
			table.insert(Radios, v)
		end
	end

	return Radios
end

local function NotifyAllRadios(stationID, msgID, direct)
	local Station = JMod.EZ_RADIO_STATIONS[stationID]

	for _, v in ipairs(FindEZradios()) do
		if v:GetState() > 0 and v:GetOutpostID() == stationID then
			if msgID then
				if direct then
					v:Speak(msgID)
				else
					if v.BFFd then
						v:Speak(NotifyAllMsgs["bff"][msgID])
					else
						v:Speak(NotifyAllMsgs["normal"][msgID])
					end
				end
			end

			v:SetState(Station.state)
		end
	end
end

local ModelTable={
	[1]="models/props_debris/concrete_chunk03a.mdl",
	[2]="models/props_debris/concrete_chunk04a.mdl",
	[3]="models/props_debris/concrete_chunk02a.mdl",
	[4]="models/props_debris/concrete_chunk05g.mdl",
}
local MaterialTable={
	[MAT_CONCRETE]="models/props_debris/plasterwall021a",
	[MAT_DIRT]="models/props_foliage/tree_deciduous_01a_trunk",
	[MAT_SAND]="models/props_foliage/tree_deciduous_01a_trunk"
}
local function ThrowStuff(Pod, Position, GroundType)
	if(GroundType==MAT_METAL)then return end
	local ChunkMaterial="models/props_debris/plasterwall021a"
	if(MaterialTable[GroundType])then
		ChunkMaterial=MaterialTable[GroundType]
	end
	for i=0,15 do
		local Chunk=ents.Create("prop_physics")
		Chunk:SetModel(ModelTable[math.random(1,4)])
		Chunk:SetPos(Position)
		Chunk:SetMaterial(ChunkMaterial)
		Chunk:Spawn()
		Chunk:Activate()
		Chunk:GetPhysicsObject():SetMass(75)
		Chunk:GetPhysicsObject():SetVelocity(Vector(0,0,math.Rand(100,1000))+VectorRand()*math.Rand(100,1000))
		SafeRemoveEntityDelayed(Chunk,math.Rand(10,20))
	end
end

hook.Add("JMod_OnRadioDeliver", "JMODHL2_CANNISTER_DELIVER", function(station, dropPos)
	local Radio = station.lastCaller
	if not(IsValid(station.lastCaller) and station.lastCaller:GetClass() == "ent_aboot_gmod_ezcombineradio") then return nil end
	local Delay = 4
	local YawIncrement = 20
	local PitchIncrement = 10
	--
	local Tr = util.TraceLine({start = dropPos, endpos = dropPos + Vector(0, 0, -9e9), mask = MASK_SOLID_BRUSHONLY, filter = {Radio}})
	local aBaseAngle = Tr.HitNormal:Angle()
	local aBasePos = Tr.HitPos + station.outpostDirection * 100
	local bScanning = true
	local iPitch = 10
	local iYaw =- 180
	local iLoopLimit = 0
	local iProcessedTotal = 0
	local tValidHits = {}
	while((bScanning == true)and(iLoopLimit < 500))do
		iYaw=iYaw+YawIncrement
		iProcessedTotal=iProcessedTotal+1
		if(iYaw>=180)then
			iYaw=-180
			iPitch=iPitch-PitchIncrement
		end
		local tLoop = util.QuickTrace(aBasePos,(aBaseAngle + Angle(iPitch, iYaw, 0)):Forward() * 40000)
		if(tLoop.HitSky)then
			table.insert(tValidHits, tLoop)
		end
		if(iPitch <= -80)then
			bScanning = false
		end
		iLoopLimit = iLoopLimit + 1
	end
	local iHits = table.Count(tValidHits)
	if (iHits > 0) then
		local iRand = math.random(1, iHits)
		local tRand = tValidHits[iRand]
		
		local DeliveryItems = JMod.Config.RadioSpecs.AvailablePackages[station.deliveryType].results
		timer.Simple(.9, function()
			local Pod = ents.Create("env_headcrabcanister")
			Pod:SetPos(aBasePos)
			local RandomAngy = (tRand.HitPos-tRand.StartPos):Angle()
			Pod:SetAngles(RandomAngy)
			Pod:SetKeyValue("HeadcrabType", 2)
			Pod:SetKeyValue("HeadcrabCount", 0)
			Pod:SetKeyValue("FlightSpeed", 7500)
			Pod:SetKeyValue("FlightTime", 4)
			Pod:SetKeyValue("Damage", 75)
			Pod:SetKeyValue("DamageRadius", 300)
			Pod:SetKeyValue("SmokeLifetime", 10)
			Pod:SetKeyValue("StartingHeight", 1500)
			Pod:SetKeyValue("spawnflags", 8192)
			Pod:Spawn()
			Pod:Input("FireCanister",ply,ply)
			local Explode = ents.Create("env_explosion")
			Explode:SetOwner(Pod)
			Explode:SetPos(aBasePos)
			Explode:SetKeyValue("iMagnitude", "10")
			Explode:Spawn()
			Explode:Activate()
			Explode:Fire("Explode", "", Delay)
			timer.Simple(Delay, function()
				if(IsValid(Pod))then
					util.ScreenShake(aBasePos, 5000, 99, 5, 500)
				end
			end)
			timer.Simple(Delay, function()
				if(IsValid(Pod))then
					ThrowStuff(Pod, aBasePos, Tr.MatType)
				end
			end)
			timer.Simple(Delay + 0.5, function()
				local Box = ents.Create("ent_jack_aidbox")
				Box:SetPos(aBasePos + RandomAngy:Forward() * 200)
				Box.InitialVel = Vector(0, 0, 0)
				Box.Contents = DeliveryItems
				Box.NoFadeIn = true
				Box:SetDTBool(0, false)
				Box:Spawn()
				Box:SetPackageName(station.deliveryType)
			end)
			---

			NotifyAllRadios(stationID, "good drop")
		end)
	else
		station.nextReadyTime = CurTime() + (math.random(4, 8) * JMod.Config.RadioSpecs.DeliveryTimeMult)
		NotifyAllRadios(stationID, "drop failed")
	end
	return true
end)

hook.Add("JMod_RadioDelivery", "JMODHL2_SPEEDYDELIVER", function(ply, transceiver, pkg, DeliveryTime, Pos)
	local station = JMod.EZ_RADIO_STATIONS[transceiver:GetOutpostID()]
	if not(IsValid(station.lastCaller) and station.lastCaller:GetClass() == "ent_aboot_gmod_ezcombineradio") then return nil end
	return 5, Pos
end)
