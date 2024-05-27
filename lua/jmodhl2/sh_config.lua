local ShouldMergeRecipes = CreateConVar("jmod_hl2_merge_recipes", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Auto generates recipes for JMod HL2 items")

hook.Add("JMod_PostLuaConfigLoad", "JMod_HL2_PostLoadConfig", function(Config)
	local JModHL2Recipes = {
		["EZ Welding Torch"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 25
			},
			results = "ent_aboot_gmod_ezwelder",
			category = "Tools",
			craftingType = { "workbench", "craftingtable" },
			description = "You can weld metal stuff with this thing."
		},
		["EZ Welding Mask"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 15,
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 10
			},
			results = "ent_aboot_gmod_ezarmor_weldingmask",
			category = "Apparel",
			craftingType = { "workbench", "craftingtable" },
			description = "Protect your eyes from sun and welding flash."
		},
		["EZ Grinder"] = {
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
		["EZ Ammo Crate"] = {
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
		["EZ Capacitor"] = {
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
		["EZ Ground Pounder"] = {
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
		["EZ Shipping Container"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 900
			},
			results = "ent_aboot_gmod_ezshippingcontainer",
			sizeScale = 12,
			category = "Other",
			craftingType = "toolbox",
			description = "To store all your precious resources."
		},
		["EZ TeleNade"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 25,
				[JMod.EZ_RESOURCE_TYPES.FISSILEMATERIAL] = 5,
				[JMod.EZ_RESOURCE_TYPES.PRECISIONPARTS] = 50
			},
			results = "ent_aboot_gmod_eztelenade",
			category = "Other",
			craftingType = { "fabricator" },
			description = "Throw it and wait."
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
		--[[["EZ Utility Crate"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.STEEL] = 150
			},
			results = "ent_fumo_gmod_ezutilitycrate",
			sizeScale = 2,
			category = "Other",
			craftingType = "toolbox",
			description = "To store not all your precious resources."
		},
		["EZ Campfire"] = {
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
		["EZ Health Kit"] = {
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
		["EZ Health Vial"] = {
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
		["EZ Suit Battery"] = {
			craftingReqs = {
				[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 10,
				[JMod.EZ_RESOURCE_TYPES.POWER] = 30,
			},
			results = "ent_fumo_gmod_ezsuitbattery",
			category = "Other",
			craftingType = { "fabricator" },
			description = "Adds 15 suit energy."
		},
		["EZ Standard Ration"] = {
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
		table.Merge(JModHL2Recipes, JMod.Config.Craftables, true)
	end
end)