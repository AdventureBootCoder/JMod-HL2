SWEP.Base = "wep_jack_gmod_gunbase"
SWEP.Spawnable = false
SWEP.Category = "JMod: Half-Life - ArcCW" -- edit this if you like
SWEP.AdminOnly = false
SWEP.PrintName = "Annabelle"
SWEP.Slot = 3

SWEP.ViewModel = "models/weapons/annabelle/c_annabelle.mdl"
SWEP.WorldModel = "models/weapons/annabelle/w_annabelle.mdl"
SWEP.ViewModelFOV = 70
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(16, 0, -3.5),
    ang = Angle(-10, 180, 180)
}
SWEP.BodyHolsterSlot = "back"
SWEP.BodyHolsterAng = Angle(10, 10, 0)
SWEP.BodyHolsterAngL = Angle(-10, 10, 180)
SWEP.BodyHolsterPos = Vector(5, -10, -4)
SWEP.BodyHolsterPosL = Vector(5, -10, 4)

SWEP.DefaultBodygroups = "00000000000"

JMod.ApplyAmmoSpecs(SWEP, "Magnum Pistol Round", 1.5)
SWEP.Force = 25
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 8 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 10
SWEP.ReducedClipSize = 6

SWEP.PhysBulletMuzzleVelocity = 700

SWEP.Recoil = 0.8
SWEP.RecoilSide = 0.2
SWEP.RecoilRise = 0.5
SWEP.MaxRecoilBlowback = -1
SWEP.VisualRecoilMult = 2
SWEP.RecoilPunch = 2
SWEP.RecoilPunchBackMax = 2
SWEP.RecoilPunchBackMaxSights = nil -- may clip with scopes
SWEP.RecoilVMShake = 2.5 -- random viewmodel offset when shooty

SWEP.Delay = 60 / 80 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
		PrintName = "LEVER",
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_ar2"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 150 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 100
SWEP.SightsDispersion = 0

SWEP.ShootVol = 90 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "Weapon_Annabelle.Fire"
SWEP.DistantShootSound = "Weapon_Annabelle.NPC_Fire"

SWEP.MirrorVMWM = false -- Copy the viewmodel, along with all its attachments, to the worldmodel. Super convenient!
SWEP.MirrorWorldModel = true -- Use this to set the mirrored viewmodel to a different model, without any floating speedloaders or cartridges you may have. Needs MirrorVMWM

SWEP.MuzzleEffect = "muzzleflash_minimi"
SWEP.ShellModel = "models/shells/shell_338mag.mdl"
SWEP.ShellScale = 1.5
SWEP.ShellMaterial = nil
SWEP.MuzzleFlashColor = Color(255, 150, 0)
SWEP.GMMuzzleEffect = false
SWEP.ShellTime = 0.5


SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.9
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.33

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerFinalMag = 0 -- the last X bullets in a magazine are all tracers
SWEP.Tracer = "arccw_tracer" -- override tracer (hitscan) effect
SWEP.HullSize = 1 -- HullSize used by FireBullets
SWEP.ManualAction = true
SWEP.ShotgunReload = true
SWEP.NoLastCycle = false

SWEP.IronSightStruct = {
    Pos = Vector(-2.73, -9, 2.2),
    Ang = Angle(0, -0.95, 0),
    Magnification = 1.4,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = false
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "shotgun"
SWEP.HoldtypeSights = "ar2"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN

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
        Source = "fire",
		MinProgress = 0.4,
		
    },
    ["cycle"] = {
        Source = {"lever"},
		ShellEjectAt = 0.1,
		
    },
    ["sgreload_start"] = {
        Source = "reload1",
    },
    ["sgreload_insert"] = {
        Source = "reload2",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
    },
    ["sgreload_finish"] = {
        Source = "reload3",
    },
}

sound.Add({
	name = "Weapon_Annabelle.Fire",
	channel = CHAN_WEAPON,
	volume = 1,
	level = SNDLVL_GUNFIRE,
	pitch = {97, 103},
	sound = {
		"weapon/annabelle/annabelle_fire_player_01.wav",
		"weapon/annabelle/annabelle_fire_player_02.wav",
		"weapon/annabelle/annabelle_fire_player_03.wav"
	}
})

sound.Add({
	name = "Weapon_Annabelle.NPC_Fire",
	channel = CHAN_STATIC,
	volume = 0.3,
	level = 140,
	pitch = {80, 90},
	sound = {
		")weapon/annabelle/annabelle_fire_player_01.wav",
		")weapon/annabelle/annabelle_fire_player_02.wav",
		")weapon/annabelle/annabelle_fire_player_03.wav"
	}
})

sound.Add({
	name = "Weapon_Annabelle.Lever_Down",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = {
		"weapon/annabelle/handling/annabelle_lever_down_01.wav",
		"weapon/annabelle/handling/annabelle_lever_down_02.wav",
		"weapon/annabelle/handling/annabelle_lever_down_03.wav"
	}
})
sound.Add({
	name = "Weapon_Annabelle.Lever_Up",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = {
		"weapon/annabelle/handling/annabelle_lever_up_01.wav",
		"weapon/annabelle/handling/annabelle_lever_up_02.wav",
		"weapon/annabelle/handling/annabelle_lever_up_03.wav"
	}
})
sound.Add({
	name = "Weapon_Annabelle.Bullet_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = {
		"weapon/annabelle/handling/annabelle_bullet_futz_01.wav",
		"weapon/annabelle/handling/annabelle_bullet_futz_02.wav",
		"weapon/annabelle/handling/annabelle_bullet_futz_03.wav"
	}
})
sound.Add({
	name = "Weapon_Annabelle.Bullet_Load",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = {
		"weapon/annabelle/handling/annabelle_bullet_load_01.wav",
		"weapon/annabelle/handling/annabelle_bullet_load_02.wav",
		"weapon/annabelle/handling/annabelle_bullet_load_03.wav"
	}
})