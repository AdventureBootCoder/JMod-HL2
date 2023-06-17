SWEP.Base = "wep_jack_gmod_gunbase"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Half-Life" -- edit this if you like
SWEP.AdminOnly = false
SWEP.PrintName = ".357 Magnum"
SWEP.Slot = 1
SWEP.ViewModel = "models/weapons/tfa_mmod/c_357.mdl"
SWEP.WorldModel = "models/weapons/tfa_mmod/w_357.mdl"
SWEP.ViewModelFOV = 60
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(6, 2, -3),
    ang = Angle(-10, 180, 180)
}
SWEP.BodyHolsterSlot = "thighs"
SWEP.BodyHolsterAng = Angle(0, 180, 75)
SWEP.BodyHolsterAngL = Angle(-10, 180, 85)
SWEP.BodyHolsterPos = Vector(2, 8, -3)
SWEP.BodyHolsterPosL = Vector(0, 0, 0)
---
SWEP.CustomToggleCustomizeHUD = false
---
SWEP.DefaultBodygroups = "00000000000"
SWEP.Damage = 80
SWEP.DamageMin = 60

SWEP.Range = 60 -- in METRES
SWEP.RangeMin = 30
SWEP.Penetration = 12
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 6 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 6
SWEP.ReducedClipSize = 6

SWEP.PhysBulletMuzzleVelocity = 700

SWEP.Recoil = 1
SWEP.RecoilSide = 0.1
SWEP.RecoilRise = 0.5
SWEP.MaxRecoilBlowback = -1
SWEP.VisualRecoilMult = 3.5
SWEP.RecoilPunch = 3
SWEP.RecoilPunchBackMax = 2
SWEP.RecoilPunchBackMaxSights = nil -- may clip with scopes
SWEP.RecoilVMShake = 3 -- random viewmodel offset when shooty
SWEP.Delay = 60 / 100 -- 60 / RPM.
SWEP.Firemodes = {
	{
		Mode = 1,
		PrintName = "DOUBLE-ACTION"
	},
	{
		Mode = 0
	}
}

SWEP.NPCWeaponType = "weapon_357"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 0 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 200 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 50
SWEP.SightsDispersion = 0

SWEP.Primary.Ammo = "Magnum Pistol Round" -- what ammo type the gun uses
SWEP.MagID = "Magnum Pistol Round" -- the magazine pool this gun draws from

SWEP.ShootVol = 150 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "JMOD_HL2.357.1"
SWEP.DistantShootSound = "JMOD_HL2.357.NPC"

SWEP.MuzzleEffect = "muzzleflash_minimi"
SWEP.ShellModel = "models/shells/shell_57.mdl"
SWEP.ShellScale = 1
SWEP.ShellMaterial = nil
SWEP.MuzzleFlashColor = Color(255, 150, 0)
SWEP.GMMuzzleEffect = false
SWEP.RevolverReload = true -- cases all eject on reload

SWEP.MirrorVMWM = false -- Copy the viewmodel, along with all its attachments, to the worldmodel. Super convenient!
SWEP.MirrorWorldModel = true -- Use this to set the mirrored viewmodel to a different model, without any floating speedloaders or cartridges you may have. Needs MirrorVMWM

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.8
SWEP.SightTime = 0.22

SWEP.FreeAimAngle = nil -- defaults to HipDispersion / 80. overwrite here
SWEP.NeverFreeAim = nil
SWEP.AlwaysFreeAim = nil

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerFinalMag = 0 -- the last X bullets in a magazine are all tracers
SWEP.Tracer = "arccw_tracer" -- override tracer (hitscan) effect
SWEP.HullSize = 0 -- HullSize used by FireBullets

SWEP.BodyDamageMults = {
    [HITGROUP_HEAD] = 1.34,
 }

SWEP.Force = 40

SWEP.IronSightStruct = {
    Pos = Vector(-3.19, -2, 1.2),
    Ang = Angle(0.1, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = false
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "revolver"
SWEP.HoldtypeSights = "revolver"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER

SWEP.ActivePos = Vector(0,0,0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-1, -2, -1)
SWEP.CrouchAng = Angle(0, 0, -15)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.NoHideLeftHandInCustomization = true
SWEP.CustomizePos = Vector(17, -12, 1)
SWEP.CustomizeAng = Angle(10, 50, 30)

SWEP.SprintPos = Vector( -0.0637, 0, 0.1897 )
SWEP.SprintAng = Angle( -11.0898, 9.5787, -10.7118 )

SWEP.BarrelLength = 24

SWEP.AttachmentElements = {
}

SWEP.ExtraSightDist = 10

SWEP.Attachments = {
	{
		PrintName = "Optic", -- print name
		DefaultAttName = "Iron Sights",
		Slot = "optic", -- what kind of attachments can fit here, can be string or table
		Bone = "357_weapon", -- relevant bone any attachments will be mostly referring to
		Offset = {
			vpos = Vector(2.8, -6, 0), -- offset that the attachment will be relative to the bone
			vang = Angle(0, 90, 90),
			wpos = Vector(10, 1.75, -5.5),
			wang = Angle(-10, -2, 183)
		},
		--[[SlideAmount={ -- how far this attachment can slide in both directions.
			-- overrides Offset.
			vmin=Vector(0.8, -5.715, -4),
			vmax=Vector(0.8, -5.715, -0.5),
			wmin=Vector(5.36, 0.739, -5.401),
			wmax=Vector(5.36, 0.739, -5.401),
		},]]--
		--InstalledEles = {"noch"},
		CorrectiveAng = Angle(180, 0, 0),
		CorrectivePos = Vector(0, 0, 0)
	},
	{
		PrintName = "Muzzle", -- print name
		DefaultAttName = "Default",
		Slot = "muzzle", -- what kind of attachments can fit here, can be string or table
		Bone = "357_weapon", -- relevant bone any attachments will be mostly referring to
		Offset = {
			vpos = Vector(2.2, -10.5, 0), -- offset that the attachment will be relative to the bone
			vang = Angle(0, 90, 90),
			wpos = Vector(10, 1.75, -5.5),
			wang = Angle(-10, -2, 183)
		},
		--[[SlideAmount={ -- how far this attachment can slide in both directions.
			-- overrides Offset.
			vmin=Vector(0.8, -5.715, -4),
			vmax=Vector(0.8, -5.715, -0.5),
			wmin=Vector(5.36, 0.739, -5.401),
			wmax=Vector(5.36, 0.739, -5.401),
		},]]--
		--InstalledEles = {"noch"},
	}
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle1",
    },
    ["enter_sight"] = {
        Source = "idle_ironsighted",
    },
    ["idle_sights"] = {
        Source = "idle_ironsighted",
    },
    ["draw"] = {
        Source = "draw",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.5,
    },
    ["holster"] = {
        Source = "holster",
    },
    ["fire"] = {
        Source = {"fire"},
		
    },
    ["fire_sights"] = {
        Source = {"fire_is"},
    },
    ["enter_inspect"] = {
        Source = {"inspect","inspect2"},
    },
    ["reload"] = {
        Source = "reload",
		ShellEjectAt = 0,
		Mult = 0.8,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
    },
}

sound.Add({
	name = 			"JMOD_HL2.357.1",
	channel = 		CHAN_WEAPON,
	level = SNDLVL_GUNFIRE,
	volume = 		1.0,
	pitch = {95, 110},
	sound = 			{"weapons/tfa_mmod/357/357_fire1.wav","weapons/tfa_mmod/357/357_fire2.wav","weapons/tfa_mmod/357/357_fire3.wav"}
})

sound.Add({
	name = 			"JMOD_HL2.357.NPC",
	channel = 		CHAN_ITEM,
	level = 140,
	volume = 		0.25,
	pitch = {60, 70},
	sound = 			{"weapons/tfa_mmod/357/357_fire1.wav","weapons/tfa_mmod/357/357_fire2.wav","weapons/tfa_mmod/357/357_fire3.wav"}
})

sound.Add({
	name = 			"JMOD_HL2.357.Draw",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/357/357_deploy.wav"
})

sound.Add({
	name = 			"JMOD_HL2.357.Fidget_Spinner",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/357/357_spin2.wav"
})

sound.Add({
	name = 			"JMOD_HL2.357.OpenLoader",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/357/357_reload1.wav"
})

sound.Add({
	name = 			"JMOD_HL2.357.Spin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/357/357_spin1.wav"
})

sound.Add({
	name = 			"JMOD_HL2.357.RemoveLoader",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/357/357_reload2.wav"
})

sound.Add({
	name = 			"JMOD_HL2.357.ReplaceLoader",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/357/357_reload3.wav"
})

sound.Add({
	name = 			"JMOD_HL2.357.CloseLoader",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/357/357_reload4.wav"
})

sound.Add({
	name = 			"JMOD_HL2.357.Hammer_Pull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/357/357_hammerpull.wav"
})

sound.Add({
	name = 			"JMOD_HL2.357.Hammer_Release",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/357/357_hammerrelease.wav"
})