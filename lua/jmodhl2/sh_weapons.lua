JMod = JMod or {}
JMod.AdditionalAmmoTable = JMod.AdditionalAmmoTable or {}
JMod.AdditionalWeaponTable = JMod.AdditionalWeaponTable or {}

JModHL2.WeaponTable = {
	["Pulse Rifle"] = {
		mdl = "models/weapons/aboot/ar2/w_iiopnirifle.mdl",
		swep = "wep_aboot_jmod_ar2",
		ent = "ent_aboot_jmod_ezweapon_ar2",
		Category = "JMod - EZ HL:2"
	},
	["Annabelle"] = {
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
	["Crowbar"] = {
		mdl = "models/weapons/w_crowbar.mdl",
		swep = "wep_aboot_jmod_crowbar",
		ent = "ent_aboot_jmod_ezweapon_crowbar",
		Category = "JMod - EZ HL:2"
	}
}

-- keepcorpses caauses floating arrow bug
JModHL2.AmmoTable = {
	["Light Pulse Ammo"] = {
		resourcetype = "ammo",
		sizemult = .5,
		carrylimit = 720,
		basedmg = 30,
		effrange = 90,
		terminaldmg = 5,
		penetration = 35,
		tracer = "tfa_mmod_tracer_ar2"
	},
	["Heavy Pulse Ammo"] = {
		resourcetype = false,
		carrylimit = 100,
		basedmg = 30,
		effrange = 110,
		terminaldmg = 10,
		penetration = 45,
		tracer = "tfa_mmod_tracer_ar3",
		dmgtype = DMG_AIRBOAT
	},
	["20mm Grenade"] = {
		resourcetype = "munitions",
		carrylimit = 12,
		basedmg = 80,
		effrange = 80,
		terminaldmg = 50,
		penetration = 1
	},
	["RPG Rocket"] = {
		resourcetype = "munitions",
		sizemult = 40,
		carrylimit = 4,
		ent = "ent_aboot_gmod_ezhl2rocket",
		nicename = "EZ RPG Rocket",
		basedmg = 350,
		blastrad = 200,
		dmgtype = DMG_BLAST
	}
}

table.Merge(JMod.AdditionalWeaponTable, JModHL2.WeaponTable)
table.Merge(JMod.AdditionalAmmoTable, JModHL2.AmmoTable)

function JModHL2.LoadAdditionalAmmo()
	if JMod.AdditionalAmmoTable then
		table.Merge(JMod.AmmoTable, JMod.AdditionalAmmoTable)
		JMod.LoadAmmoTable(JMod.AdditionalAmmoTable)
	end
end
hook.Add("Initialize", "JMod_LoadAdditionalAmmo", JModHL2.LoadAdditionalAmmo)

function JModHL2.LoadAdditionalWeaponEntities()
	if JMod.AdditionalWeaponTable then
		table.Merge(JMod.WeaponTable, JMod.AdditionalWeaponTable)
		JMod.GenerateWeaponEntities(JMod.AdditionalWeaponTable)
	end
end
hook.Add("Initialize", "JMod_LoadAdditionalWeaponEntities", JModHL2.LoadAdditionalWeaponEntities)

--JModHL2.LoadAdditionalAmmo()
--JModHL2.LoadAdditionalWeaponEntities()

function JModHL2.GetAmmoSpecs(typ)
	if not JModHL2.AmmoTable[typ] then return nil end
	local Result, BaseType = table.FullCopy(JModHL2.AmmoTable[typ]), string.Split(typ, "-")[1]

	return table.Inherit(Result, JModHL2.AmmoTable[BaseType])
end

function JModHL2.ApplyAmmoSpecs(wep, typ, mult)
	--[[timer.Simple(1, function()
		JMod.ApplyAmmoSpecs(wep, typ, mult) 
	end)]]--
	mult = mult or 1
	wep.Primary.Ammo = typ
	local Specs = JModHL2.GetAmmoSpecs(typ)
	if not Specs then 
		timer.Simple(1, function()
			JMod.ApplyAmmoSpecs(wep, typ, mult) 
		end)

		return
	end
	wep.Damage = Specs.basedmg * mult
	wep.Num = Specs.projnum or 1

	if Specs.effrange then
		wep.Range = Specs.effrange
	end

	if Specs.terminaldmg then
		wep.DamageMin = Specs.terminaldmg * mult
	end

	if Specs.penetration then
		wep.Penetration = Specs.penetration
	end

	if Specs.blastrad then
		wep.BlastRadius = Specs.blastrad
	end

	if Specs.dmgtype then
		wep.DamageType = Specs.dmgtype
	end

	if Specs.expanding then
		wep.EZexpangingAmmo = Specs.expanding
	end

	if Specs.armorpiercing then
		wep.EZarmorpiercingAmmo = Specs.armorpiercing
	end

	-- todo: implement this when we add these types
	if Specs.tracer then
		wep.Tracer = Specs.tracer
	else
		wep.Tracer = nil
	end
end