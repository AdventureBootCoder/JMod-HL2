SWEP.Base = "wep_jack_gmod_gunbase"
SWEP.Spawnable = false
SWEP.Category = "JMod: Half-Life - ArcCW" -- edit this if you like
SWEP.AdminOnly = false
SWEP.PrintName = "SMG1"
SWEP.Slot = 2

SWEP.ViewModel = "models/weapons/aboot/tfa_mmod/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/aboot/tfa_mmod/w_smg1.mdl"
SWEP.ViewModelFOV = 60
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(10, 0, -4),
    ang = Angle(-3, 0, 180)
}
SWEP.DefaultBodygroups = "00000000000"

SWEP.CustomToggleCustomizeHUD = false

--SWEP.Damage = 11
--SWEP.DamageMin = 4

SWEP.Range = 45 -- in METRES
SWEP.RangeMin = 25
SWEP.Penetration = 4
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 45 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 65
SWEP.ReducedClipSize = 30

SWEP.PhysBulletMuzzleVelocity = 700


SWEP.Recoil = 0.1
SWEP.RecoilSide = 0.1
SWEP.RecoilRise = 0.2
SWEP.MaxRecoilBlowback = -1
SWEP.VisualRecoilMult = 1.5
SWEP.RecoilPunch = 1
SWEP.RecoilPunchBackMax = 2
SWEP.RecoilPunchBackMaxSights = nil -- may clip with scopes
SWEP.RecoilVMShake = 1.5 -- random viewmodel offset when shooty

SWEP.Delay = 60 / 800 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
		PrintName = "FULL-AUTO"
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_smg1"
SWEP.NPCWeight = 80

SWEP.AccuracyMOA = 6 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 500 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 100
SWEP.SightsDispersion = 100

--SWEP.Primary.Ammo = "smg1" -- what ammo type the gun uses
SWEP.Secondary.Ammo			= "25mm Grenade"
SWEP.Secondary.Sound		= Sound( "Weapon_SMG1.Double" )
SWEP.MagID = "smg1" -- the magazine pool this gun draws from
SWEP.Secondary.DefaultClip = 1

JMod.ApplyAmmoSpecs(SWEP, "Pistol Round", 1.1)

SWEP.ShootVol = 80 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "TFA_MMOD.SMG1.1"
SWEP.DistantShootSound = "TFA_MMOD.SMG1.NPC"

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

SWEP.Force = 5

SWEP.FreeAimAngle = nil -- defaults to HipDispersion / 80. overwrite here
SWEP.NeverFreeAim = nil
SWEP.AlwaysFreeAim = nil

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerFinalMag = 0 -- the last X bullets in a magazine are all tracers
SWEP.Tracer = "arccw_tracer" -- override tracer (hitscan) effect
SWEP.HullSize = 0 -- HullSize used by FireBullets

SWEP.IronSightStruct = {
    Pos = Vector( -4.7, -4, 2 ),
    Ang = Angle( -0.65, 0, 0 ),
    Magnification = 1.2,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = false
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "smg"
SWEP.HoldtypeSights = "rpg"

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

SWEP.SelectUBGLSound =  "weapons/arccw/ubgl_select.wav"
SWEP.ExitUBGLSound = "weapons/arccw/ubgl_exit.wav"
SWEP.AttachmentElements = {
}

SWEP.ExtraSightDist = 10

SWEP.Attachments = {
    {
        PrintName = "Grenade Launcher",
        Slot = {"hl2_gl"},
        DefaultAttName = "DISABLED",
        Installed = "ubgl_hl2_gl",
    },
	{
		PrintName = "Perk",
		Slot = "perk"
	},
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle01",
    },
    ["enter_sight"] = {
        Source = "idle01_is",
    },
    ["idle_sights"] = {
        Source = "idle01_is",
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
    ["fire_sights"] = {
        Source = {"fire1_is","fire2_is","fire3_is","fire4_is"},
		ShellEjectAt = 0,
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
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
            {s = "TFA_MMOD.SMG1.ClipOut", t = 0.3, v = 65},
            {s = "TFA_MMOD.SMG1.ClipHit", t = 1.1, v = 60},
            {s = "TFA_MMOD.SMG1.ClipIn", t = 1.4, v = 65},
        }
    },

}

sound.Add( {
    name = "TFA_MMOD.SMG1.1",
    channel = CHAN_WEAPON,
    volume = 1,
    level = SNDLVL_GUNFIRE,
    pitch = { 90, 110 },
    sound =  { "weapons/tfa_mmod/smg1/smg1_fire1.wav", "weapons/tfa_mmod/smg1/smg1_fire2.wav", "weapons/tfa_mmod/smg1/smg1_fire3.wav" }
} )

sound.Add( {
    name = "TFA_MMOD.SMG1.NPC",
    channel = CHAN_STATIC,
    volume = 0.1,
    level = 140,
    pitch = { 50, 65 },
    sound =  { "weapons/tfa_mmod/smg1/smg1_fire1.wav", "weapons/tfa_mmod/smg1/smg1_fire2.wav", "weapons/tfa_mmod/smg1/smg1_fire3.wav" }
} )

sound.Add( {
    name = "TFA_MMOD.SMG1.2",
    channel = CHAN_weapon,
    volume = 1,
    level = SNDLVL_GUNFIRE,
    pitch = { 80, 110 },
    sound =  "weapons/tfa_mmod/smg1/smg1_glauncher.wav"
} )

sound.Add( {
    name = "TFA_MMOD.SMG1.Draw",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/tfa_mmod/smg1/smg1_deploy.wav"
} )

sound.Add( {
    name = "TFA_MMOD.SMG1.ClipOut",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/tfa_mmod/smg1/smg1_clipout.wav"
} )

sound.Add( {
    name = "TFA_MMOD.SMG1.ClipIn",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/tfa_mmod/smg1/smg1_clipin.wav"
} )

sound.Add( {
    name = "TFA_MMOD.SMG1.ClipHit",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/tfa_mmod/smg1/smg1_cliphit.wav"
} )

sound.Add( {
    name = "TFA_MMOD.SMG1.BoltBack",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/tfa_mmod/smg1/smg1_boltback.wav"
} )

sound.Add( {
    name = "TFA_MMOD.SMG1.BoltForward",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/tfa_mmod/smg1/smg1_boltforward.wav"
} )

sound.Add( {
    name = "TFA_MMOD.SMG1.GripFold",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/tfa_mmod/smg1/smg1_gripfold.wav"
} )

sound.Add( {
    name = "TFA_MMOD.SMG1.GripUnfold",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/tfa_mmod/smg1/smg1_gripunfold.wav"
} )

