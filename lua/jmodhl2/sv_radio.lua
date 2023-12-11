
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

local function SpawnItem(itemClass, pos, owner, resourceAmt)
	local ItemNameParts = string.Explode(" ", itemClass)

	if ItemNameParts and ItemNameParts[1] == "FUNC" then
		if ItemNameParts[2] and JMod.LuaConfig.BuildFuncs[ItemNameParts[2]] then
			JMod.LuaConfig.BuildFuncs[ItemNameParts[2]](owner, pos + Vector(0, 0, 5), Angle(0, 0, 0))
		end
	else
		local Yay = ents.Create(itemClass)
		Yay:SetPos(pos + VectorRand() * math.Rand(0, 30))
		Yay:SetAngles(VectorRand():Angle())
		Yay:Spawn()
		Yay:Activate()

		if resourceAmt then
			Yay:SetResource(resourceAmt)
		end

		if IsValid(Yay) then
			JMod.SetEZowner(Yay, owner)

			-- this arrests overlap-ejection velocity so items don't thwack players
			timer.Simple(.025, function()
				if IsValid(Yay) then
					Yay:GetPhysicsObject():SetVelocity(Vector(0, 0, 0))
				end
			end)

			timer.Simple(.05, function()
				if IsValid(Yay) then
					Yay:GetPhysicsObject():SetVelocity(Vector(0, 0, 0))
				end
			end)

			timer.Simple(.1, function()
				if IsValid(Yay) then
					Yay:GetPhysicsObject():SetVelocity(Vector(0, 0, 0))
				end
			end)
		end
	end
end

local function SpawnContents(contents, pos, owner)
	local typ = type(contents)

	if typ == "string" then
		SpawnItem(contents, pos, owner)

		return
	end

	if typ == "table" then
		for k, v in pairs(contents) do
			typ = type(v)

			if typ == "string" then
				SpawnItem(v, pos, owner)
			elseif typ == "table" then
				-- special case, this is a randomized table
				if v[1] == "RAND" then
					local Amt = v[#v]
					local Items = {}

					for i = 2, #v - 1 do
						table.insert(Items, v[i])
					end

					for i = 1, Amt do
						SpawnItem(table.Random(Items), pos, owner)
					end
				else -- the only other supported table contains a count as [2] and potentially a resourceAmt as [3]
					for i = 1, v[2] or 1 do
						SpawnItem(v[1], pos, owner, v[3] or nil)
					end
				end
			end
		end
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
				end
			end)
			timer.Simple(Delay, function()
				if(IsValid(Pod))then
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

			JMod.NotifyAllRadios(stationID, "good drop")
		end)
	else
		station.nextReadyTime = CurTime() + (math.random(4, 8) * JMod.Config.RadioSpecs.DeliveryTimeMult)
		JMod.NotifyAllRadios(stationID, "drop failed")
	end
	return true
end)

hook.Add("JMod_RadioDelivery", "JMODHL2_SPEEDYDELIVER", function(ply, transceiver, pkg, DeliveryTime, Pos)
	local station = JMod.EZ_RADIO_STATIONS[transceiver:GetOutpostID()]
	if not(IsValid(station.lastCaller) and station.lastCaller:GetClass() == "ent_aboot_gmod_ezcombineradio") then return nil end
	return (DeliveryTime * .1), ply:GetEyeTrace().HitPos
end)