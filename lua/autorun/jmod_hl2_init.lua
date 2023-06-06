
JModHL2 = JModHL2 or {}

for i, f in pairs(file.Find("jmodhl2/*.lua", "LUA")) do
	if string.Left(f, 3) == "sv_" then
		if SERVER then
			include("jmodhl2/" .. f)
		end
	elseif string.Left(f, 3) == "cl_" then
		if CLIENT then
			include("jmodhl2/" .. f)
		else
			AddCSLuaFile("jmodhl2/" .. f)
		end
	elseif string.Left(f, 3) == "sh_" then
		AddCSLuaFile("jmodhl2/" .. f)
		include("jmodhl2/" .. f)
	else
		print("JMod[HL2] detected unaccounted-for lua file '" .. f .. "'-check prefixes!")
	end
end

local tag = "aboot_jumpmod"
local tag_counter = tag .. "_counter"

JModHL2.EZ_JUMPSNDS = {
	READY    = tag .. "/jumpmod_ready.wav",
	DENY     = tag .. "/jumpmod_deny.wav",
	BOOST1   = tag .. "/jumpmod_boost1.wav",
	BOOST2   = tag .. "/jumpmod_boost2.wav",
	FALL     = tag .. "/jumpmod_fall.wav",
	LONGFALL = tag .. "/jumpmod_long1.wav",
	BREAK    = tag .. "/jumpmod_break.wav"
}

if(SERVER)then
	for k,v in ipairs(JModHL2.EZ_JUMPSNDS) do
		resource.AddSingleFile("sound/" .. v)
	end

	util.AddNetworkString("ABoot_ContainerMenu")
	util.AddNetworkString("ABoot_VolumeContainerMenu")
	util.AddNetworkString("ABoot_JumpmodParticles")
	local defaultHEVdisable = CreateConVar("aboot_disable_hev", "0", FCVAR_ARCHIVE, "Removes the HEV suit from players on spawn and when it's destroyed. \nNo more running around with an invisible HEV suit")

	local function RemoveHEVsuit(playa) 
		playa:SetArmor(0)
		if playa:IsSuitEquipped() then
			playa:RemoveSuit()
		end
	end

	local NextMainThink, NextArmorThink = 0, 0

	hook.Add("PlayerSpawn", "ABootHL2PlySpawn", function(playa)
		if defaultHEVdisable:GetBool() then
			RemoveHEVsuit(playa)
		end
	end)

	hook.Add("PlayerDeath", tag, function(ply)
		ply:SetNW2Float(tag_counter, 0)
	end)

	hook.Add("JModHookEZArmorSync", "ABootHL2ArmorCheck", function(playa)
		if playa.EZarmor.effects and playa.EZarmor.effects.HEVsuit then
			if not(playa:IsSuitEquipped()) then
				playa:EquipSuit()
			end
		elseif defaultHEVdisable:GetBool() and playa:IsSuitEquipped() then
			RemoveHEVsuit(playa)
		end
		for id, items in pairs(playa.EZarmor.items) do
			if JMod.ArmorTable[items.name].HEVreq then
				if not (playa.EZarmor.effects and playa.EZarmor.effects.HEVsuit) then
					playa:PrintMessage(HUD_PRINTCENTER, "This armor requires an HEV suit")
					JMod.RemoveArmorByID(playa, id)
				end
			end
		end
	end)

	local NextArmorThink = 0
	--hook.Remove("Think", "JMOD_HL2_THINK")
	hook.Add("Think", "JMOD_HL2_THINK", function()
		local Time = CurTime()

		for k, ply in ipairs(player.GetAll()) do
			if not(ply.EZarmor and ply.EZarmor.effects and ply.EZarmor.effects.jumpmod) then continue end

			local val = math.Clamp(ply:GetNW2Float(tag_counter, 3) + FrameTime() * 0.35, 0, 3)
			ply.charging = ply.charging or false

			if val < 1 then
				ply.EZjumpmod_usealert = true
			elseif val >= 1 and ply.EZjumpmod_usealert then
				ply.EZjumpmod_usealert = nil
				ply:SendLua([[surface.PlaySound("]] .. JModHL2.EZ_JUMPSNDS.READY .. [[")]])
			end

			if (GetConVar("gmod_suit"):GetBool()) and (ply:GetSuitPower() >= 1) and (val < 3) then
				ply.charging = true
				if (ply:GetSuitPower() >= 1.25) then
					ply:SetSuitPower(math.Clamp(ply:GetSuitPower() - .25, 0, 100))
				else
					ply.charging = false
				end
			elseif (val < 3) then
				if NextArmorThink < Time then
					NextArmorThink = Time + 2

					for id, armorData in pairs(ply.EZarmor.items) do
						local Info = JMod.ArmorTable[armorData.name]

						if Info.eff and Info.eff.jumpmod then
							armorData.chrg.power = math.Clamp(armorData.chrg.power - (1 * JMod.Config.Armor.ChargeDepletionMult), 0, Info.chrg.power)

							if armorData.chrg.power <= Info.chrg.power * .25 then
								JMod.EZarmorWarning(ply, "Jump module charge is low ("..tostring(armorData.chrg.power).."/"..tostring(Info.chrg.power)..")")
							end

							if armorData.chrg.power > 0 then 
								ply.charging = true
							else
								ply.charging = false
							end

							break
						end
					end
				end
			end
			if ply.charging == true then
				ply:SetNW2Float(tag_counter, val)
			end
		end
	end)

	concommand.Add("aboot_debug", function(ply, cmd, args) 
		if not GetConVar("sv_cheats"):GetBool() then return end
		local EyeTrace = ply:GetEyeTrace()
		local EffectSpot = EyeTrace.HitPos + Vector(0, 0, 20)
		local Poof = EffectData()
		Poof:SetNormal(Vector(0, 0, -1))
		Poof:SetScale(1)
		Poof:SetOrigin(EffectSpot)
		Poof:SetStart(Vector(0, 0, -10))
		util.Effect("eff_aboot_gmod_ezjumppoof", Poof, true)
		EmitSound(JModHL2.EZ_JUMPSNDS.BOOST1, EffectSpot, -1)
	end, nil, "Debug testing command")

elseif CLIENT then 

	local simpleWeaponSelect = CreateConVar("aboot_simple_weapon_select", "1", FCVAR_ARCHIVE, "Enables a vey crude weapon select stand in for when you don't have an HEV suit. It's recomended you get a better one.")

	--hook.Remove("RenderScreenspaceEffects", "HL2CombineBinoculars")
	--[[hook.Add( "RenderScreenspaceEffects", "HL2CombineBinoculars", function()
		playa = LocalPlayer()
		if playa:KeyDown(IN_ZOOM) and playa:IsSuitEquipped() then
			DrawMaterialOverlay( "effects/combine_binocoverlay.vtf", -0.06 )
		end
	end)]]--

	-- Since weapons aren't guranteed to be in proper order, we have to do it ourselves
	--[[local function OrderWeaponList(WeaponList) 
		print("------------ \nOld weapon list:")
		PrintTable(WeaponList)
		print("------------")

		local NewWeaponList = {}

		for _, v in ipairs(WeaponList) do
			local slot = v:GetSlot()
			print("Slot: " .. slot)

			table.insert(NewWeaponList, slot + 1, v)
		end

		print("------------ \n New weapon list:")
		PrintTable(NewWeaponList)
		print("------------")
		for _, v in ipairs(NewWeaponList) do
			local slot = v:GetSlot()
			print("Slot: " .. slot)
		end
		return NewWeaponList
	end]]--

	local WeaponSwitchTime, WeaponIndex = 0, 0
	--hook.Remove("InputMouseApply", "ABootSimpleWeaponSelect")

	hook.Add("InputMouseApply", "ABootSimpleWeaponSelect", function(cmd, x, y, ang)
		if not(simpleWeaponSelect:GetBool()) then return end
		local MouseWheel, Time, Ply = cmd:GetMouseWheel(), CurTime(), LocalPlayer()
		if (MouseWheel ~= 0) then
			WeaponSwitchTime = Time + 0.5

			if Ply:IsSuitEquipped() or not(Ply:Alive()) then return end

			local CurWep, Weapons = Ply:GetActiveWeapon(), Ply:GetWeapons()

			if not(IsValid(CurWep)) then return end 
		
			local CurWepIndex = table.KeyFromValue(Weapons, CurWep)
			local NextWepIndex = CurWepIndex + MouseWheel

			if NextWepIndex > #Weapons then
				NextWepIndex = math.Clamp(NextWepIndex - #Weapons, 1, #Weapons)
			elseif NextWepIndex < 1 then
				NextWepIndex = math.Clamp(NextWepIndex + #Weapons, 1, #Weapons)
			end
			
			local NextWep = Weapons[NextWepIndex]

			if IsValid(NextWep) then
				input.SelectWeapon(NextWep)
			end
		end
	end)

	--hook.Remove("PlayerButtonDown", "ABootHotBarWeaponSelect")

	hook.Add("PlayerButtonDown", "ABootHotBarWeaponSelect", function(playa, button)
		if not(simpleWeaponSelect:GetBool()) then return end
		local slot = button - 2

		if slot > 6 then return end
		if not(playa:Alive()) or playa:IsSuitEquipped() then return end

		local Weapons, CurWep = playa:GetWeapons(), playa:GetActiveWeapon()
		local FirstInSlot = nil

		for _, v in ipairs( Weapons ) do

			--print("Weapon: " .. tostring(v), "Slot: " .. v:GetSlot(), "Slot position: " .. v:GetSlotPos())

			if (v ~= CurWep) and (v:GetSlot() == slot) then
				input.SelectWeapon(v)
			end
		end
	end)
end