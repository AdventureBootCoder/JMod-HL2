SWEP.Base = "wep_jack_gmod_gunbase"
SWEP.Spawnable = false
SWEP.Category = "JMod: Half-Life - ArcCW"
SWEP.AdminOnly = false
SWEP.PrintName = "9mm Pistol"
SWEP.Slot = 1

SWEP.ViewModel = "models/weapons/aboot/c_iiopnpistol.mdl"
SWEP.WorldModel = "models/weapons/aboot/w_iiopnpistol.mdl"
SWEP.ViewModelFOV = 60
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(5, 2, -3.5),
    ang = Angle(-10, 90, 180)
}

SWEP.DefaultBodygroups = "00000000000"


JMod.ApplyAmmoSpecs(SWEP, "Pistol Round", 1)
SWEP.CustomToggleCustomizeHUD = false
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 15 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 20
SWEP.ReducedClipSize = 12

SWEP.PhysBulletMuzzleVelocity = 700
SWEP.CanFireUnderwater = true


SWEP.Recoil = 0.1
SWEP.RecoilSide = 0.1
SWEP.RecoilRise = 0.2
SWEP.MaxRecoilBlowback = -1
SWEP.VisualRecoilMult = 1.0
SWEP.RecoilPunch = 2
SWEP.RecoilPunchBackMax = 2
SWEP.RecoilPunchBackMaxSights = nil -- may clip with scopes
SWEP.RecoilVMShake = 1 -- random viewmodel offset when shooty

SWEP.Delay = 60 / 550 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.Force = 8

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 300 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 100
SWEP.SightsDispersion = 0

SWEP.MagID = "pistol" -- the magazine pool this gun draws from

SWEP.ShootVol = 80 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "Project_MMOD_USP.Fire"
SWEP.DistantShootSound = "Project_MMOD_USP.NPC"

SWEP.MirrorVMWM = false -- Copy the viewmodel, along with all its attachments, to the worldmodel. Super convenient!
SWEP.MirrorWorldModel = true -- Use this to set the mirrored viewmodel to a different model, without any floating speedloaders or cartridges you may have. Needs MirrorVMWM


SWEP.MuzzleEffect = "muzzleflash_pistol"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellScale = 1.5
SWEP.ShellMaterial = nil
SWEP.MuzzleFlashColor = Color(255, 150, 0)
SWEP.GMMuzzleEffect = false


SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.9
SWEP.SightTime = 0.11

SWEP.FreeAimAngle = nil -- defaults to HipDispersion / 80. overwrite here
SWEP.NeverFreeAim = nil
SWEP.AlwaysFreeAim = nil

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerFinalMag = 0 -- the last X bullets in a magazine are all tracers
SWEP.Tracer = "arccw_tracer" -- override tracer (hitscan) effect
SWEP.HullSize = 0 -- HullSize used by FireBullets


SWEP.IronSightStruct = {
    Pos = Vector(-4.3, -2, 1.6),
    Ang = Angle(0, 0.0875, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = false
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

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

SWEP.SprintPos = Vector(0.039, -18.122, -11.672)
SWEP.SprintAng = Angle(70, 0.721, -2.056)

SWEP.BarrelLength = 10

SWEP.AttachmentElements = {
}

SWEP.ExtraSightDist = 10

SWEP.Attachments = {
	{
		PrintName = "Perk",
		Slot = "perk"
	}
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    ["enter_sight"] = {
        Source = "idle_is",
    },
    ["idle_sights"] = {
        Source = "idle_is",
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
        Source = {"shoot1","shoot2","shoot3","shoot4"},
		ShellEjectAt = 0,
		
    },
    ["fire_sights"] = {
        Source = {"shoot1_is","shoot2_is","shoot3_is"},
		ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        SoundTable = {
            {s = "Project_MMOD_USP.ClipOut", t = 0.3, v = 65},
            {s = "Project_MMOD_USP.Clipin", t = 1.1, v = 65},
            {s = "Project_MMOD_USP.SlideBack", t = 1.6, v = 60},
            {s = "Project_MMOD_USP.SlideForward", t = 1.8, v = 60},
        }
    },
}

sound.Add( {
    name = "Project_MMOD_USP.Fire",
    channel = CHAN_WEAPON,
    volume = 1,
    level = SNDLVL_GUNFIRE,
    pitch = { 90, 120 },
    sound =  { "weapons/projectmmod_pistol/pistolfire.wav",
			   "weapons/projectmmod_pistol/pistolfire2.wav",
			   "weapons/projectmmod_pistol/pistolfire3.wav"}
} )

sound.Add( {
    name = "Project_MMOD_USP.NPC",
    channel = CHAN_STATIC,
    volume = 0.1,
    level = 140,
    pitch = { 60, 80 },
    sound =  { "weapons/projectmmod_pistol/pistolfire.wav",
			   "weapons/projectmmod_pistol/pistolfire2.wav",
			   "weapons/projectmmod_pistol/pistolfire3.wav"}
} )

sound.Add( {
    name = "Project_MMOD_USP.Deploy",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/projectmmod_pistol/pistoldeploy.wav"
} )

sound.Add( {
    name = "Project_MMOD_USP.ClipOut",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/projectmmod_pistol/pistolclipout.wav"
} )

sound.Add( {
    name = "Project_MMOD_USP.Clipin",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/projectmmod_pistol/pistolclipin.wav"
} )

sound.Add( {
    name = "Project_MMOD_USP.SlideBack",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/projectmmod_pistol/pistolslideback.wav"
} )

sound.Add( {
    name = "Project_MMOD_USP.SlideForward",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/projectmmod_pistol/pistolslideforward.wav"
} )