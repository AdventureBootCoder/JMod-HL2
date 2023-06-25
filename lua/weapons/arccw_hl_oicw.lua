SWEP.Base = "arccw_base"
SWEP.Spawnable = false
SWEP.Category = "ArcCW - Half-Life" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "OICW"

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/oicw/c_oicw.mdl"
SWEP.WorldModel = "models/weapons/oicw/w_oicw.mdl"
SWEP.ViewModelFOV = 60
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(10, 1, -3),
    ang = Angle(-4, 180, 180)
}

SWEP.DefaultBodygroups = "00000000000"

SWEP.Damage = 12
SWEP.DamageMin = 8

SWEP.BodyDamageMults = {
    [HITGROUP_HEAD] = 1.4,
 }
 
 SWEP.Force = 12
 
SWEP.Range = 100 -- in METRES
SWEP.RangeMin = 60
SWEP.Penetration = 8
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 40
SWEP.ReducedClipSize = 20

SWEP.PhysBulletMuzzleVelocity = 700


SWEP.Recoil = 0.15
SWEP.RecoilSide = 0.1
SWEP.RecoilRise = 0.25
SWEP.MaxRecoilBlowback = -1
SWEP.VisualRecoilMult = 1
SWEP.RecoilPunch = 2
SWEP.RecoilPunchBackMax = 2
SWEP.RecoilPunchBackMaxSights = nil -- may clip with scopes
SWEP.RecoilVMShake = 2 -- random viewmodel offset when shooty

SWEP.Delay = 60 / 650 -- 60 / RPM.
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
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_ar2"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 1 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 300 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 100
SWEP.SightsDispersion = 50

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses
SWEP.MagID = "OICW" -- the magazine pool this gun draws from

SWEP.ShootVol = 80 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "Weapon_OICW.Fire"
SWEP.DistantShootSound = "Weapon_OICW.NPC"

SWEP.MirrorVMWM = false -- Copy the viewmodel, along with all its attachments, to the worldmodel. Super convenient!
SWEP.MirrorWorldModel = true -- Use this to set the mirrored viewmodel to a different model, without any floating speedloaders or cartridges you may have. Needs MirrorVMWM


SWEP.MuzzleEffect = "muzzleflash_smg"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellScale = 1.5
SWEP.ShellMaterial = nil
SWEP.MuzzleFlashColor = Color(200, 255, 0)
SWEP.GMMuzzleEffect = false


SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.9
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.55

SWEP.FreeAimAngle = nil -- defaults to HipDispersion / 80. overwrite here
SWEP.NeverFreeAim = nil
SWEP.AlwaysFreeAim = nil

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerFinalMag = 0 -- the last X bullets in a magazine are all tracers
SWEP.Tracer = "arccw_tracer" -- override tracer (hitscan) effect
SWEP.HullSize = 0 -- HullSize used by FireBullets
SWEP.TracerCol = Color(120, 255, 0)
SWEP.PhysTracerProfile = 2


SWEP.IronSightStruct = {
    Pos = Vector( -2, 2, 3 ),
    Ang = Angle( 2, 0, 0 ),
    Magnification = 2,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = true
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(-1,0,1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-1, -2, -1)
SWEP.CrouchAng = Angle(0, 0, -15)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.NoHideLeftHandInCustomization = true
SWEP.CustomizePos = Vector(18, -15, 2)
SWEP.CustomizeAng = Angle(15, 60, 30)

SWEP.BarrelLength = 24

SWEP.Attachments = {
    {
        PrintName = "Grenade Launcher",
        Slot = {"hl2_oicw_gl"},
        DefaultAttName = "DISABLED",
        Installed = "ubgl_hl2_oicw_gl",
    },
}

SWEP.ExtraSightDist = 10


SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
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
        Source = {"fire1","fire2","fire3","fire4"},
		ShellEjectAt = 0,
    },
    ["enter_inspect"] = {
        Source = {"fidget","fidget2"},
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    },
    ["gl_fire"] = {
        Source = "altfire",
        TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
        TPAnimStartTime = 0,
    },
    ["enter_ubgl"] = {
        Source = "lowtoidle",
		Mult = 0.5,
		RestoreAmmo = -1,
        SoundTable = {
            {s = "weapons/arccw/ubgl_select.wav",  t = 0, c = ci},
        },
    },
    ["exit_ubgl"] = {
        Source = "lowtoidle",
		Mult = 0.5,
        SoundTable = {
            {s = "weapons/arccw/ubgl_exit.wav",  t = 0, c = ci},
        },
    },
}

sound.Add({
	name = "Weapon_OICW.Fire",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = 80,
	pitch = {97, 103},
	sound = {
		"weapon/oicw/oicw_fire_player_01.wav",
		"weapon/oicw/oicw_fire_player_02.wav",
		"weapon/oicw/oicw_fire_player_03.wav",
		"weapon/oicw/oicw_fire_player_04.wav",
		"weapon/oicw/oicw_fire_player_05.wav",
		"weapon/oicw/oicw_fire_player_06.wav",
		"weapon/oicw/oicw_fire_player_07.wav",
		"weapon/oicw/oicw_fire_player_08.wav",
		"weapon/oicw/oicw_fire_player_09.wav",
		"weapon/oicw/oicw_fire_player_10.wav",
		"weapon/oicw/oicw_fire_player_11.wav",
		"weapon/oicw/oicw_fire_player_12.wav"
	}
})
sound.Add({
	name = "Weapon_OICW.Fire_Alt",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = 80,
	pitch = {97, 103},
	sound = {
		"weapon/oicw/oicw_20mm_fire1.wav",
		"weapon/oicw/oicw_20mm_fire2.wav",
		"weapon/oicw/oicw_20mm_fire3.wav"
	}
})

sound.Add({
	name = "Weapon_OICW.NPC",
	channel = CHAN_STATIC,
	volume = 0.2,
	level = 140,
	pitch = {60, 70},
	sound = {
		")weapon/oicw/oicw_fire_player_01.wav",
		")weapon/oicw/oicw_fire_player_02.wav",
		")weapon/oicw/oicw_fire_player_03.wav",
		")weapon/oicw/oicw_fire_player_04.wav",
		")weapon/oicw/oicw_fire_player_05.wav",
		")weapon/oicw/oicw_fire_player_06.wav",
		")weapon/oicw/oicw_fire_player_07.wav",
		")weapon/oicw/oicw_fire_player_08.wav",
		")weapon/oicw/oicw_fire_player_09.wav",
		")weapon/oicw/oicw_fire_player_10.wav",
		")weapon/oicw/oicw_fire_player_11.wav",
		")weapon/oicw/oicw_fire_player_12.wav"
	}
})

sound.Add({
	name = "Weapon_OICW.Mag_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_mag_release_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Mag_Out",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Mag_In",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_mag_in_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Mag_Slap",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_mag_slap_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Bolt_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_bolt_release_01.wav"
})
