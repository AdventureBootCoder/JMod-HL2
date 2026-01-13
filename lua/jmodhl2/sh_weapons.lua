JMod = JMod or {}

JModHL2.WeaponTable = {
	["Pulse Rifle"] = {
		mdl = "models/weapons/aboot/ar2/w_iiopnirifle.mdl",
		swep = "wep_aboot_jmod_ar2",
		ent = "ent_aboot_jmod_ezweapon_ar2",
		Category = "JMod - EZ HL:2"
	},
	["Brush Gun"] = {
		mdl = "models/weapons/annabelle/w_annabelle.mdl",
		swep = "wep_aboot_jmod_annabelle",
		ent = "ent_aboot_jmod_ezweapon_annabelle",
		Category = "JMod - EZ HL:2"
	},
	["357 Magnum"] = {
		mdl = "models/weapons/aboot/w_357.mdl",
		swep = "wep_aboot_jmod_357",
		ent = "ent_aboot_jmod_ezweapon_python",
		Category = "JMod - EZ HL:2"
	},
	["9mm Pistol"] = {
		mdl = "models/weapons/aboot/w_iiopnpistol.mdl",
		swep = "wep_aboot_jmod_usp9mm",
		ent = "ent_aboot_jmod_ezweapon_usp",
		Category = "JMod - EZ HL:2"
	},
	["Pulse LMG"] = {
		mdl = "models/weapons/aboot/tfa_mmod/w_ar3.mdl",
		swep = "wep_aboot_jmod_ar3",
		ent = "ent_aboot_jmod_ezweapon_ar3",
		Category = "JMod - EZ HL:2"
	},
	["RPG Launcher"] = {
		mdl = "models/weapons/w_rocket_launcher.mdl",
		swep = "wep_aboot_jmod_rpg",
		ent = "ent_aboot_jmod_ezweapon_rpg",
		Category = "JMod - EZ HL:2"
	},
	["SPAS-13"] = {
		mdl = "models/weapons/aboot/w_IIopnshotgun.mdl",
		swep = "wep_aboot_jmod_spas",
		ent = "ent_aboot_jmod_ezweapon_spas",
		Category = "JMod - EZ HL:2"
	},
	["SMG1"] = {
		mdl = "models/weapons/aboot/tfa_mmod/w_smg1.mdl",
		swep = "wep_aboot_jmod_smg1",
		ent = "ent_aboot_jmod_ezweapon_smg1",
		Category = "JMod - EZ HL:2"
	},
	["MP5K"] = {
		mdl = "models/weapons/aboot/mp5k/w_mp5k.mdl",
		swep = "wep_aboot_jmod_mp5k",
		ent = "ent_aboot_jmod_ezweapon_mp5k",
		Category = "JMod - EZ HL:2"
	},
	["OICW"] = {
		mdl = "models/weapons/aboot/oicw/w_oicw.mdl",
		swep = "wep_aboot_jmod_oicw",
		ent = "ent_aboot_jmod_ezweapon_oicw",
		Category = "JMod - EZ HL:2"
	},
	["GR9-LMG"] = {
		mdl = "models/weapons/aboot/hmg/w_gr9.mdl",
		swep = "wep_aboot_jmod_gr9",
		ent = "ent_aboot_jmod_ezweapon_gr9",
		Category = "JMod - EZ HL:2"
	},
	["AR1"] = {
		mdl = "models/weapons/aboot/akm/w_akm.mdl",
		swep = "wep_aboot_jmod_akm",
		ent = "ent_aboot_jmod_ezweapon_akm",
		Category = "JMod - EZ HL:2"
	},
	["SMG2"] = {
		mdl = "models/weapons/aboot/smg2/w_smg1.mdl",
		swep = "wep_aboot_jmod_smg2",
		ent = "ent_aboot_jmod_ezweapon_smg2",
		Category = "JMod - EZ HL:2"
	},
	["API-SR"] = {
		mdl = "models/weapons/aboot/sniper/w_sniper.mdl",
		swep = "wep_aboot_jmod_apisr",
		ent = "ent_aboot_jmod_ezweapon_apisr",
		Category = "JMod - EZ HL:2"
	},
	["CO-SR"] = {
		mdl = "models/weapons/aboot/combsr/w_combinesniper_e2.mdl",
		swep = "wep_aboot_jmod_combsr",
		ent = "ent_aboot_jmod_ezweapon_combsr",
		Category = "JMod - EZ HL:2"
	},
	["Alyx Gun"] = {
		mdl = "models/weapons/alyxgun/alyxgun.mdl",
		swep = "wep_aboot_jmod_alyxgun",
		ent = "ent_aboot_jmod_ezweapon_alyxgun",
		Category = "JMod - EZ HL:2"
	},--]]
	--[[["Crowbar"] = {
		mdl = "models/weapons/w_crowbar.mdl",
		swep = "wep_aboot_jmod_crowbar",
		ent = "ent_aboot_jmod_ezweapon_crowbar",
		Category = "JMod - EZ HL:2"
	},
	["Stun Baton"] = {
		mdl = "models/weapons/w_stunbaton.mdl",
		swep = "wep_aboot_jmod_baton",
		ent = "ent_aboot_jmod_ezweapon_baton",
		Category = "JMod - EZ HL:2"
	}--]]
}

JModHL2.AmmoTable = {
	["Light Pulse Ammo"] = {
		resourcetype = "ammo",
		sizemult = .5,
		carrylimit = 720,
		basedmg = 30,
		effrange = 90,
		terminaldmg = 5,
		penetration = 25,
		tracer = "tfa_mmod_tracer_ar2"
	},
	["Heavy Pulse Ammo"] = {
		resourcetype = false,
		carrylimit = 100,
		basedmg = 25,
		effrange = 95,
		terminaldmg = 10,
		penetration = 25,
		tracer = "tfa_mmod_tracer_ar3",
		dmgtype = DMG_AIRBOAT
	},
	["Sniper Pulse Ammo"] = {
		resourcetype = false,
		carrylimit = 50,
		basedmg = 80,
		effrange = 200,
		terminaldmg = 20,
		penetration = 25,
		tracer = "tfa_mmod_tracer_ar3",
		dmgtype = DMG_SNIPER
	},
	["Heavy Rifle Round-API"] = {
		resourcetype = "munitions",
		sizemult = 24,
		carrylimit = 25,
		basedmg = 200,
		effrange = 300,
		terminaldmg = 30,
		penetration = 120
	},
	["25mm Grenade"] = {
		resourcetype = "munitions",
		carrylimit = 12,
		basedmg = 80,
		effrange = 80,
		terminaldmg = 50,
		penetration = 1
	},
	["RPG Round"] = {
		resourcetype = "munitions",
		sizemult = 40,
		carrylimit = 4,
		ent = "ent_aboot_gmod_ezhl2rocket",
		nicename = "EZ RPG Round",
		basedmg = 350,
		blastrad = 200,
		dmgtype = DMG_BLAST
	}
}

-- Register using the new hook system - runs AFTER JMod base ammo
hook.Add("JMod_RegisterAmmoTypes", "JModHL2", function()
	JMod.LoadAmmoTable(JModHL2.AmmoTable)
end)

hook.Add("JMod_RegisterWeaponEntities", "JModHL2", function()
	JMod.GenerateWeaponEntities(JModHL2.WeaponTable)
end)
