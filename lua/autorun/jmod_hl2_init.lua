JModHL2 = JModHL2 or {}

-- we have to load locales before any other files
-- because files that add concommands have help text
-- and we want the help text to be localized
--include("jmodhl2/sh_locales.lua")
--AddCSLuaFile("jmodhl2/sh_locales.lua")

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
	local noPowerDraw = CreateConVar("aboot_infinite_power", "0", FCVAR_ARCHIVE, "Disables jump/jet modules drawing internal power, effectivly making their charge infinite")
	local EZammoPickup = CreateConVar("aboot_ez_ammopickup", "0", FCVAR_ARCHIVE, "Turns HL2 ammo pickups into EZ ammo pickups for the weapon you are holding")

	local function RemoveHEVsuit(playa) 
		playa:SetArmor(0)
		if playa:IsSuitEquipped() then
			playa:RemoveSuit()
		end
	end

	hook.Add("PlayerSpawn", "ABootHL2PlySpawn", function(playa)
		if defaultHEVdisable:GetBool() then
			RemoveHEVsuit(playa)
		end
		playa:SetNW2Float(tag_counter, 0)
	end)

	hook.Add("PlayerDeath", tag, function(playa)
		playa:SetNW2Float(tag_counter, 0)
	end)

	hook.Add("JModHookEZArmorSync", "ABootHL2ArmorCheck", function(playa)
		local PlyEff = playa.EZarmor.effects
		if PlyEff and PlyEff.HEVsuit then
			if not(playa:IsSuitEquipped()) then
				playa:EquipSuit()
			end
		elseif defaultHEVdisable:GetBool() and playa:IsSuitEquipped() then
			RemoveHEVsuit(playa)
		end
		if PlyEff and PlyEff.HEVreq and not(PlyEff.HEVsuit) then
			for id, items in pairs(playa.EZarmor.items) do
				if JMod.ArmorTable[items.name].eff.HEVreq then
					playa:PrintMessage(HUD_PRINTCENTER, "This armor requires an HEV suit")
					JMod.RemoveArmorByID(playa, id)
				end
			end
		end
	end)

	local NextMainThink, NextArmorThink = 0, 0
	hook.Add("Think", "JMOD_HL2_THINK", function()
		local Time, FT = CurTime(), FrameTime()
		
		if NextMainThink > Time then return end
		NextMainThink = Time + 0.2

		for _, ply in ipairs(player.GetAll()) do
			if ply.EZarmor and ply.EZarmor.effects then
				if ply.EZarmor.effects.HEVsuit then
					local TrackedMachine = ply:GetNW2Entity("EZmachineTracking", nil)
					if IsValid(TrackedMachine) then
						if TrackedMachine.Target and IsValid(TrackedMachine.Target) and (TrackedMachine:GetState() > 0) then
							ply:SetNW2Entity("EZturretTarget", TrackedMachine.Target)
						else
							ply:SetNW2Entity("EZturretTarget", nil)
						end
					end
				end

				if ply.EZarmor.effects.jumpmod or ply.EZarmor.effects.jetmod then
					local val = math.Clamp(ply:GetNW2Float(tag_counter, 3) + FT * 4.5, 0, 3)
					if ply.charging == nil then
						ply.charging = true
					end

					if val < 1 then
						ply.EZjumpmod_usealert = true
					elseif val >= 1 and ply.EZjumpmod_usealert then
						ply:SetNW2Bool("EZjumpmod_canuse", true)
						ply.EZjumpmod_usealert = nil
						ply:SendLua([[surface.PlaySound("]] .. JModHL2.EZ_JUMPSNDS.READY .. [[")]])
					end

					local AuxPowered = false

					if (val < 3) and not(noPowerDraw:GetBool()) then
						if (GetConVar("gmod_suit"):GetBool()) and (ply:GetSuitPower() >= 1) then
						
							ply.charging = true
							if (ply:GetSuitPower() >= 1.25) then
								ply:SetSuitPower(math.Clamp(ply:GetSuitPower() - 5.5 * (FT * 60), 0, 100))
								AuxPowered = true
							else
								ply.charging = false
							end
						end
						if NextArmorThink < Time then
							NextArmorThink = Time + 2

							if not AuxPowered then
								for id, armorData in pairs(ply.EZarmor.items) do
									local Info = JMod.ArmorTable[armorData.name]

									if Info.eff and (Info.eff.jumpmod or Info.eff.jetmod) and not(Info.AdminOnly == true) then
										
										if armorData.chrg.power < 1.1 * JMod.Config.Armor.ChargeDepletionMult then
											JMod.EZarmorWarning(ply, "Jump module is out of charge")
											ply.charging = false
										else
											armorData.chrg.power = math.Clamp(armorData.chrg.power - (1 * JMod.Config.Armor.ChargeDepletionMult), 0, Info.chrg.power)
											ply.charging = true
										end

										if armorData.chrg.power <= Info.chrg.power * .25 then
											JMod.EZarmorWarning(ply, "Jump module charge is low ("..tostring(armorData.chrg.power).."/"..tostring(Info.chrg.power)..")")
										end
										
										break
									end
								end
							end
						end
					end
					if ply.charging == true then
						ply:SetNW2Float(tag_counter, val)
					end
				end
			end
		end
	end)

	local HLtoEZammo = {
		["item_ammo_357"] = {"Magnum Pistol Round", 12},
		["item_ammo_357_large"] = {"Magnum Pistol Round", 24},
		["item_ammo_ar2"] = {"Light Pulse Ammo", 30},
		["item_ammo_ar2_large"] = {"Light Pulse Ammo", 90},
		["item_ammo_pistol"] = {"Pistol Round", 20},
		["item_ammo_pistol_large"] = {"Pistol Round", 30},
		["item_ammo_smg1"] = {"Pistol Round", 45},
		["item_ammo_smg1_large"] = {"Pistol Round", 60},
		["item_box_buckshot"] = {"Shotgun Round", 20},
		["item_rpg_round"] = {"RPG Rocket", 1},
	}

	hook.Add("PlayerCanPickupItem", "JMod_HL2_EZpickup", function(ply, item)
		if (EZammoPickup:GetBool() == true) and (HLtoEZammo[item:GetClass()]) then
			EZammoConversion = HLtoEZammo[item:GetClass()]
			local AmmoID = game.GetAmmoID(EZammoConversion[1])
			local MaxAmmo = game.GetAmmoMax(AmmoID) * JMod.Config.Weapons.AmmoCarryLimitMult
			local AmmoToGive = math.min(EZammoConversion[2], MaxAmmo - ply:GetAmmoCount(EZammoConversion[1]))
			if AmmoToGive > 0 then
				ply:GiveAmmo(AmmoToGive, EZammoConversion[1])
				item:Remove()

				return false
			end
		end
		--[[if (item:GetClass() == "item_healthkit") and (ply:Health() < ply:GetMaxHealth()) then
			ply.EZhealth = (ply.EZhealth or 0) + 15
			ply:PrintMessage(HUD_PRINTCENTER, "treatment " .. ply.EZhealth + ply:Health() .. "/" .. ply:GetMaxHealth())
			sound.Play("snds_jack_gmod/ez_medical/" .. math.random(1, 27) .. ".wav", ply:GetShootPos(), 60, math.random(90, 110))
			item:Remove()

			return false
		end]]--
	end)

	hook.Add("PlayerUse", "JMod_HL2_MachineTracking", function(ply, ent) 
		if not(IsValid(ply)) or not(IsValid(ent)) or not(ent.IsJackyEZmachine) then return end
		if not(ply:Alive() and ply.EZarmor and ply.EZarmor.effects and ply.EZarmor.effects.HEVsuit) then 
			ply:SetNW2Entity("EZmachineTracking", nil) 
			
			return 
		end

		if ent ~= ply:GetNW2Entity("EZmachineTracking", nil) and (JMod.GetEZowner(ent) == ply) and (ent:GetState() > 0) then
			ply:SetNW2Entity("EZmachineTracking", ent)
			jprint("Linking to: " .. tostring(ply:GetNW2Entity("EZmachineTracking", nil)))
		elseif ent == ply:GetNW2Entity("EZmachineTracking", ent) and (ent:GetState() == 0) then
			ply:SetNW2Entity("EZmachineTracking", nil)
		end
	end)

	concommand.Add("aboot_debug", function(ply, cmd, args) 
		if not GetConVar("sv_cheats"):GetBool() then return end
		ply:EmitSound("Weapon_PhysCannon.Launch", CHAN_WEAPON)
		local cballspawner = ents.Create("point_combine_ball_launcher")
		cballspawner:SetAngles(ply:GetAngles())
		cballspawner:SetPos(ply:GetShootPos() + ply:GetAimVector() * 14)
		cballspawner:SetKeyValue("minspeed", 1000)
		cballspawner:SetKeyValue("maxspeed", 1000 )
		cballspawner:SetKeyValue("ballradius", "1")
		cballspawner:SetKeyValue("ballcount", "10")
		cballspawner:SetKeyValue("maxballbounces", "18")
		cballspawner:SetKeyValue("launchconenoise", 1.2)
		cballspawner:Spawn()
		cballspawner:Activate()
		cballspawner:Fire("LaunchBall")
		cballspawner:Fire("kill","",1)
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