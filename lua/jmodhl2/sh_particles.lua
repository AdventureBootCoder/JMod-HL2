local function AddParticles()
	--game.AddParticles("particles/grenade_rpg.pcf")
	--game.AddParticles("particles/weapon_hgun.pcf")
	--game.AddParticles("particles/weapon_rpg.pcf")
	--game.AddParticles("particles/weapon_magnum.pcf")
	--game.AddParticles("particles/weapon_glock.pcf")
	--game.AddParticles("particles/weapon_mp5.pcf")
	--game.AddParticles("particles/weapon_shotgun.pcf")
	game.AddParticles("particles/weapon_tracer.pcf")
	game.AddParticles("particles/hl2mmod_explosions.pcf")
	game.AddParticles("particles/hl2mmod_muzzleflashes.pcf")
	game.AddParticles("particles/hl2mmod_tracers.pcf")
	game.AddParticles("particles/hl2mmod_weaponeffects.pcf")

	PrecacheParticleSystem("hl2mmod_explosion_grenade")
	PrecacheParticleSystem("hl2mmod_explosion_rpg")
	PrecacheParticleSystem("hl2mmod_explosion_grenade_noaftersmoke")

end
pcall(AddParticles)

local function AddCustomAmmo()
	game.AddAmmoType({
		name = "Regenerating-AR3",
		maxcarry = 100
	})
end

timer.Simple(1, function()
	pcall(AddCustomAmmo) -- make sure they're added
end)