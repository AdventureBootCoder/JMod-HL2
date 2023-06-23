JMod = JMod or {}

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
		blastrad = 200
	}
}

function JModHL2.LoadAmmoTable(tbl)
	timer.Simple(1, function()
		if JMod.AmmoTable then
			table.Merge(JMod.AmmoTable, tbl)
		end
	end)
		
	for k, v in pairs(tbl) do
		v.carrylimit = v.carrylimit or -2
		game.AddAmmoType({
			name = k,
			maxcarry = v.carrylimit,
			npcdmg = v.basedmg,
			plydmg = v.basedmg,
			dmgtype = v.dmgtype or DMG_BULLET
		})
		if SERVER then
			timer.Simple(1, function()
				if (v.resourcetype) and (v.resourcetype == "munitions") then
					if not(table.HasValue(JMod.Config.Weapons.AmmoTypesThatAreMunitions, k)) then
						table.insert(JMod.Config.Weapons.AmmoTypesThatAreMunitions, k)
					end
				elseif not(v.resourcetype) then
					if not(table.HasValue(JMod.Config.Weapons.WeaponAmmoBlacklist, k)) then
						table.insert(JMod.Config.Weapons.WeaponAmmoBlacklist, k)
					end
				end
			end)
		end

		if CLIENT then
			language.Add(k .. "_ammo", k)

			if v.ent then
				language.Add(v.ent, v.nicename)
			end
		end
	end
end

-- Dynamically create weapon Ents
function JModHL2.GenerateWeaponEntities(tbl)
	timer.Simple(1, function()
		if JMod.WeaponTable then
			table.Merge(JMod.WeaponTable, tbl)
		end
	end)
	for name, info in pairs(tbl) do
		if info.noent then continue end

		local WeaponEnt = {}
		WeaponEnt.Base = "ent_jack_gmod_ezweapon"
		WeaponEnt.PrintName = info.PrintName or name
		if info.Spawnable == nil then
			WeaponEnt.Spawnable = true
		else
			WeaponEnt.Spawnable = info.Spawnable
		end
		WeaponEnt.AdminOnly = info.AdminOnly or false
		WeaponEnt.Category = info.Category or "JMod - EZ HL:2"
		WeaponEnt.WeaponName = name
		WeaponEnt.ModelScale = info.gayPhysics and nil or info.size -- or math.max(info.siz.x, info.siz.y, info.siz.z)
		scripted_ents.Register(WeaponEnt, info.ent)

		if CLIENT then
			language.Add(info.ent, name)
		end
	end
end

function JModHL2.ApplyAmmoSpecs(wep, typ, mult)
	timer.Simple(1, function()
		JMod.ApplyAmmoSpecs(wep, typ, mult) 
	end)
end

JModHL2.LoadAmmoTable(JModHL2.AmmoTable)
JModHL2.GenerateWeaponEntities(JModHL2.WeaponTable)