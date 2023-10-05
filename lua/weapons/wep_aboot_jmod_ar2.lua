SWEP.Base = "wep_jack_gmod_gunbase"
SWEP.Spawnable = false
SWEP.Category = "JMod: Half-Life - ArcCW"
SWEP.AdminOnly = false
SWEP.PrintName = "Pulse Rifle"
SWEP.Slot = 2

SWEP.ViewModel = "models/weapons/aboot/ar2/c_iiopnirifle.mdl"
SWEP.WorldModel = "models/weapons/aboot/ar2/w_iiopnirifle.mdl"
SWEP.ViewModelFOV = 70
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(16, 1, -2),
    ang = Angle(-4, 180, 180)
}
SWEP.DefaultBodygroups = "00000000000"

SWEP.BodyHolsterSlot = "back"
SWEP.BodyHolsterAng = Angle(10, 10, 0)
SWEP.BodyHolsterAngL = Angle(-10, 10, 180)
SWEP.BodyHolsterPos = Vector(5, -10, -4)
SWEP.BodyHolsterPosL = Vector(5, -10, 4)

SWEP.CustomToggleCustomizeHUD = false

JModHL2.ApplyAmmoSpecs(SWEP, "Light Pulse Ammo", 1)
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 60
SWEP.ReducedClipSize = 20

SWEP.PhysBulletMuzzleVelocity = 700

SWEP.Recoil = 0.2
SWEP.RecoilSide = 0.4
SWEP.RecoilRise = 0.2
SWEP.MaxRecoilBlowback = -1
SWEP.VisualRecoilMult = 6
SWEP.RecoilPunch = 3
SWEP.RecoilPunchBackMax = 4
SWEP.RecoilPunchBackMaxSights = nil -- may clip with scopes
SWEP.RecoilVMShake = 1.5 -- random viewmodel offset when shooty

SWEP.Delay = 60 / 600 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 0
    }
}

SWEP.Force = 15
SWEP.NPCWeaponType = "weapon_ar2"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 1 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 300 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 50
SWEP.SightsDispersion = 100

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses
SWEP.Secondary.Ammo			= "AR2AltFire"
SWEP.Secondary.Sound		= Sound( "Project_MMOD_AR2.SecondaryFire" )
SWEP.MagID = "ar2" -- the magazine pool this gun draws from
SWEP.Secondary.DefaultClip = 1

SWEP.ShootVol = 80 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "Project_MMOD_AR2.Fire"
SWEP.DistantShootSound = "Project_MMOD_AR2.NPC"

SWEP.MuzzleEffect = "muzzleflash_4"--"muzzleflash_minimi"
SWEP.ShellModel = nil--"models/weapons/shells/projectmmodirifleshell.mdl"
SWEP.ShellScale = 1
SWEP.MuzzleFlashColor = Color(70, 255, 200)
SWEP.GMMuzzleEffect = false
SWEP.ShellPitch = 60

SWEP.ImpactEffect = "AR2Impact"
SWEP.ImpactDecal = nil

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.9
SWEP.SightedSpeedMult = 0.7
SWEP.SightTime = 0.33

SWEP.FreeAimAngle = nil -- defaults to HipDispersion / 80. overwrite here
SWEP.NeverFreeAim = nil
SWEP.AlwaysFreeAim = nil

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerFinalMag = 0 -- the last X bullets in a magazine are all tracers
SWEP.Tracer = "tfa_mmod_tracer_ar2" -- override tracer (hitscan) effect
SWEP.TracerCol = Color(0, 0, 255)
SWEP.HullSize = 0 -- HullSize used by FireBullets



SWEP.IronSightStruct = {
    Pos = Vector(-2, -1, 0.3),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = true
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
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

SWEP.NoHideLeftHandInCustomization = true
SWEP.CustomizePos = Vector(12, -4, -2)
SWEP.CustomizeAng = Angle(15, 40, 3)

SWEP.BarrelLength = 24

SWEP.AttachmentElements = {
}

SWEP.ExtraSightDist = 10

SWEP.Attachments = {
	{
		PrintName = "CB Launcher",
		Slot = {"hl2_cbl"},
		DefaultAttName = "DISABLED",
		Installed = "ubgl_hl2_ar2cbl",
	},
	{
		PrintName = "Perk",
		Slot = "perk"
	}
}

SWEP.SelectUBGLSound =  "weapons/arccw/ubgl_select.wav"
SWEP.ExitUBGLSound = "weapons/arccw/ubgl_exit.wav"
SWEP.MirrorVMWM = false -- Copy the viewmodel, along with all its attachments, to the worldmodel. Super convenient!
SWEP.MirrorWorldModel = true -- Use this to set the mirrored viewmodel to a different model, without any floating speedloaders or cartridges you may have. Needs MirrorVMWM


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
        Source = {"fire1","fire2","fire3"},
		ShellEjectAt = 0,
    },
	["charge"] = {
        Source = {"shake"},
    },
	["fire_alt"] = {
        Source = {"fire_alt"},
    },
	["enter_ubgl"] = {
		Source = "lowtoidle",
		Mult = 0.5,
		RestoreAmmo = -1,
		SoundTable = {
			{s = "weapons/arccw/ubgl_select.wav",  t = 0, c = ci}
		},
	},
	["exit_ubgl"] = {
		Source = "lowtoidle",
		Mult = 0.5,
		SoundTable = {
			{s = "weapons/arccw/ubgl_exit.wav",  t = 0, c = ci}
		},
	},
	["reload_ubgl"] = {
        Source = {"lowtoidle"}
    },
    ["enter_inspect"] = {
        Source = {"fidget","fidget2"}
    },
    ["reload"] = {
        Source = "reload",
		
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    },
}

sound.Add( {
    name = "Project_MMOD_AR2.Fire",
    channel = CHAN_WEAPON,
    volume = 0.8,
    level = SNDLVL_GUNFIRE,
    pitch = { 85, 95 },
    sound =  { "weapons/projectmmod_ar2/fire1.wav", "weapons/projectmmod_ar2/fire2.wav", "weapons/projectmmod_ar2/fire3.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.NPC",
    channel = CHAN_STATIC,
    volume = 0.2,
    level = 140,
    pitch = { 70, 80 },
    sound =  { "weapons/projectmmod_ar2/fire1.wav", "weapons/projectmmod_ar2/fire2.wav", "weapons/projectmmod_ar2/fire3.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.MagOut",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_ar2/ar2_magout.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.MagIn",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_ar2/ar2_magin.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.Reload_Push",
    channel = CHAN_ITEM,
    volume = 0.9,
    level = 100,
    pitch = { 90, 110 },
    sound =  { "weapons/ar2/ar2_reload_push.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.Reload_Rotate",
    channel = CHAN_ITEM,
    volume = 0.9,
    level = 100,
    pitch = { 90, 110 },
    sound =  { "weapons/ar2/ar2_reload_rotate.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.Draw",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_ar2/ar2_deploy.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.FidgetPush",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 100, 100 },
    sound =  { "weapons/projectmmod_ar2/ar2_push.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.BoltPull",
    channel = CHAN_AUTO,
    volume = 0.9,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_ar2/ar2_boltpull.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.Charge",
    channel = CHAN_WEAPON,
    volume = 0.7,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_ar2/ar2_charge.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.SecondaryFire",
    channel = CHAN_WEAPON,
    volume = 0.7,
    level = SNDLVL_GUNFIRE,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_ar2/ar2_secondary_fire.wav" }
} )