player_manager.AddValidModel( "Classic HEV Suit", 
"models/ragenigga/player/hev_suit.mdl" );
list.Set( "PlayerOptionsModel", "Classic HEV Suit", 
"models/ragenigga/player/hev_suit.mdl" );
player_manager.AddValidHands( "Classic HEV Suit", 
"models/ragenigga/viewmodels/c_arms_classic.mdl", 0, "00000000" )

JMod.AdditionalArmorTable = JMod.AdditionalArmorTable or {}

local BasicArmorProtectionProfile={
	[DMG_BUCKSHOT]=.90,
	[DMG_CLUB]=.99,
	[DMG_SLASH]=.99,
	[DMG_BULLET]=.98,
	[DMG_BLAST]=.95,
	[DMG_SNIPER]=.9,
	[DMG_AIRBOAT]=.85,
	[DMG_CRUSH]=.75,
	[DMG_VEHICLE]=.65,
	[DMG_BURN]=.65,
	[DMG_PLASMA]=.65,
	[DMG_ACID]=.55
}

JMod.AdditionalArmorTable["JMod HEV Suit"]={
	PrintName="HEV Suit",
	mdl="models/props_junk/cardboard_box002a.mdl",
	mat="models/bloocobalt/splinter cell/chemsuit/chemsuit_bm",
	lbl="EZ HEV SUIT",
	clr={ r=0, g=0, b=0 },
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
		[DMG_SLASH]=.90,
		[DMG_BURN]=.70
	},BasicArmorProtectionProfile),
	resist={
		[DMG_ACID]=.75,
		[DMG_POISON]=.80
	},
	chrg={
		chemicals=50
	},
	snds={
		eq="snd_jack_clothequip.wav",
		uneq="snd_jack_clothunequip.wav"
	},
	plymdl="models/ragenigga/player/hev_suit.mdl", -- https://steamcommunity.com/sharedfiles/filedetails/?id=1341386337&searchtext=hev+suit
	mskmat="mats_aboot_gmod_sprites/helmet_vignette1.png",
	sndlop="snds_jack_gmod/mask_breathe.wav",
	wgt=5,
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
--[[if(SERVER)then
end]]