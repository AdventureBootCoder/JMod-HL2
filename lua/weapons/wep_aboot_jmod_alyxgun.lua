SWEP.Base = "wep_jack_gmod_gunbase"
SWEP.Spawnable = false
SWEP.Category = "ArcCW - Half-Life" -- edit this if you like
SWEP.AdminOnly = false
SWEP.PrintName = "Alyx Gun"
SWEP.Slot = 1
SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/alyxgun/c_alyx_gun.mdl"
SWEP.WorldModel = "models/weapons/alyxgun/alyxgun.mdl"
SWEP.ViewModelFOV = 70
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(5, 1, -2.25),
    ang = Angle(0, -5, 180)
}
SWEP.DefaultBodygroups = "00000000000"

JModHL2.ApplyAmmoSpecs(SWEP, "Pistol Round", 1)

SWEP.Range = 50 -- in METRES
SWEP.RangeMin = 20
SWEP.MuzzleVelocity = 700 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 21 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 36
SWEP.ReducedClipSize = 15

SWEP.PhysBulletMuzzleVelocity = 700

SWEP.Recoil = 0.2
SWEP.RecoilSide = 0.3
SWEP.RecoilRise = 0.2
SWEP.MaxRecoilBlowback = -1
SWEP.VisualRecoilMult = 1.0
SWEP.RecoilPunch = 1.5
SWEP.RecoilPunchBackMax = 1.5
SWEP.RecoilPunchBackMaxSights = nil -- may clip with scopes
SWEP.RecoilVMShake = 1.0 -- random viewmodel offset when shooty

SWEP.Delay = 60 / 1000 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = -3,
		RunawayBurst = true,
		AutoBurst = true,
		PostBurstDelay = 0.2,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 400 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 200
SWEP.SightsDispersion = 50

SWEP.MagID = "alyxgun" -- the magazine pool this gun draws from

SWEP.ShootVol = 80 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootSound = "Weapon_Alyxgun.Fire"
SWEP.DistantShootSound = "Weapon_Alyxgun.NPC_Fire"

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
SWEP.SightTime = 0.11

SWEP.FreeAimAngle = nil -- defaults to HipDispersion / 80. overwrite here
SWEP.NeverFreeAim = nil
SWEP.AlwaysFreeAim = nil

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerFinalMag = 0 -- the last X bullets in a magazine are all tracers
SWEP.Tracer = "arccw_tracer" -- override tracer (hitscan) effect
SWEP.HullSize = 0 -- HullSize used by FireBullets


SWEP.IronSightStruct = {
    Pos = Vector(-3.775, 4, 2.115),
    Ang = Angle(0.165, 0.02, 0),
    Magnification = 1.2,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = false
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "Revolver"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.ActivePos = Vector(0,0,0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-1, -2, -1)
SWEP.CrouchAng = Angle(0, 0, -15)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.CustomizePos = Vector(12, -8, 4)
SWEP.CustomizeAng = Angle(5, 50, 30)

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
        Source = {"fire1","fire2","fire3"},
		ShellEjectAt = 0,
		
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
    },
}

sound.Add({
	name = "Weapon_Alyxgun.Fire",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = SNDLVL_GUNFIRE,
	pitch = {90, 110},
	sound = {
		"weapon/alyxgun/alyxgun_fire_player_01.wav",
		"weapon/alyxgun/alyxgun_fire_player_02.wav",
		"weapon/alyxgun/alyxgun_fire_player_03.wav",
		"weapon/alyxgun/alyxgun_fire_player_04.wav",
		"weapon/alyxgun/alyxgun_fire_player_05.wav",
		"weapon/alyxgun/alyxgun_fire_player_06.wav"
	}
})

sound.Add({
	name = "Weapon_Alyxgun.NPC_Fire",
	channel = CHAN_STATIC,
	volume = 0.1,
	level = 140,
	pitch = {50, 60},
	sound = {
		")weapon/alyxgun/alyxgun_fire_player_01.wav",
		")weapon/alyxgun/alyxgun_fire_player_02.wav",
		")weapon/alyxgun/alyxgun_fire_player_03.wav",
		")weapon/alyxgun/alyxgun_fire_player_04.wav",
		")weapon/alyxgun/alyxgun_fire_player_05.wav",
		")weapon/alyxgun/alyxgun_fire_player_06.wav"
	}
})

sound.Add({
	name = "Weapon_Alyxgun.Mag_Out",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	sound = "snds_jack_gmod/ez_weapons/pistol/out.wav"--"weapon/pistol/handling/pistol_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_Alyxgun.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	sound = "snds_jack_gmod/ez_weapons/pistol/tap.wav"--"weapon/pistol/handling/pistol_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_Alyxgun.Mag_In",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	sound = "snds_jack_gmod/ez_weapons/pistol/in.wav"--"weapon/pistol/handling/pistol_mag_in_01.wav"
})
sound.Add({
	name = "Weapon_Alyxgun.Slide_Release",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	sound = "snds_jack_gmod/ez_weapons/pistol/release.wav"--"weapon/pistol/handling/pistol_slide_release_01.wav"
})
