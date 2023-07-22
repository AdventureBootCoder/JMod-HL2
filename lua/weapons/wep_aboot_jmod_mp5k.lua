SWEP.Base = "wep_jack_gmod_gunbase"
SWEP.Spawnable = false
SWEP.Category = "ArcCW - Half-Life" -- edit this if you like
SWEP.AdminOnly = false
SWEP.PrintName = "MP5K"
SWEP.Slot = 2

SWEP.ViewModel = "models/weapons/aboot/mp5k/c_mp5k.mdl"
SWEP.WorldModel = "models/weapons/aboot/mp5k/w_mp5k.mdl"
SWEP.ViewModelFOV = 70
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(6, 2, -4),
    ang = Angle(-10, 180, 180)
}
SWEP.ProceduralIronFire = true
SWEP.DefaultBodygroups = "00000000000"
SWEP.CustomToggleCustomizeHUD = false

--SWEP.Damage = 9
--SWEP.DamageMin = 3

SWEP.Range = 50 -- in METRES
SWEP.RangeMin = 20
SWEP.Penetration = 4
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity

JModHL2.ApplyAmmoSpecs(SWEP, "Pistol Round", 1.2)

-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 32 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 45
SWEP.ReducedClipSize = 25

SWEP.PhysBulletMuzzleVelocity = 700


SWEP.Recoil = 0.1
SWEP.RecoilSide = 0.35
SWEP.RecoilRise = 0.2
SWEP.MaxRecoilBlowback = 4
SWEP.VisualRecoilMult = 2
SWEP.RecoilPunch = 2
SWEP.RecoilPunchBackMax = 4
SWEP.RecoilPunchBackMaxSights = nil -- may clip with scopes
SWEP.RecoilVMShake = 8 -- random viewmodel offset when shooty

SWEP.Delay = 60 / 900 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
	{
		Mode = 3,
	},
    {
        Mode = 2,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_smg1"
SWEP.NPCWeight = 100

SWEP.Force = 4

SWEP.AccuracyMOA = 5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 600 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 100
SWEP.SightsDispersion = 100

SWEP.Primary.Ammo = "smg1" -- what ammo type the gun uses
SWEP.MagID = "smg1" -- the magazine pool this gun draws from

SWEP.ShootVol = 80 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "Weapon_SMG2.Fire"
SWEP.DistantShootSound = "Weapon_SMG2.NPC"

SWEP.MirrorVMWM = false -- Copy the viewmodel, along with all its attachments, to the worldmodel. Super convenient!
SWEP.MirrorWorldModel = true -- Use this to set the mirrored viewmodel to a different model, without any floating speedloaders or cartridges you may have. Needs MirrorVMWM


SWEP.MuzzleEffect = "muzzleflash_smg"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellScale = 1.5
SWEP.ShellMaterial = nil
SWEP.MuzzleFlashColor = Color(255, 150, 0)
SWEP.GMMuzzleEffect = false


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


SWEP.IronSightStruct = {
    Pos = Vector(-4.176, 4, 1.5),
    Ang = Angle(0.368, -0.197, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = false
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "smg"
SWEP.HoldtypeSights = "smg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0,0,0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-1, -2, -1)
SWEP.CrouchAng = Angle(0, 0, -15)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.CustomizePos = Vector(8, 0, 1)
SWEP.CustomizeAng = Angle(5, 30, 30)

SWEP.BarrelLength = 24

SWEP.AttachmentElements = {
}

SWEP.ExtraSightDist = 10

SWEP.Attachments = {

}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle01",
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
        Source = {"fire01","fire02","fire03","fire04"},
		ShellEjectAt = 0,
		
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		Mult = 0.8,
    },
}

sound.Add({
	name = "Weapon_SMG2.Fire",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = SNDLVL_GUNFIRE,
	pitch = {140, 150},
	sound = {
		"weapon/hmg/hmg_fire_player_01.wav",
		"weapon/hmg/hmg_fire_player_02.wav",
		"weapon/hmg/hmg_fire_player_03.wav",
		"weapon/hmg/hmg_fire_player_04.wav",
		"weapon/hmg/hmg_fire_player_05.wav",
		"weapon/hmg/hmg_fire_player_06.wav",
	}
})

sound.Add({
	name = "Weapon_SMG2.NPC",
	channel = CHAN_STATIC,
	volume = 0.1,
	level = 140,
	pitch = {110, 120},
	sound = {
		")weapon/hmg/hmg_fire_player_01.wav",
		")weapon/hmg/hmg_fire_player_02.wav",
		")weapon/hmg/hmg_fire_player_03.wav",
		")weapon/hmg/hmg_fire_player_04.wav",
		")weapon/hmg/hmg_fire_player_05.wav",
		")weapon/hmg/hmg_fire_player_06.wav",
	}
})

sound.Add({
	name = "Weapon_SMG2.Bolt_Grab",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 130,
	sound = "weapon/hmg/handling/hmg_bolt_grab_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = "weapon//handling/.wav"
})
sound.Add({
	name = "Weapon_SMG2.Bolt_Pull",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 130,
	sound = "weapon/akm/handling/akm_bolt_pull_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Bolt_Lock",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 130,
	sound = "weapon/hmg/handling/hmg_bolt_lock_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Bolt_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapon/akm/handling/akm_bolt_release_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapon/akm/handling/akm_mag_release_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_Out",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapon/akm/handling/akm_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapon/akm/handling/akm_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_In",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapon/akm/handling/akm_mag_in_01.wav"
})
