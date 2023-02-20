
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
		print("JMod detected unaccounted-for lua file '" .. f .. "'-check prefixes!")
	end
end

if(SERVER)then
	local SND_READY  = "jumpmod/jumpmod_ready.wav"
	resource.AddFile("sound/" .. SND_READY)
	util.AddNetworkString("ABoot_ContainerMenu")
	local defaultHEVdisable = CreateConVar("aboot_disable_hev", "0", FCVAR_ARCHIVE, "Removes the HEV suit from players on spawn and when it's destroyed. \nNo more running around with an invisible HEV suit")

	local function RemoveHEVsuit(playa) 
		playa:SetArmor(0)
		if playa:IsSuitEquipped() then
			playa:RemoveSuit()
		end
	end

	local NextMainThink, NextArmorThink = 0, 0

	hook.Add("PlayerSpawn", "ABootHL2ArmorRemove", function(playa)
		if defaultHEVdisable:GetBool() then
			RemoveHEVsuit(playa)
		end
	end)

	hook.Add("JModHookEZArmorSync", "ABootHL2ArmorCheck", function(playa)
		if playa.EZarmor.effects and playa.EZarmor.effects.HEVsuit then
			if not(playa:IsSuitEquipped()) then
				playa:EquipSuit()
			end
		elseif defaultHEVdisable:GetBool() and playa:IsSuitEquipped() then
			RemoveHEVsuit(playa)
		end
	end)

	hook.Remove("Think", "JMOD_HL2_THINK")
	hook.Add("Think", "JMOD_HL2_THINK", function()
		local Time = CurTime()

		for k, ply in ipairs(player.GetAll()) do
			if not(ply.EZarmor and ply.EZarmor.effects and ply.EZarmor.effects.jumpmod) then continue end

			local val = math.Clamp(ply.EZarmor.effects.jumpcharges + FrameTime() * 0.35, 0, 3)
			if val < 1 then
				ply.jumpmod_usealert = true
			elseif val >= 1 and ply.jumpmod_usealert then
				ply.jumpmod_usealert = nil
				ply:SendLua([[surface.PlaySound("]] .. SND_READY .. [[")]])
			end

			ply.EZarmor.effects.jumpcharges = val
		end
	end)

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