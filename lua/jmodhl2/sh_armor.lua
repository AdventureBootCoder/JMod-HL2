player_manager.AddValidModel("ABoot HEV Suit", "models/aboot/player/hev_suit.mdl");
list.Set("PlayerOptionsModel", "ABoot HEV Suit", "models/aboot/player/hev_suit.mdl");
player_manager.AddValidHands("ABoot HEV Suit", "models/aboot/ragenigga/viewmodels/c_arms_classic.mdl", 0, "00000000")
list.Set("PlayerOptionsModel", "Combine Super Soldier", "models/aboot/combine/hev_suit/combine_super_solder.mdl")
player_manager.AddValidModel("Combine Super Soldier", "models/aboot/combine/hev_suit/combine_super_solder.mdl")
player_manager.AddValidHands("Combine Super Soldier", "models/aboot/combine/hev_suit/combine_super_solder_h.mdl", 0, "00000000")

JMod = JMod or {}
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

local ScrapArmorProtectionProfile = {
	[DMG_BUCKSHOT] = .55,
	[DMG_BLAST] = .65,
	[DMG_BULLET] = .55,
	[DMG_SNIPER] = .45,
	[DMG_AIRBOAT] = .35,
	[DMG_CLUB] = .99,
	[DMG_SLASH] = .99,
	[DMG_CRUSH] = .99,
	[DMG_VEHICLE] = .99,
	[DMG_BURN] = .99,
	[DMG_PLASMA] = .75,
	[DMG_ACID] = .75
}

JModHL2.ArmorTable = {
	["ABoot HEV Suit"]={
		PrintName = "EZ HEV Suit",
		Category = "JMod - EZ HL:2",
		mdl = "models/aboot/blackmesa/props_generic/bm_hevcrate01.mdl",
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
			[DMG_POISON]=1
		},HEVArmorProtectionProfile),
		resist={
			[DMG_ACID]=.90,
			[DMG_POISON]=.99
		},
		chrg={
			chemicals = 50,
			power = 50
		},
		snds={
			eq="hl1/fvox/bell.wav",
			uneq="hl1/fvox/deactivated.wav"
		},
		eff={
			speedBoost = 1.2,
			flashresistant = true,
			nightVision = false
		},
		blackvisionwhendead = false,
		tgl = {
			blackvisionwhendead = true,
			mskmat = "mats_aboot_gmod_sprites/helmet_vignette1.png",
			eff = {
				speedBoost = 1.2,
				flashresistant = true,
				nightVision = true
			},
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
			}
		},
		plymdl="models/aboot/player/hev_suit.mdl", -- https://steamcommunity.com/sharedfiles/filedetails/?id=1341386337&searchtext=hev+suit
		mskmat="mats_aboot_gmod_sprites/helmet_vignette1.png",
		sndlop="snds_jack_gmod/mask_breathe.ogg",
		wgt = 30,
		dur = 400,
		HEVsuit = true,
		ent = "ent_aboot_gmod_ezarmor_hev"
	},
	["ABoot Combine Suit"]={
		PrintName = "EZ Combine Suit",
		Category = "JMod - EZ HL:2",
		mdl = "models/props_junk/cardboard_box002a.mdl",
		lbl = "ELITE UNIFORM",
		clr = {  r = 0, g = 255, b = 255 },
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
			chemicals = 50,
			power = 50
		},
		snds={
			eq="hl1/fvox/bell.wav",
			uneq="hl1/fvox/deactivated.wav"
		},
		eff={
			speedBoost = 1,
			flashresistant = true
		},
		blackvisionwhendead = false,
		tgl = {
			blackvisionwhendead = true,
			mskmat = "mats_aboot_gmod_sprites/helmet_vignette2.png",
			eff = {thermalVision = true},
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
			}
		},
		plymdl = "models/aboot/combine/hev_suit/combine_super_solder.mdl",
		mskmat = "mats_aboot_gmod_sprites/helmet_vignette2.png",
		sndlop = "snds_jack_gmod/mask_breathe.ogg",
		wgt = 30,
		dur = 400,
		HEVsuit = true,
		ent = "ent_aboot_gmod_ezarmor_combinesuit"
	},
	["ABoot Jump Module"]={
		PrintName = "EZ Jump Module",
		Category = "JMod - EZ HL:2",
		mdl = "models/aboot/blackmesa/hev_suit/w_longjump.mdl",
		clr = { r = 189, g = 100, b = 24 },
		clrForced = false,
		slots = {
			back = 1
		},
		tgl = {
			eff = {jumpmod = false},
			slots = {back = 0}
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
			power = 50
		},
		snds={
			eq="aboot_jumpmod/bootup_sequence/bootup_jetconnects.wav",
			uneq="aboot_jumpmod/bootup_sequence/bootup_moduleacq.wav"
		},
		eff={
			HEVreq = true,
			jumpmod = true
		},
		bon = "ValveBiped.Bip01_Spine2",
		siz = Vector(.7, .7, .7),
		pos = Vector(0, 5, 0),
		ang = Angle(0, 0, 90),
		wgt = 20,
		dur = 100,
		ent = "ent_aboot_gmod_ezarmor_jumpmodule"
	},
	["ABoot Jet Module"]={
		PrintName = "EZ Jet Module",
		Category = "JMod - EZ HL:2",
		mdl = "models/aboot/combine/hev_suit/combinejetmodule.mdl",
		clr = { r = 0, g = 255, b = 255 },
		clrForced = false,
		slots = {
			back = 1
		},
		tgl = {
			eff = {jetmod = false},
			slots = {back = 0}
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
			power = 50
		},
		snds={
			eq="aboot_jumpmod/bootup_sequence/bootup_jetconnects.wav",
			uneq="aboot_jumpmod/bootup_sequence/bootup_moduleacq.wav"
		},
		eff={
			HEVreq = true,
			jetmod = true
		},
		bon = "ValveBiped.Bip01_Spine2",
		siz = Vector(.7, .7, .7),
		pos = Vector(7, 2, 0),
		ang = Angle(0, 180, 90),
		wgt = 20,
		dur = 100,
		ent = "ent_aboot_gmod_ezarmor_jetmodule"
	},
	["Headcrab"] = {
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
	},
	["Welding Mask"] = {
		PrintName = "EZ Welding Mask",
		Category = "JMod - EZ HL:2",
		mdl = "models/hl2ep2/welding_helmet.mdl",
		Spawnable = true,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		slots = {
			eyes = .90
		},
		def = table.Inherit({
			[DMG_NERVEGAS]=1,
			[DMG_RADIATION]=1,
			[DMG_ACID]=1,
			[DMG_POISON]=1,
		}, ScrapArmorProtectionProfile),
		resist={
			[DMG_ACID]=.75,
			[DMG_POISON]=.90
		},
		eff={
			flashresistant = true
		},
		tgl = {
			eff = {flashresistant = false},
			slots = {
				eyes = 0,
				mouthnose = 0
			},
			pos = Vector(9, 2, 0),
			ang = Angle(-10, 0, -90),
			mskmat = false
		},
		--[[snds={
			eq="npc/headcrab/headbite.wav",
			uneq="npc/headcrab/pain1.wav"
		},]]--
		bon = "ValveBiped.Bip01_Head1",
		siz = Vector(1.1, 1.1, 1.1),
		pos = Vector(0, -4.5, 0),
		ang = Angle(-90, 0, -90),
		wgt = 5,
		dur = 50,
		mskmat="mats_aboot_gmod_sprites/weldingmask_vignette.png",
		ent = "ent_aboot_gmod_ezarmor_weldingmask"
	},
	["Longfall Boots"] = {
		PrintName = "Longfall Boots",
		Category = "JMod - EZ HL:2",
		mdl = "models/items/jumperboots.mdl",
		slots = {
			rightcalf = .7,
			leftcalf = .7
		},
		eff = {
			fallProtect = true
		},
		def = NonArmorProtectionProfile,
		bon = "ValveBiped.Bip01_Pelvis",
		merge = true,
		siz = Vector(1.2, 1.2, 1.2),
		--bonsiz = Vector(.9, .9, .9),
		pos = Vector(38, 0, 0),
		ang = Angle(0, -90, -90),
		wgt = 5,
		dur = 100,
		ent = "ent_aboot_gmod_ezarmor_longfallboots"
	},
	["Powered Combat Vest"]={
		PrintName = "EZ PCV",
		Category = "JMod - EZ HL:2",
		mdl = "models/aboot/pcv_suit.mdl",
		clrForced = false,
		slots={
			chest = 1,
			abdomen = 1
		},
		def=table.Inherit({
			[DMG_NERVEGAS]=1.5,
			[DMG_RADIATION]=1.5,
			[DMG_ACID]=1.5,
			[DMG_POISON]=1.5
		},HEVArmorProtectionProfile),
		resist={
			[DMG_ACID]=.90,
			[DMG_POISON]=.99,
		},
		chrg={
			power = 50
		},
		snds={
			eq="hl1/fvox/bell.wav",
			uneq="hl1/fvox/deactivated.wav"
		},
		eff={
			speedBoost = 1.2,
			chargeEquipped = true,
			chargeShield = true
		},
		tgl = {
			eff={
				speedBoost = 1.2,
				chargeEquipped = false,
				chargeShield = false
			},
			slots={
				chest = 1,
				abdomen = 1
			}
		},
		wgt = 20,
		dur = 400,
		storage = 5,
		HEVsuit = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = Vector(1.15, 1, 1),
		pos = Vector(-4.2, -8.4, 0),
		ang = Angle(-85, 1, 93.5),
		bdg = {
			[1] = 0,
		},
		ent = "ent_aboot_gmod_ezarmor_pcv"
	},
}

local function HL2LoadAdditionalArmor()
	if JModHL2.ArmorTable then
		JModHL2.ArmorTable["Admin Jump Module"] = table.Copy(JModHL2.ArmorTable["ABoot Jump Module"])
		JModHL2.ArmorTable["Admin Jump Module"].PrintName = "Admin Jump Module"
		JModHL2.ArmorTable["Admin Jump Module"].AdminOnly = true
		JModHL2.ArmorTable["Admin Jump Module"].eff = { HEVreq = false, jumpmod = true }
		JModHL2.ArmorTable["Admin Jump Module"].ent = "ent_aboot_gmod_ezarmor_jumpmodule_admin"
		JModHL2.ArmorTable["Admin Jet Module"] = table.Copy(JModHL2.ArmorTable["ABoot Jet Module"])
		JModHL2.ArmorTable["Admin Jet Module"].PrintName = "Admin Jet Module"
		JModHL2.ArmorTable["Admin Jet Module"].AdminOnly = true
		JModHL2.ArmorTable["Admin Jet Module"].eff = { HEVreq = false, jetmod = true }
		JModHL2.ArmorTable["Admin Jet Module"].ent = "ent_aboot_gmod_ezarmor_jetmodule_admin"
		table.Merge(JMod.AdditionalArmorTable, JModHL2.ArmorTable)
	end
end

HL2LoadAdditionalArmor()

local tag_counter = "aboot_jumpmod_counter"

hook.Add("StartCommand", "JMOD_HL2_ZOMBIE_MOVE", function(ply,cmd)
	if CLIENT and ply.Scared then
		cmd:ClearMovement()

		return
	end
	if ply:Alive() and (ply.EZarmor and ply.EZarmor.effects and ply.EZarmor.effects.zombie) then
		local Time = CurTime()
		local RandDir = (cmd:GetViewAngles():Forward() + VectorRand(-0.1, 0.1)):Angle()
		cmd:ClearMovement()
		cmd:SetViewAngles(Angle(0, RandDir.y, 0))
		cmd:SetForwardMove(ply:GetWalkSpeed() * .75)
		cmd:SetButtons(IN_ATTACK)
		if (ply.EZzombieTime or 0) < Time then
			ply.EZzombieTime = Time + math.Rand(3, 10)
			ply:EmitSound("npc/zombie/zombie_alert"..tostring(math.random(1, 3))..".wav")
			ply:ConCommand("act zombie")
		end
	end
end)

local RegularJump, NextEffectTime = true, 0
hook.Add("Move", "JMOD_HL2_ARMOR_MOVE", function(ply, mv)
	if ply.IsProne and ply:IsProne() or ply:GetMoveType() ~= MOVETYPE_WALK then
		ply.EZjetting = false
		if ply.EZThrusterSound then
			ply.EZThrusterSound:Stop()
			ply.EZThrusterSound = nil
		end
		
		return 
	end
	local Time = CurTime()

	if ply.EZarmor and ply.EZarmor.effects then
		if mv:KeyDown(IN_SPEED) and ply:OnGround() then
			if ply.EZarmor.effects.speedBoost then
				local origSpeed = mv:GetMaxSpeed()
				local origClientSpeed = mv:GetMaxClientSpeed()
				mv:SetMaxSpeed(origSpeed * ply.EZarmor.effects.speedBoost)
				mv:SetMaxClientSpeed(origClientSpeed * ply.EZarmor.effects.speedBoost)
			end
		end

		if mv:KeyPressed(IN_JUMP) and ply:OnGround() then
			RegularJump = true
		elseif RegularJump and mv:KeyReleased(IN_JUMP) then
			RegularJump = false
		end
		--jprint(RegularJump)

		local Charges = ply:GetNW2Float(tag_counter, 0)

		if ply.EZarmor.effects.jumpmod then
			if not(RegularJump) and mv:KeyDown(IN_JUMP) and IsFirstTimePredicted() then
				local Charges = ply:GetNW2Float(tag_counter, 0)
				if not(ply:OnGround()) and ply:GetNW2Bool("EZjumpmodCanUse", true) and (Charges >= 1) then
					-- Get Eye angles and then get the direction the jump module would actually be aiming
					local Aim = ply:EyeAngles()
					local OldVel, NewVel = mv:GetVelocity(), Aim:Up() * 450
					-- Tell the server that's where we're going
					mv:SetVelocity(OldVel + NewVel)
					-- Sound, psshha
					ply:EmitSound(math.random() > 0.5 and JModHL2.EZ_JUMPSNDS.BOOST1 or JModHL2.EZ_JUMPSNDS.BOOST2, 70, 100, 0.7)
					-- When we have to deal with garry's prediction, ugh
					if SERVER then
						net.Start("ABoot_JumpmodParticles")
						net.WriteEntity(ply)
						net.Broadcast()
					end
					-- Let them know they're out of juice
					if CLIENT and Charges <= 1 then
						EmitSound(JModHL2.EZ_JUMPSNDS.DENY, ply:GetPos(), ply:EntIndex(), CHAN_ITEM)
					end
					-- Viewpunch!
					ply:ViewPunch(Angle(3, 0, 0))
					-- Make sure to reduce the charges left
					Charges = Charges - 1
					ply:SetNW2Float(tag_counter, Charges)
					ply:SetNW2Bool("EZjumpmodCanUse", false)
					-- Timer for regulating useage
					timer.Create(ply:Nick().."EZjumpmodTimer", 0.4, 1, function()
						ply:SetNW2Bool("EZjumpmodCanUse", true)
					end)
					timer.Start(ply:Nick().."EZjumpmodTimer")

					return true
				end
			end
		elseif ply.EZarmor.effects.jetmod then
			if not(RegularJump) and mv:KeyDown(IN_JUMP) then
				if not(ply:OnGround()) and Charges > 0.15 then
					-- Get Eye angles and then get the direction the jump module would actually be aiming
					local Drain = 0.02
					local Dir = ply:GetAngles()
					local OldVel = mv:GetVelocity()
					local NewVel = Vector(0, 0, 1)
					local NewForward, NewRight = Dir:Forward(), Dir:Right()
					if mv:KeyDown(IN_FORWARD) then
						NewVel = NewVel + Vector(NewForward.x, NewForward.y, 0)
					elseif mv:KeyDown(IN_BACK) then
						NewVel = NewVel - Vector(NewForward.x, NewForward.y, 0)
					end
					if mv:KeyDown(IN_MOVELEFT) then
						NewVel = NewVel - Vector(NewRight.x, NewRight.y, 0)
					elseif mv:KeyDown(IN_MOVERIGHT) then
						NewVel = NewVel + Vector(NewRight.x, NewRight.y, 0)
					end
					NewVel = NewVel:GetNormalized() * 12
					if util.QuickTrace(ply:GetPos(), Vector(0, 0, -120), {ply}).Hit then
						NewVel = NewVel --+ Vector(0, 0, 3)
					end
					-- Tell the server that's where we're going
					mv:SetVelocity(OldVel + NewVel)
					ply.EZjetting = true
					-- Sound, psshha
					if not ply.EZThrusterSound then
						ply.EZThrusterSound = CreateSound(ply, "^thrusters/rocket00.wav")
					end
					ply.EZThrusterSound:Play()
					ply.EZThrusterSound:SetSoundLevel(150)
					ply.EZThrusterSound:ChangePitch(80 + (Charges * 12)^1.2)
					--[[if not IsValid(ply.ThrustEffect) then
						ply.ThrustEffect = ents.Create("env_rotorwash_emitter")
						ply.ThrustEffect:SetPos(ply:GetPos())
						ply.ThrustEffect:Spawn()
						ply.ThrustEffect:SetParent(ply)
					end]]--
					if SERVER then
						if NextEffectTime < Time then
							NextEffectTime = Time + 0.2
							-- Effects, poof
							net.Start("ABoot_JumpmodParticles")
							net.WriteEntity(ply)
							net.Broadcast()
						end
					end
					-- Make sure to reduce the charges left
					Charges = Charges - Drain
					ply:SetNW2Float(tag_counter, Charges)
				end
			end
			-- Let them know they're out of juice
			if CLIENT and mv:KeyPressed(IN_JUMP) and Charges <= 0.1 then
				EmitSound(JModHL2.EZ_JUMPSNDS.DENY, ply:GetPos(), ply:EntIndex(), CHAN_ITEM)
			end
		end
		if not(mv:KeyDown(IN_JUMP)) or ply:OnGround() then
			if ply.EZThrusterSound then
				ply.EZThrusterSound:Stop()
			end
			--[[if IsValid(ply.ThrustEffect) then
				ply.ThrustEffect:Remove()
				ply.ThrustEffect = nil
			end]]--
			ply.EZjetting = false
		end
	end
end)

net.Receive("ABoot_JumpmodParticles", function()
	local Ply = net.ReadEntity()
	-- Effects, poof
	local EffectSpot = Ply:GetPos()
	local Poof = EffectData()
	Poof:SetNormal(-Ply:GetAimVector():Angle():Up())
	Poof:SetScale(1)
	Poof:SetOrigin(EffectSpot)
	Poof:SetStart(Vector(0, 0, -45))
	Poof:SetEntity(Ply)
	util.Effect("eff_aboot_gmod_ezjumppoof", Poof, true)
end)

hook.Add("OnPlayerHitGround", "JMOD_HL2_HITGROUND", function(ply, water, float, speed)
	if not(ply.EZarmor and ply.EZarmor.effects and ply.EZarmor.effects.jumpmod) then return end
	if water then return end
	local Charges = ply:GetNW2Float(tag_counter, 0)

	ply:SetNW2Bool("EZjumpmodCanUse", true)
	timer.Stop(ply:Nick().."EZjumpmodTimer")
	ply.played_sound = false
end)

hook.Add("GetFallDamage", "JMOD_HL2_FALLDAMAGEPROTECT", function(ply, speed)
	if ply:IsPlayer() and JMod.PlyHasArmorEff(ply, "fallProtect") then
		ply:EmitSound("physics/metal/metal_box_impact_hard"..tostring(math.random(1, 3))..".wav", 60, math.random(110, 120), 0.5, CHAN_AUTO)

		return 0
	end
end)

hook.Add("EntityTakeDamage", "JMOD_HL2_FALLDAMAGEPROTECT", function(target, dmginfo)
	if (target:IsPlayer() and dmginfo:IsFallDamage()) and JMod.PlyHasArmorEff(target, "fallProtect") then
		dmginfo:ScaleDamage(0)
	end
end)

hook.Add("PlayerFootstep", "JMOD_HL2_FOOTSTEP", function(ply, pos, foot, sound, volume, filter)
	if (ply.EZarmor and ply.EZarmor.effects and ply.EZarmor.effects.fallProtect) then
		ply:EmitSound("player/footsteps/metal"..tostring(foot + 1)..".wav", 60, math.random(110, 120), volume * 0.5, CHAN_AUTO)
	end
end)

if CLIENT then

	local GlowSprite = Material("mat_jack_gmod_glowsprite")

	hook.Add("PostDrawTranslucentRenderables", "JMODHL2_POSTDRAWTRNASLUCENT", function(bDrawD, bDrawingSky, isDraw3dSky) 
		for _, ply in player.Iterator() do
			if not(IsValid(ply) and ply:Alive()) or not(ply:ShouldDrawLocalPlayer()) then return end
			if ply.EZarmor and ply.EZarmor.effects and ply.EZarmor.effects.jetmod and ply.EZjetting then
				local Matty = ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_Spine2"))
				if Matty then
					local Pos, Ang = Matty:GetTranslation(), Matty:GetAngles()
					local Dir, Up, Right = -Ang:Forward(), Ang:Up(), Ang:Right()

					render.SetMaterial(GlowSprite)

					for i = 1, 10 do
						local Inv = 10 - i
						render.DrawSprite(Pos - Up * 8 + Right * 5 + Dir * (i * 3 + math.random(5, 10)), 2 * Inv, 2 * Inv, Color(255, 255 - i * 20, 255 - i * 10, 255))
						render.DrawSprite(Pos + Up * 8 + Right * 5 + Dir * (i * 3 + math.random(5, 10)), 2 * Inv, 2 * Inv, Color(255, 255 - i * 20, 255 - i * 10, 255))
					end
				end
			end
		end
	end)
end

function JModHL2.EZstun(ent, amt, attacker, immobilize)
	if SERVER then
		ent:SetNW2Float("EZstunAmount", ent:GetNW2Float("EZstunAmount", 0) + amt)
	end
end

hook.Add("StartCommand", "JMOD_HL2_STUNEFFECT", function(ply, cmd)
	local StunAmt = ply:GetNW2Float("EZstunAmount", 0)
	if StunAmt > 0 then
		cmd:ClearMovement()
		cmd:ClearButtons()

		--[[if JMod.LinCh(StunAmt, 0.5, 3) then
			if math.random(1, 2) > 1 then
				cmd:SetButtons(IN_ATTACK)
			else
				cmd:SetButtons(IN_ATTACK2)
			end
		else
			cmd:SetButtons(IN_JUMP)
		end--]]

		if IsFirstTimePredicted() then
			local FT = FrameTime()
			ply:SetNW2Float("EZstunAmount", math.Clamp(StunAmt - 1 * FT, 0, 10))
		end

		-- Add some movement to make the player more disoriented
		local StunFraction = math.Clamp(StunAmt, 0, 10)
		local CurrentViewAngles = cmd:GetViewAngles()
		local Sine = math.sin(RealTime() / 10)
		cmd:SetViewAngles(Angle(CurrentViewAngles.pitch + Sine * math.Rand(-10, 10) * StunFraction, CurrentViewAngles.yaw + Sine * math.Rand(-1, 1) * StunFraction, CurrentViewAngles.roll))
	end
end)