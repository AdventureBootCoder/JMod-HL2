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
--	game.AddParticles("particles/hl2mmod_muzzleflash_ar2.pcf")

	PrecacheParticleSystem("hl2mmod_explosion_grenade")
end
pcall(AddParticles)