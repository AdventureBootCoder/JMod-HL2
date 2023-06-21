JModHL2.WeaponTable = {
	["Pulse Rifle"] = {
		mdl = "models/weapons/aboot/ar2/w_iiopnirifle.mdl",
		swep = "wep_aboot_jmod_ar2",
		ent = "ent_aboot_jmod_ezweapon_ar2",
		category = "JMod - EZ HL:2"
	},
	["Annabelle"] = {
		mdl = "models/weapons/annabelle/w_annabelle.mdl",
		swep = "wep_aboot_jmod_annabelle",
		ent = "ent_aboot_jmod_ezweapon_annabelle",
		category = "JMod - EZ HL:2"
	},
	[".357 Python"] = {
		mdl = "models/weapons/aboot/ar2/w_iiopnirifle.mdl",
		swep = "wep_aboot_jmod_ar2",
		ent = "ent_aboot_jmod_ezweapon_ar2",
		category = "JMod - EZ HL:2"
	},
	["Pulse LMG"] = {
		mdl = "models/weapons/aboot/tfa_mmod/w_ar3.mdl",
		swep = "wep_aboot_jmod_ar3",
		ent = "ent_aboot_jmod_ezweapon_ar3",
		category = "JMod - EZ HL:2"
	},
	["SPAS-12"] = {
		mdl = "models/weapons/aboot/w_IIopnshotgun.mdl",
		swep = "wep_aboot_jmod_spas",
		ent = "ent_aboot_jmod_ezweapon_spas",
		category = "JMod - EZ HL:2"
	},
	["RPG Launcher"] = {
		mdl = "models/weapons/w_rocket_launcher.mdl",
		swep = "wep_aboot_jmod_rpg",
		ent = "ent_aboot_jmod_ezweapon_rpg"
	}
}

-- keepcorpses caauses floating arrow bug
JModHL2.AmmoTable = {
	["Light Pulse Ammo"] = {
		resourcetype = "ammo",
		sizemult = .5,
		carrylimit = 720,
		basedmg = 40,
		effrange = 90,
		terminaldmg = 5,
		penetration = 35
	},
	["Heavy Pulse Ammo"] = {
		carrylimit = 100,
		basedmg = 45,
		effrange = 110,
		terminaldmg = 10,
		penetration = 45
	}
}

JMod.LoadAmmoTable(JModHL2.AmmoTable)
JMod.GenerateWeaponEntities(JModHL2.WeaponTable)