player_manager.AddValidModel( "Classic HEV Suit", 
"models/ragenigga/player/hev_suit.mdl" );
list.Set( "PlayerOptionsModel", "Classic HEV Suit", 
"models/ragenigga/player/hev_suit.mdl" );
player_manager.AddValidHands( "Classic HEV Suit", 
"models/ragenigga/viewmodels/c_arms_classic.mdl", 0, "00000000" )

JMod.AdditionalArmorTable = JMod.AdditionalArmorTable or {}

local HEVArmorProtectionProfile={
	[DMG_BUCKSHOT]= .33,
	[DMG_CLUB]= .50,
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

JMod.AdditionalArmorTable["ABoot HEV Suit"]={
	PrintName="EZ HEV Suit",
	Category="JMod - EZ HL:2",
	mdl="models/blackmesa/props_generic/bm_hevcrate01.mdl",
	--mat="models/props_generic/bm_hevcrate01_skin0.vmt",
	lbl = "MK.II HEV SUIT",
	clr={ r = 255, g = 255, b = 255 },
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
		eq="hl1/fvox/bell.wav",
		uneq="hl1/fvox/deactivated.wav"
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
JMod.AdditionalArmorTable["ABoot Jump Module"]={
	PrintName = "EZ Jump Module",
	Category = "JMod - EZ HL:2",
	mdl = "models/blackmesa/jumpmod/w_longjump.mdl",
	clr = { r = 255, g = 255, b = 255 },
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
		eq="jumpmod/bootup_sequence/bootup_jetconnects.wav",
		uneq="jumpmod/bootup_sequence/bootup_moduleacq.wav"
	},
	eff={
		jumpmod = true
	},
	bon = "ValveBiped.Bip01_Spine2",
	siz = Vector(.7, .7, .7),
	pos = Vector(0, 5, 0),
	ang = Angle(0, 0, 90),
	wgt = 10,
	dur = 100,
	ent = "ent_aboot_gmod_ezarmor_jumpmodule"
}
local function LoadAdditionalArmor()
	if JMod.AdditionalArmorTable and JMod.ArmorTable then
		table.Merge(JMod.ArmorTable, JMod.AdditionalArmorTable)
		JMod.GenerateArmorEntities(JMod.AdditionalArmorTable)
	end
end

LoadAdditionalArmor()
local tag = "aboot_jumpmod"
local tag_counter = tag .. "_counter"

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

local function EZDoJump(ply)
	local charges = ply:GetNW2Float(tag_counter, 0)

	if charges < 1 then return end
	if not ply.EZjumpmod_canuse then return end

	local vel = ply:GetVelocity()
	vel.x = math.Clamp(vel.x, -500, 500)
	vel.y = math.Clamp(vel.y, -500, 500)
	vel.z = math.Clamp(vel.z, 100, 150)

	ply:SetVelocity(vel * 1)
	if not IsFirstTimePredicted() then return end

	if SERVER then
		ply:EmitSound(math.random() > 0.5 and JModHL2.EZ_JUMPSNDS.BOOST1 or JModHL2.EZ_JUMPSNDS.BOOST2, 70, 100, 0.7)
	end

	charges = charges - 1
	ply:SetNW2Float(tag_counter, charges)
	ply.EZjumpmod_canuse = false

	if SERVER and charges <= 1 then
		ply:SendLua([[
			surface.PlaySound("]] .. JModHL2.EZ_JUMPSNDS.DENY .. [[")
		]])
	end
end

--local played_sound = false
hook.Remove("KeyPress", "JMOD_HL2_KEYPRESS")
hook.Add("KeyPress", "JMOD_HL2_KEYPRESS", function(ply, key)
	if ply.IsProne and ply:IsProne() then return end
	if not(ply.EZarmor and ply.EZarmor.effects and ply.EZarmor.effects.jumpmod) then return end
	if ply:GetMoveType() ~= MOVETYPE_WALK then return end

	if key == IN_JUMP then
		local LongJump = ply.EZjumpmod_keypress and CurTime() - ply.EZjumpmod_keypress < 0.4 and not ply:IsOnGround()
		if LongJump then
			EZDoJump(ply)
		else
			ply.EZjumpmod_keypress = CurTime()
		end
	end

	local vel = ply:WorldToLocal(ply:GetVelocity() + ply:GetPos())
	if SERVER and IsFirstTimePredicted() and vel.x > 100 and key == IN_BACK and not ply.EZjumpmod_canuse and not ply.played_sound then
		ply.played_sound = true
		ply:EmitSound(JModHL2.EZ_JUMPSNDS.BREAK, 70, 100, 0.7)
	end
end)

hook.Remove("OnPlayerHitGround", "JMOD_HL2_HITGROUND")
hook.Add("OnPlayerHitGround", "JMOD_HL2_HITGROUND", function(ply, water, float, speed)
	if not(ply.EZarmor and ply.EZarmor.effects and ply.EZarmor.effects.jumpmod) then return end
	if water then return end

	ply.EZjumpmod_canuse = true
	ply.played_sound = false
	if SERVER and IsFirstTimePredicted() then
		if speed > 1000 then
			ply:EmitSound(JModHL2.EZ_JUMPSNDS.LONGFALL, 75, 100, 0.7)
		elseif speed > 525 then
			ply:EmitSound(JModHL2.EZ_JUMPSNDS.FALL, 70, 100, 0.7)
		end
	end

	return true
end)