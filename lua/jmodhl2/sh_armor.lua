player_manager.AddValidModel( "ABoot HEV Suit", 
"models/aboot/player/hev_suit.mdl" );
list.Set( "PlayerOptionsModel", "ABoot HEV Suit", 
"models/aboot/player/hev_suit.mdl" );
player_manager.AddValidHands( "ABoot HEV Suit", 
"models/ragenigga/viewmodels/c_arms_classic.mdl", 0, "00000000" )

JMod.AdditionalArmorTable = JMod.AdditionalArmorTable or {}

local HEVArmorProtectionProfile={
	[DMG_BUCKSHOT]= .33,
	[DMG_CLUB]= .6,
	[DMG_SLASH]= .75,
	[DMG_BULLET]= .33,
	[DMG_BLAST]= .5,
	[DMG_SNIPER]= .2,
	[DMG_AIRBOAT]= .8,
	[DMG_CRUSH]= .5,
	[DMG_VEHICLE]= .65,
	[DMG_BURN]= .8,
	[DMG_PLASMA]= .60,
	[DMG_ACID]= .5
}

local NonArmorProtectionProfile = {
	[DMG_BUCKSHOT] = .05,
	[DMG_BLAST] = .05,
	[DMG_BULLET] = .05,
	[DMG_SNIPER] = .05,
	[DMG_AIRBOAT] = .05,
	[DMG_CLUB] = .05,
	[DMG_SLASH] = .05,
	[DMG_CRUSH] = .05,
	[DMG_VEHICLE] = .05,
	[DMG_BURN] = .05,
	[DMG_PLASMA] = .05,
	[DMG_ACID] = .05
}

JModHL2.ArmorTable = {
	["ABoot HEV Suit"]={
		PrintName = "EZ HEV Suit",
		Category = "JMod - EZ HL:2",
		mdl = "models/blackmesa/props_generic/bm_hevcrate01.mdl",
		lbl = "MK.II HEV SUIT",
		clr = {  r = 189, g = 100, b = 24 },
		clrForced = false,
		slots={
			eyes = 1,
			mouthnose = 1,
			head = 1,
			chest = 1,
			abdomen = 1,
			pelvis = 1,
			leftthigh = 1,
			leftcalf = 1,
			rightthigh = 1,
			rightcalf = 1,
			rightshoulder = 1,
			rightforearm = 1,
			leftshoulder = 1,
			leftforearm = 1
		},
		def=table.Inherit({
			[DMG_NERVEGAS]=1,
			[DMG_RADIATION]=1,
			[DMG_ACID]=1,
			[DMG_POISON]=1,
		},HEVArmorProtectionProfile),
		resist={
			[DMG_ACID]=.90,
			[DMG_POISON]=.99
		},
		chrg={
			chemicals = 50
		},
		snds={
			eq="hl1/fvox/bell.wav",
			uneq="hl1/fvox/deactivated.wav"
		},
		eff={
			HEVsuit = true,
			speedBoost = 1.2
		},
		plymdl="models/aboot/player/hev_suit.mdl", -- https://steamcommunity.com/sharedfiles/filedetails/?id=1341386337&searchtext=hev+suit
		mskmat="mats_aboot_gmod_sprites/helmet_vignette1.png",
		sndlop="snds_jack_gmod/mask_breathe.wav",
		wgt = 40,
		dur = 625,
		ent = "ent_aboot_gmod_ezarmor_hev"
	},
	["ABoot Jump Module"]={
		PrintName = "EZ Jump Module",
		Category = "JMod - EZ HL:2",
		mdl = "models/blackmesa/jumpmod/w_longjump.mdl",
		clr = { r = 189, g = 100, b = 24 },
		clrForced = false,
		slots = {
			back = 1
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
			power = 30
		},
		snds={
			eq="aboot_jumpmod/bootup_sequence/bootup_jetconnects.wav",
			uneq="aboot_jumpmod/bootup_sequence/bootup_moduleacq.wav"
		},
		eff={
			jumpmod = true
		},
		bon = "ValveBiped.Bip01_Spine2",
		siz = Vector(.7, .7, .7),
		pos = Vector(0, 5, 0),
		ang = Angle(0, 0, 90),
		wgt = 20,
		dur = 100,
		HEVreq = true,
		ent = "ent_aboot_gmod_ezarmor_jumpmodule"
	},
	["Aboot Headcrab"] = {
		PrintName = "Headcrab Armor",
		Category = "JMod - EZ HL:2",
		mdl = "models/headcrabclassic.mdl",
		Spawnable = false,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		slots = {
			eyes = 1,
			mouthnose = 1,
			head = 1,
			ears = 1
		},
		def = table.Inherit({
			[DMG_NERVEGAS]=1,
			[DMG_RADIATION]=1,
			[DMG_ACID]=1,
			[DMG_POISON]=1,
		}, NonArmorProtectionProfile),
		resist={
			[DMG_ACID]=.75,
			[DMG_POISON]=.90
		},
		eff={
			zombie = true
		},
		snds={
			eq="npc/headcrab/headbite.wav",
			uneq="npc/headcrab/pain1.wav"
		},
		bon = "ValveBiped.Bip01_Head1",
		siz = Vector(1, 1, 1),
		pos = Vector(6, -3, 0),
		ang = Angle(270, 0, 270),
		wgt = 5,
		dur = 20,
		mskmat="mats_aboot_gmod_sprites/headcrab_vignette.png",
		ent = "ent_aboot_gmod_ezarmor_headcrab"
	}
}

local function HL2LoadAdditionalArmor()
	JMod.AdditionalArmorTable = JMod.AdditionalArmorTable or {}
	if JModHL2.ArmorTable then
		table.Merge(JMod.AdditionalArmorTable, JModHL2.ArmorTable)
	end
end

HL2LoadAdditionalArmor()

local tag = "aboot_jumpmod"
local tag_counter = tag .. "_counter"

hook.Add("StartCommand", "JMOD_HL2_ZOMBIE_MOVE", function(ply,cmd)
	local Time = CurTime()
	if ply.EZarmor and ply.EZarmor.effects and ply.EZarmor.effects.zombie then
		ply.EZzombieTime = ply.EZzombieTime or 0
		cmd:ClearMovement()
		local RandDir = (cmd:GetViewAngles():Forward() + VectorRand(-0.1, 0.1)):Angle()
		cmd:SetViewAngles(Angle(0, RandDir.y, 0))
		cmd:SetForwardMove(50)
		cmd:SetButtons(IN_ATTACK)
		if ply.EZzombieTime < Time then
			ply.EZzombieTime = Time + math.Rand(3, 10)
			ply:EmitSound("npc/zombie/zombie_alert"..tostring(math.random(1, 3))..".wav")
			ply:ConCommand("act zombie")
		end
	end
end)

local CHARGE_POWER = 500
hook.Add("Move", "JMOD_HL2_ARMOR_MOVE", function(ply, mv)
	if ply.IsProne and ply:IsProne() or ply:GetMoveType() ~= MOVETYPE_WALK then return end
	local Time = CurTime()

	if ply.EZarmor and ply.EZarmor.effects then
		if mv:KeyDown(IN_SPEED)then
			if ply.EZarmor.effects.speedBoost then
				local origSpeed = mv:GetMaxSpeed()
				local origClientSpeed = mv:GetMaxClientSpeed()
				mv:SetMaxSpeed(origSpeed * ply.EZarmor.effects.speedBoost)
				mv:SetMaxClientSpeed(origClientSpeed * ply.EZarmor.effects.speedBoost)
			end
		end
		--[[if not ply:OnGround() and ply.EZarmor.effects.jumpmod and (ply.NextFallSaveTime or 0) <= Time then
			if SERVER and IsFirstTimePredicted() then
				local Vel = ply:GetVelocity()
				local DownSped = -Vel.z
				if DownSped >= 500 then
					local Charges = ply:GetNW2Float(tag_counter, 0)
					local PlyPos = ply:GetPos()
					local Tr = util.TraceLine({
						start = PlyPos, 
						endpos = PlyPos + Vector(0, 0, -100), 
						mask = MASK_SOLID,
						filter = ply
					})
					--jprint(DownSped / CHARGE_POWER)
					if Tr.Hit then
						ply.NextFallSaveTime = Time + 1
						local UsedCharges = math.Clamp((DownSped / CHARGE_POWER) + .25, 0, 3)
						local UpThrust = Vector(0, 0, (UsedCharges * CHARGE_POWER) ^ 1.5)
						--jprint(Charges, UsedCharges, Charges - UsedCharges)
						--jprint((DownSped / CHARGE_POWER), DownSped - (UsedCharges * CHARGE_POWER))
						--jprint(Vel.z)
						ply:SetVelocity(UpThrust)
						ply:SetNW2Float(tag_counter, Charges - UsedCharges)
						if DownSped > 1000 and UsedCharges >= 1 then
							ply:EmitSound(JModHL2.EZ_JUMPSNDS.LONGFALL, 75, 100, 0.7)
						elseif UsedCharges > 0.1 then
							ply:EmitSound(JModHL2.EZ_JUMPSNDS.FALL, 70, 100, 0.7)
						end
					end
				end
			end
		end]]--
	end
end)

--hook.Add("PlayerPostThink", "JMod_HL2_FALL_PROTECTION", function(ply) end)

local function DoJump(ply)
	local Charges = ply:GetNW2Float(tag_counter, 0)

	if Charges < 1 then return end
	if not ply:GetNW2Bool("EZjumpmod_canuse", false) then return end

	local Vel = ply:GetVelocity()
	local Aim = ply:EyeAngles():Up()

	--[[local NewVel = Vector(Aim.x * 500, Aim.y * 500, 0)
	NewVel.x = math.Clamp(NewVel.x, -500, 500) * .5
	NewVel.y = math.Clamp(NewVel.y, -500, 500) * .5
	NewVel.z = math.Clamp(Vel.z, 100, 100) * 2.5]]--
	NewVel = Aim * 500

	ply:SetVelocity(NewVel)
	if not IsFirstTimePredicted() then return end

	if SERVER then
		ply:EmitSound(math.random() > 0.5 and JModHL2.EZ_JUMPSNDS.BOOST1 or JModHL2.EZ_JUMPSNDS.BOOST2, 70, 100, 0.7)
	end

	Charges = Charges - 1
	ply:SetNW2Float(tag_counter, Charges)
	ply:SetNW2Bool("EZjumpmod_canuse", false) -- I want to see if this will impact balance or no
	timer.Create(ply:Nick().."jumpmod_timer", 0.3, 1, function()
		ply:SetNW2Bool("EZjumpmod_canuse", true)
	end)
	timer.Start(ply:Nick().."jumpmod_timer")

	if SERVER and Charges <= 1 then
		ply:SendLua([[
			surface.PlaySound("]] .. JModHL2.EZ_JUMPSNDS.DENY .. [[")
		]])
	end
end

local played_sound = false
--hook.Remove("KeyPress", "JMOD_HL2_KEYPRESS")
hook.Add("KeyPress", "JMOD_HL2_KEYPRESS", function(ply, key)
	if ply.IsProne and ply:IsProne() then return end
	if not(ply.EZarmor and ply.EZarmor.effects and ply.EZarmor.effects.jumpmod) then return end
	if ply:GetMoveType() ~= MOVETYPE_WALK then return end

	if key == IN_JUMP then
		local LongJump = ply.EZjumpmod_keypress and CurTime() - ply.EZjumpmod_keypress < 0.4 and not ply:IsOnGround()
		if LongJump then
			DoJump(ply)
		else
			ply.EZjumpmod_keypress = CurTime()
		end
	end

	local vel = ply:WorldToLocal(ply:GetVelocity() + ply:GetPos())
	if SERVER and IsFirstTimePredicted() and ((vel.x > 100) or (vel.y > 100)) and key == IN_BACK and not ply:GetNW2Bool("EZjumpmod_canuse", false) and not ply.played_sound then
		ply.played_sound = true
		ply:EmitSound(JModHL2.EZ_JUMPSNDS.BREAK, 70, 100, 0.7)
	end
end)

--hook.Remove("OnPlayerHitGround", "JMOD_HL2_HITGROUND")
hook.Add("OnPlayerHitGround", "JMOD_HL2_HITGROUND", function(ply, water, float, speed)
	if not(ply.EZarmor and ply.EZarmor.effects and ply.EZarmor.effects.jumpmod) then return end
	if water then return end
	local Charges = ply:GetNW2Float(tag_counter, 0)

	ply:SetNW2Bool("EZjumpmod_canuse", true)
	timer.Stop(ply:Nick().."jumpmod_timer")
	ply.played_sound = false
	--[[if SERVER and IsFirstTimePredicted() then
		if speed > 1000 then
			ply:EmitSound(JModHL2.EZ_JUMPSNDS.LONGFALL, 75, 100, 0.7)
		elseif speed > 525 then
			ply:EmitSound(JModHL2.EZ_JUMPSNDS.FALL, 70, 100, 0.7)
		end
	end]]--
end)

hook.Remove("GetFallDamage", "JMOD_HL2_FALLDAMAGE")
--[[hook.Add("GetFallDamage", "JMOD_HL2_FALLDAMAGE", function(ply, sped)
	if not(ply.EZarmor and ply.EZarmor.effects and ply.EZarmor.effects.jumpmod) then return end
	local SpedDamage = sped ^ 2 / 8000
	local Charges, ChargePower = ply:GetNW2Float(tag_counter, 0), 30
	local RemainingCharges = math.Clamp(math.Round(Charges - (SpedDamage / ChargePower), 2), 0, 3)
	local UsedCharges = Charges - RemainingCharges
	ply:SetNW2Float(tag_counter, RemainingCharges)
	if RemainingCharges > 0.0 then
		return 0
	elseif JMod.Config.QoL.RealisticFallDamage then
		return math.Round((SpedDamage) / (UsedCharges * ChargePower))
	else
		return math.Round(10 / (UsedCharges * 10))
	end
end)]]--
