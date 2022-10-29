player_manager.AddValidModel( "Classic HEV Suit", 
"models/ragenigga/player/hev_suit.mdl" );
list.Set( "PlayerOptionsModel", "Classic HEV Suit", 
"models/ragenigga/player/hev_suit.mdl" );
player_manager.AddValidHands( "Classic HEV Suit", 
"models/ragenigga/viewmodels/c_arms_classic.mdl", 0, "00000000" )

JMod.AdditionalArmorTable = JMod.AdditionalArmorTable or {}

local HEVArmorProtectionProfile={
	[DMG_BUCKSHOT]=.33,
	[DMG_CLUB]=.50,
	[DMG_SLASH]=.75,
	[DMG_BULLET]=.33,
	[DMG_BLAST]=.5,
	[DMG_SNIPER]=.2,
	[DMG_AIRBOAT]=.8,
	[DMG_CRUSH]=.5,
	[DMG_VEHICLE]=.65,
	[DMG_BURN]=.80,
	[DMG_PLASMA]=.60,
	[DMG_ACID]=.5
}

JMod.AdditionalArmorTable["ABoot HEV Suit"]={
	PrintName="HEV Suit",
	Category="JMod - EZ HL:2",
	mdl = "models/custom/scifiboxes/crate_d.mdl",
	--mdl="models/props_junk/cardboard_box002a.mdl",
	--mat="models/ragenigga/hev_suit/hevsuit_sheet",
	lbl="EZ HEV SUIT",
	clr={ r = 255, g = 190, b = 0 },
	clrForced=false,
	slots={
		eyes=1,
		mouthnose=1,
		head=1,
		chest=1,
		abdomen=1,
		pelvis=1,
		leftthigh=1,
		leftcalf=1,
		rightthigh=1,
		rightcalf=1,
		rightshoulder=1,
		rightforearm=1,
		leftshoulder=1,
		leftforearm=1
	},
	def=table.Inherit({
		[DMG_NERVEGAS]=1,
		[DMG_RADIATION]=1,
		[DMG_ACID]=1,
		[DMG_POISON]=1,
	},HEVArmorProtectionProfile),
	resist={
		[DMG_ACID]=.75,
		[DMG_POISON]=.90
	},
	chrg={
		chemicals = 50
	},
	snds={
		eq="snd_jack_clothequip.wav",
		uneq="snd_jack_clothunequip.wav"
	},
	eff={
		HEVsuit = true,
		speedBoost = 1.5
	},
	plymdl="models/ragenigga/player/hev_suit.mdl", -- https://steamcommunity.com/sharedfiles/filedetails/?id=1341386337&searchtext=hev+suit
	mskmat="mats_aboot_gmod_sprites/helmet_vignette1.png",
	sndlop="snds_jack_gmod/mask_breathe.wav",
	wgt=0.1,
	dur=400,
	ent="ent_aboot_gmod_ezarmor_hev"
}
local function LoadAdditionalArmor()
	if JMod.AdditionalArmorTable and JMod.ArmorTable then
		table.Merge(JMod.ArmorTable, JMod.AdditionalArmorTable)
		JMod.GenerateArmorEntities(JMod.AdditionalArmorTable)
	end
end

LoadAdditionalArmor()

hook.Add("Move", "JMOD_HL2_ARMOR_MOVE", function(ply, mv, cmd)
    if mv:KeyDown(IN_SPEED)then 
		if ply.IsProne and ply:IsProne() then return end

		if ply.EZarmor and ply.EZarmor.effects and ply.EZarmor.effects.speedBoost then
			local origSpeed = mv:GetMaxSpeed()
			local origClientSpeed = mv:GetMaxClientSpeed()
			mv:SetMaxSpeed(origSpeed * ply.EZarmor.effects.speedBoost)
			mv:SetMaxClientSpeed(origClientSpeed * ply.EZarmor.effects.speedBoost)
		end
	end
end)

if(SERVER)then
	local defaultHEVdisable = CreateConVar("ABoot_disable_HEV", "0", FCVAR_ARCHIVE, "Removes the HEV suit from players on spawn and when it's destroyed")

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

	hook.Add("Think", "JMOD_HL2_THINK", function()
		local Time = CurTime()

		if NextMainThink < Time then
			NextMainThink = Time + 1

			--JPrint("Aux Power: " .. playa:GetSuitPower() .. " " .. "Oxygen: " .. playa.EZoxygen)
			--print(tobool(gmod_suit))
		end
		
		--[[if NextArmorThink < Time then
			NextArmorThink = Time + 1

			for k, playa in pairs(player.GetAll()) do
				if playa.EZarmor and playa:Alive() then
					if playa.EZarmor.effects.HEVsuit then
						for id, armorData in pairs(playa.EZarmor.items) do
							local Info = JMod.ArmorTable[armorData.name]
						end
					end
					--JMod.CalcSpeed(playa)
					JMod.EZarmorSync(playa)
				end
			end
		end]]--
		
	end)
elseif CLIENT then 

	local simpleWeaponSelect = CreateConVar("ABoot_simple_weapon_select", "1", FCVAR_ARCHIVE, "Enables a vey crude weapon select stand in for when you don't have an HEV suit. It's recomended you get a better one.")

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