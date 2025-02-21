
local BallisticDelivery = CreateConVar("jmod_hl2_cannister_delivery", "1", FCVAR_ARCHIVE, "Causes the combine radio to delivery items by headcrab cannister instead of airplane", 0, 1)

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

hook.Add("JMod_OnRadioDeliver", "JMODHL2_CANNISTER_DELIVER", function(stationID, dropPos)
	if not(BallisticDelivery:GetBool()) then return end
	local station = JMod.EZ_RADIO_STATIONS[stationID]
	local Radio = station.lastCaller
	if not(IsValid(Radio) and Radio:GetClass() == "ent_aboot_gmod_ezcombineradio") then return end
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
			Pod:SetKeyValue("spawnflags", 16384)
			Pod:SetKeyValue("spawnflags", 262144)
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
					ThrowStuff(Pod, aBasePos, Tr.MatType)
				end
				local Spod = ents.Create("ent_aboot_cannister")
				Spod:SetPos(aBasePos)
				Spod:SetAngles(RandomAngy)
				Spod.Contents = DeliveryItems
				Spod:Spawn()
				Spod:SetPackageName(station.deliveryType)
			end)
			---
		end)
	end
	return true, (math.random(4, 8) * JMod.Config.RadioSpecs.DeliveryTimeMult)
end)

hook.Add("JMod_RadioDelivery", "JMODHL2_SPEEDYDELIVER", function(ply, transceiver, pkg, DeliveryTime, Pos)
	if not(BallisticDelivery:GetBool()) then return end
	local station = JMod.EZ_RADIO_STATIONS[transceiver:GetOutpostID()]
	if not(IsValid(station.lastCaller) and station.lastCaller:GetClass() == "ent_aboot_gmod_ezcombineradio") then return end
	local Tr = util.QuickTrace(ply:GetPos() + Vector(0, 0, 30), (VectorRand() * Vector(1, 1, 0)) * 300, {ply})
	return (DeliveryTime * .1), ply:GetEyeTrace().HitPos--Tr.HitPos
end)
--[[]
concommand.Add("jmod_hl2_buzz", function(ply, cmd, args) 
	if IsValid(ply) and not ply:IsSuperAdmin() then return end

	local PlyTr = ply:GetEyeTrace()

	local ShootPos = ply:GetShootPos() + Vector(0, 0, 1000)
	local ShootAngle = (PlyTr.HitPos - ShootPos):Angle()

	local BulletNum = 120
	for i = 1, BulletNum do
		timer.Simple((i / BulletNum) * 1.5, function()
			JMod.RicPenBullet(ply, ShootPos, ShootAngle:Forward() + VectorRand() * 0.05, 150, true, true, 1, 1, nil)--"eff_jack_gmod_smallarmstracer")
			ShootAngle:RotateAroundAxis(ShootAngle:Right(), 45 / BulletNum)
			ShootPos = ShootPos + ShootAngle:Forward() * 400 / BulletNum
		end)
	end
	timer.Simple(2, function()
		local FlyPos = PlyTr.HitPos + Vector(0, 0, 2000)
		local FlyVec = PlyTr.Normal
		FlyVec.z = 0
		FlyVec:Normalize()
		local Eff = EffectData()
		Eff:SetOrigin(FlyPos)
		Eff:SetStart(FlyVec * -400)
		local Filter = RecipientFilter()
		Filter:AddAllPlayers()
		util.Effect("eff_jack_gmod_jetflyby", Eff, true, Filter)

		timer.Simple(.1, function()
			if not IsValid(ply) or not ply:Alive() then return end
			
			sound.Play("snd_jack_flyby_drop.mp3", FlyPos, 150, 100)

			for k, playa in pairs(ents.FindInSphere(FlyPos, 6000)) do
				if playa:IsPlayer() then
					local SoundPos = playa:GetShootPos()
					sound.Play("snd_jack_flyby_drop.mp3", SoundPos + (FlyPos - SoundPos) * 10, 50, 100)
				end
			end
		end)
	end)
end, nil, "Airstrike run")
--]]