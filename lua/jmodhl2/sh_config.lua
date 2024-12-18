local ShouldMergeRecipes = CreateConVar("jmod_hl2_merge_recipes", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Auto generates recipes for JMod HL2 items")

hook.Add("JMod_PostLuaConfigLoad", "JMod_HL2_PostLoadConfig", function(Config)
	local JModHL2Recipes = {
		["HL Welding Torch"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 25
			},
			results = "ent_aboot_gmod_ezwelder",
			category = "Tools",
			craftingType = { "workbench", "craftingtable" },
			description = "You can weld metal stuff with this thing."
		},
		["HL Welding Mask"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 15,
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 10
			},
			results = "ent_aboot_gmod_ezarmor_weldingmask",
			category = "Apparel",
			craftingType = { "workbench", "craftingtable" },
			description = "Protect your eyes from sun and welding flash."
		},
		["HL Grinder"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 120,
				[JMod.EZ_RESOURCE_TYPES.TUNGSTEN] = 15,
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 100
			},
			results = "ent_aboot_gmod_ezpowertools",
			sizeScale = 2,
			category = "Machines",
			craftingType = "toolbox",
			description = "Automatically salvages props that touch the blade."
		},
		["HL Ground Pounder"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 50,
				[JMod.EZ_RESOURCE_TYPES.TUNGSTEN] = 20,
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 75
			},
			results = "ent_aboot_gmod_ezpounder",
			sizeScale = 2,
			category = "Machines",
			craftingType = "toolbox",
			description = "Beats ground to get ore."
		},
		["HL Airboat Engine"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 80,
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 150
			},
			results = "ent_aboot_gmod_ezairboatengine",
			sizeScale = 4,
			category = "Machines",
			craftingType = "toolbox",
			description = "An engine for the airboat. Alt Use to cycle through modes."
		},
		["HL Capacitor"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.COPPER] = 30,
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 50
			},
			results = "ent_aboot_gmod_ezcapacitor",
			sizeScale = 0.2,
			category = "Machines",
			craftingType = "toolbox",
			description = "Electrifies all connected and touching metal props."
		},
		["HL Thumper"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 100,
				[JMod.EZ_RESOURCE_TYPES.TUNGSTEN] = 15,
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 200
			},
			results = "ent_aboot_gmod_ezthumper",
			sizeScale = 6,
			category = "Machines",
			craftingType = "toolbox",
			description = "Combine machine for extracting any minerals from the crust and scaring off antlions."
		},
		["HL Big Thumper"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 200,
				[JMod.EZ_RESOURCE_TYPES.TUNGSTEN] = 20,
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 250
			},
			results = "ent_aboot_gmod_ezthumperlarge",
			sizeScale = 10,
			category = "Machines",
			craftingType = "toolbox",
			description = "Massive Combine machine for extracting any resource from the crust and scaring off antlions."
		},
		["HL Combine Radio"] = {
			results = "ent_aboot_gmod_ezcombineradio",
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 100,
				[JMod.EZ_RESOURCE_TYPES.ADVANCEDPARTS] = 20
			},
			sizeScale = 4,
			category = "Machines",
			craftingType = "toolbox",
			description = "Order more supplies from your nearest Combine outpost. Rather violent delivery method though."
		},
		["HL Combine Sentry"] = {
			results = "ent_aboot_gmod_ezcombinesentry",
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 200,
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 50,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 25
			},
			sizeScale = 3,
			category = "Machines",
			craftingType = "toolbox",
			description = "For protecting long corridors or upgrading to be a sniper. Careful about knocking it over."
		},
		["HL Floor Sentry"] = {
			results = "ent_aboot_gmod_ezfloorsentry",
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 100,
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 50,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 30
			},
			sizeScale = 3,
			category = "Machines",
			craftingType = "toolbox",
			description = "Smaller turret with lower profile but is more obvious, great for dettering people from an area."
		},
		["HL Ammo Crate"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 70,
				[JMod.EZ_RESOURCE_TYPES.ALUMINUM] = 50
			},
			results = "ent_aboot_gmod_ezammocrate",
			sizeScale = 2,
			category = "Other",
			craftingType = "toolbox",
			description = "Can store a lot of ammunition."
		},
		["HL Shipping Container"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 900
			},
			results = "ent_aboot_gmod_ezshippingcontainer",
			sizeScale = 12,
			category = "Other",
			craftingType = "toolbox",
			description = "To store all your precious resources."
		},
		["HL Health Charger"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 100,
				[JMod.EZ_RESOURCE_TYPES.ADVANCEDPARTS] = 5
			},
			results = "ent_aboot_gmod_ezhealth_charger",
			category = "Other",
			craftingType = {"toolbox", "fabricator"},
			description = "Uses alien intravenous fluid to replenish your health."
		},
		["HL Shield Charger"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 100
			},
			results = "ent_aboot_gmod_ezsuit_charger",
			category = "Other",
			craftingType = {"toolbox", "fabricator"},
			description = "Changes normal electical power into a form useable for your suit's shields."
		},
		["HL Combine Grenade"] = {
			results = "ent_aboot_gmod_ezcombinenade",
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 10,
				[JMod.EZ_RESOURCE_TYPES.EXPLOSIVES] = 15
			},
			category = "Munitions",
			craftingType = "workbench",
			description = "Nicknamed roller, this is a very common grenade with the Combine for assaults and booby-traps alike."
		},
		["HL TeleNade"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 25,
				[JMod.EZ_RESOURCE_TYPES.ADVANCEDPARTS] = 5
			},
			results = "ent_aboot_gmod_eztelenade",
			category = "Other",
			craftingType = {"fabricator"},
			description = "Throw it and wait."
		},
		["HL Hopper Mine"] = {
			results = "ent_aboot_gmod_ezhoppermine",
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 15,
				[JMod.EZ_RESOURCE_TYPES.EXPLOSIVES] = 20
			},
			category = "Munitions",
			craftingType = "workbench",
			description = "This mine will try to jump at it's targets, only detonating on contact with a valid target."
		},
		["HL Hopper Hornet Mine"] = {
			results = "ent_aboot_gmod_ezhopperhornet",
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 15,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 5,
				[JMod.EZ_RESOURCE_TYPES.EXPLOSIVES] = 30
			},
			category = "Munitions",
			craftingType = "workbench",
			description = "This mine will jump high in the air and shoot a valid target with an EFP, extremely effective."
		},
		["HL Floating Mine"] = {
			results = "ent_aboot_gmod_ezhelibomb",
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 20,
				[JMod.EZ_RESOURCE_TYPES.EXPLOSIVES] = 40
			},
			category = "Munitions",
			craftingType = "workbench",
			description = "This mine will float and explode on contact with a valid target or after a short delay on hard imapct."
		},
		["HL Harpoon"] = {
			results = "ent_aboot_gmod_ezharpoon",
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.WOOD] = 15,
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 5
			},
			category = "Weapons",
			craftingType = {"handcraft", "craftingtable", "workbench"},
			description = "I hope you don't mind the taste of leeches."
		},
		["Zero Point Energy Field Manipulator"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 150,
				[JMod.EZ_RESOURCE_TYPES.FISSILEMATERIAL] = 10,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 50
			},
			results = "weapon_physcannon",
			category = "Tools",
			craftingType = { "fabricator" },
			description = "Device to carry heavy stuff."
		},
		["HL Crowbar"] = {
			results = "ent_aboot_gmod_ezcrowbar",
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 15
			},
			category = "Tools",
			craftingType = "workbench",
			description = "Oh, and before I forget, I think you dropped this back in Black Mesa!"
		},
		["HL Stun Baton"] = {
			results = "ent_aboot_gmod_ezstunstick",
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 15,
				[JMod.EZ_RESOURCE_TYPES.POWER] = 100
			},
			category = "Tools",
			craftingType = "workbench",
			description = "A stick to fufill your beating qouta with."
		},
		["HL 357 Magnum"] = {
			results = JModHL2.WeaponTable["357 Magnum"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 75,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 10
			},
			category = "Weapons",
			craftingType = "workbench",
			description = "A 357 Magnum 'python', commonly used by police in the past."
		},
		["HL USP 9mm"] = {
			results = JModHL2.WeaponTable["9mm Pistol"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 50,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 10
			},
			category = "Weapons",
			craftingType = "workbench",
			description = "A common 9mm pistol used by metrocops."
		},
		["HL Alyx's Gun"] = {
			results = JModHL2.WeaponTable["9mm Pistol"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 50,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 25
			},
			category = "Weapons",
			craftingType = "fabricator",
			description = "Extremely modified weapon based off of an apprently Colt 1911 design"
		},
		["HL API Sniper Rifle"] = {
			results = JModHL2.WeaponTable["API-SR"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 200,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 100
			},
			category = "Weapons",
			craftingType = "fabricator",
			description = "An Anti-materiel sniper rifle firing high power using 50. cal API rounds."
		},
		["HL Combine Sniper Rifle"] = {
			results = JModHL2.WeaponTable["CO-SR"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 30,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 100,
				[JMod.EZ_RESOURCE_TYPES.ADVANCEDPARTS] = 10
			},
			category = "Weapons",
			craftingType = "fabricator",
			description = "A Combine desgined sniper rifle. Fires via magnetics and auto-regenerates it's ammo."
		},
		["HL Pulse LMG"] = {
			results = JModHL2.WeaponTable["Pulse LMG"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 150,
				[JMod.EZ_RESOURCE_TYPES.ADVANCEDPARTS] = 10,
				[JMod.EZ_RESOURCE_TYPES.TITANIUM] = 25
			},
			category = "Weapons",
			craftingType = "fabricator",
			description = "A Combine desgined LMG. Auto-regenerates it's ammo."
		},
		["HL Pulse Rifle"] = {
			results = JModHL2.WeaponTable["Pulse Rifle"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 100,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 150,
				[JMod.EZ_RESOURCE_TYPES.TITANIUM] = 25
			},
			category = "Weapons",
			craftingType = "fabricator",
			description = "A Combine desgined high capacity pulse rifle."
		},
		["HL Brush Gun"] = {
			results = JModHL2.WeaponTable["Brush Gun"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 100,
				[JMod.EZ_RESOURCE_TYPES.WOOD] = 20,
				[JMod.EZ_RESOURCE_TYPES.ORGANICS] = 10
			},
			category = "Weapons",
			craftingType = "workbench",
			description = "A powerful lever action rifle, has 'Annabelle' scratched into it's stock."
		},
		["HL Assault Rifle"] = {
			results = JModHL2.WeaponTable["AR1"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 120,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 40
			},
			category = "Weapons",
			craftingType = "workbench",
			description = "Early assault rifle design that was initally issued by the Combine before being upgraded."
		},
		["HL GR9 LMG"] = {
			results = JModHL2.WeaponTable["GR9-LMG"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 150,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 110,
				[JMod.EZ_RESOURCE_TYPES.TITANIUM] = 25
			},
			category = "Weapons",
			craftingType = "workbench",
			description = "A scoped LMG used by special forces."
		},
		["HL MP5K"] = {
			results = JModHL2.WeaponTable["MP5K"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 120,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 25
			},
			category = "Weapons",
			craftingType = "workbench",
			description = "A highly manurverable submachine gun, easy to use while on the move and airborne."
		},
		["HL SMG1"] = {
			results = JModHL2.WeaponTable["SMG1"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 200,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 50,
				[JMod.EZ_RESOURCE_TYPES.TITANIUM] = 10
			},
			category = "Weapons",
			craftingType = "workbench",
			description = "A butchered submachine gun with an integrated grenade launcher."
		},
		["HL SMG2"] = {
			results = JModHL2.WeaponTable["SMG2"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 150,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 25
			},
			category = "Weapons",
			craftingType = "workbench",
			description = "A capable submachine gun with lots of attachment points."
		},
		["HL SPAS 13"] = {
			results = JModHL2.WeaponTable["SPAS-13"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 125,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 15
			},
			category = "Weapons",
			craftingType = "workbench",
			description = "A modified version of the SPAS-12 used by the Combine."
		},
		["HL Overwatch Infantry Combat Weapon"] = {
			results = JModHL2.WeaponTable["OICW"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 250,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 150,
				[JMod.EZ_RESOURCE_TYPES.TITANIUM] = 50
			},
			category = "Weapons",
			craftingType = "workbench",
			description = "Another early Combine weapon design, coppied off of a scrapped US weapon system."
		},
		["HL Overwatch Flamethrower"] = {
			results = "ent_aboot_gmod_ezosinc",
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 100,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 10,
				[JMod.EZ_RESOURCE_TYPES.RUBBER] = 10
			},
			category = "Weapons",
			craftingType = "workbench",
			description = "A short range flamethrower used for clearing out necrotic infestations."
		},
		["HL RPG Launcher"] = {
			results = JModHL2.WeaponTable["RPG Launcher"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 200,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 100
			},
			category = "Weapons",
			craftingType = "workbench",
			description = "An rpg with laser guidence capabilities."
		},
		["HL Combine Suit"] = {
			results = JMod.ArmorTable["ABoot Combine Suit"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.CHEMICALS] = 20,
				[JMod.EZ_RESOURCE_TYPES.ADVANCEDTEXTILES] = 150,
				[JMod.EZ_RESOURCE_TYPES.ADVANCEDPARTS] = 5,
				[JMod.EZ_RESOURCE_TYPES.RUBBER] = 40
			},
			category = "Apparel",
			craftingType = {"workbench", "fabricator"},
			description = "High tech full-body protection meant for Combine elite scouts."
		},
		["HL HEV Suit"] = {
			results = JMod.ArmorTable["ABoot HEV Suit"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.CHEMICALS] = 20,
				[JMod.EZ_RESOURCE_TYPES.ADVANCEDTEXTILES] = 150,
				[JMod.EZ_RESOURCE_TYPES.ADVANCEDPARTS] = 5,
				[JMod.EZ_RESOURCE_TYPES.RUBBER] = 40
			},
			category = "Apparel",
			craftingType = {"workbench", "fabricator"},
			description = "Hazardous EnViromental suit. But it also has a helmet this time."
		},
		["HL Jet Module"] = {
			results = JMod.ArmorTable["ABoot Jet Module"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 120,
				[JMod.EZ_RESOURCE_TYPES.ADVANCEDPARTS] = 5,
				[JMod.EZ_RESOURCE_TYPES.TITANIUM] = 20
			},
			category = "Apparel",
			craftingType = {"fabricator"},
			description = "A short range jetpack that needs to be recharged frequently."
		},
		["HL Jump Module"] = {
			results = JMod.ArmorTable["ABoot Jump Module"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 150,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 5,
				[JMod.EZ_RESOURCE_TYPES.TITANIUM] = 20
			},
			category = "Apparel",
			craftingType = {"workbench", "fabricator"},
			description = "A jump pack that uses pressurized gas to jump over gaps and obstacles."
		},
		["HL Longfall Boots"] = {
			results = JMod.ArmorTable["Longfall Boots"].ent,
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 50,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 5,
				[JMod.EZ_RESOURCE_TYPES.TITANIUM] = 10
			},
			category = "Apparel",
			craftingType = {"workbench", "fabricator"},
			description = "A foot based suit of armor for the dual portal device."
		},
		--[[["Physics Manipulator"] = {
			craftingReqs = {
				["basic parts"] = 300,
				["fissile material"] = 15,
				["precision parts"] = 150
			},
			results = "weapon_physgun",
			category = "Tools",
			craftingType = { "fabricator" },
			description = "Very advanced device to carry heavy stuff."
		},--]]
		--[[["HL Utility Crate"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 150
			},
			results = "ent_fumo_gmod_ezutilitycrate",
			sizeScale = 2,
			category = "Other",
			craftingType = "toolbox",
			description = "To store not all your precious resources."
		},
		["HL Campfire"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.CERAMIC] = 25,
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 50,
				[JMod.EZ_RESOURCE_TYPES.WOOD] = 25
			},
			results = "ent_fumo_gmod_ezcampfire",
			sizeScale = 1,
			category = "Other",
			craftingType = "toolbox",
			description = "Smelts all your stuff."
		},
		["HL Health Kit"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 15,
				[JMod.EZ_RESOURCE_TYPES.MEDICALSUPPLIES] = 10,
				[JMod.EZ_RESOURCE_TYPES.ORGANICS] = 5
			},
			results = "ent_fumo_gmod_ezhealtkit",
			category = "Other",
			craftingType = { "fabricator" },
			description = "Heals you by 25 health."
		},
		["HL Health Vial"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 5,
				[JMod.EZ_RESOURCE_TYPES.MEDICALSUPPLIES] = 5,
				[JMod.EZ_RESOURCE_TYPES.ORGANICS] = 2
			},
			results = "ent_fumo_gmod_ezhealthvial",
			category = "Other",
			craftingType = { "fabricator" },
			description = "Heals you by 10 health."
		},
		["HL Suit Battery"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 10,
				[JMod.EZ_RESOURCE_TYPES.POWER] = 30,
			},
			results = "ent_fumo_gmod_ezsuitbattery",
			category = "Other",
			craftingType = { "fabricator" },
			description = "Adds 15 suit energy."
		},
		["HL Standard Ration"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 5,
				[JMod.EZ_RESOURCE_TYPES.NUTRIENTS] = 10,
				[JMod.EZ_RESOURCE_TYPES.PLASTIC] = 5
			},
			results = "ent_fumo_gmod_ezration",
			category = "Other",
			craftingType = { "fabricator" },
			description = "Meal ready to eat."
		}--]]
	}

	if ShouldMergeRecipes:GetBool() then
		table.Merge(JMod.Config.Craftables, JModHL2Recipes, true)
		print("JMOD-HL2: recipes merged")
	end
end)