SWEP.Base = "wep_jack_gmod_gunbase"
SWEP.Spawnable = false
SWEP.Category = "JMod: Half-Life - ArcCW" -- edit this if you like
SWEP.AdminOnly = false
SWEP.PrintName = "SPAS-13"
SWEP.Slot = 3

SWEP.ViewModel = "models/weapons/aboot/c_customspas12.mdl"
SWEP.WorldModel = "models/weapons/aboot/w_IIopnshotgun.mdl"
SWEP.ViewModelFOV = 60
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
	pos = Vector(16, 0, -3.5),
	ang = Angle(-10, 180, 180)
}
SWEP.BodyHolsterSlot = "back"
SWEP.BodyHolsterAng = Angle(0, -10, 10)
SWEP.BodyHolsterAngL = Angle(-10, -10, -100)
SWEP.BodyHolsterPos = Vector(3, -10, -5)
SWEP.BodyHolsterPosL = Vector(5, -2, 5)

SWEP.CustomToggleCustomizeHUD = false
 
SWEP.ShotgunSpreadDispersion = true
SWEP.NoRandSpread = false
SWEP.DoorBreachPower = 1.5

SWEP.DefaultBodygroups = "00000000000"

JModHL2.ApplyAmmoSpecs(SWEP, "Shotgun Round", 1.2)
SWEP.Force = 12
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 6 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 8
SWEP.ReducedClipSize = 4

SWEP.PhysBulletMuzzleVelocity = 700

SWEP.Recoil = 1.4
SWEP.RecoilSide = 0.4
SWEP.RecoilRise = 0.8
SWEP.MaxRecoilBlowback = -1
SWEP.VisualRecoilMult = 5
SWEP.RecoilPunch = 3
SWEP.RecoilPunchBackMax = 4
SWEP.RecoilPunchBackMaxSights = nil -- may clip with scopes
SWEP.RecoilVMShake = 5 -- random viewmodel offset when shooty

SWEP.Delay = 60 / 80 -- 60 / RPM.
SWEP.Num = 8 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
		PrintName = "PUMP",
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_shotgun"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 80 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 300 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 100
SWEP.SightsDispersion = 100

SWEP.ShootVol = 90 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "Project_MMOD_Shotgun.Fire"
SWEP.DistantShootSound = "Project_MMOD_Shotgun.NPC"

SWEP.MirrorVMWM = false -- Copy the viewmodel, along with all its attachments, to the worldmodel. Super convenient!
SWEP.MirrorWorldModel = true -- Use this to set the mirrored viewmodel to a different model, without any floating speedloaders or cartridges you may have. Needs MirrorVMWM


SWEP.MuzzleEffect = "muzzleflash_shotgun"
SWEP.ShellModel = "models/shells/shell_12gauge.mdl"
SWEP.ShellScale = 1.5
SWEP.ShellMaterial = nil
SWEP.MuzzleFlashColor = Color(255, 150, 0)
SWEP.GMMuzzleEffect = false

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.9
SWEP.SightedSpeedMult = 0.7
SWEP.SightTime = 0.33

SWEP.TracerNum = 2 -- tracer every X
SWEP.TracerFinalMag = 0 -- the last X bullets in a magazine are all tracers
SWEP.Tracer = "arccw_tracer" -- override tracer (hitscan) effect
SWEP.HullSize = 1 -- HullSize used by FireBullets
SWEP.ManualAction = true
SWEP.ShotgunReload = true


SWEP.IronSightStruct = {
    Pos = Vector(-4.332, -5.348, 1.85),
    Ang = Angle(0, 0, 0.688),
    Magnification = 1.1,
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
	{
		PrintName = "Tactical", -- print name
		DefaultAttName = "No Attachment",
		Slot = {"tac"},
		Bone = "Base",
		Offset = {
			vpos = Vector(0, 0, 0), -- offset that the attachment will be relative to the bone
			vang = Angle(0, 0, 0),
			wpos = Vector(0, 0, 0),
			wang = Angle(0, 0, 0)
		},
		--[[SlideAmount={ -- how far this attachment can slide in both directions.
			-- overrides Offset.
			vmin=Vector(0.8, -5.715, -4),
			vmax=Vector(0.8, -5.715, -0.5),
			wmin=Vector(5.36, 0.739, -5.401),
			wmax=Vector(5.36, 0.739, -5.401),
		}]]--
	}
}

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
        Source = "fire1",
		MinProgress = 0.3,
		
    },
    ["fire_iron"] = {
        Source = "fire_ironsights",
		MinProgress = 0.3,
		
    },
    ["cycle"] = {
        Source = {"pump"},
		ShellEjectAt = 0.2,
		MinProgress = 0.4,
		
    },
    ["cycle_iron"] = {
        Source = {"pump2_sighted"},
		ShellEjectAt = 0.2,
		MinProgress = 0.4,
		
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

sound.Add( {
    name = "Project_MMOD_Shotgun.Fire1",
    channel = CHAN_WEAPON,
    volume = 1,
    level = SNDLVL_GUNFIRE,
    pitch = { 85, 115 },
    sound =  { "weapons/projectmmod_shotgun/shotgun_dbl_fire1.wav",
			   "weapons/projectmmod_shotgun/shotgun_dbl_fire2.wav",
			   "weapons/projectmmod_shotgun/shotgun_dbl_fire3.wav"}
} )

sound.Add( {
    name = "Project_MMOD_Shotgun.Fire",
    channel = CHAN_WEAPON,
    volume = 1,
    level = SNDLVL_GUNFIRE,
    pitch = { 85, 110 },
    sound =  { "weapons/projectmmod_shotgun/shotgun_fire1.wav",
			   "weapons/projectmmod_shotgun/shotgun_fire2.wav",
			   "weapons/projectmmod_shotgun/shotgun_fire3.wav"}
} )

sound.Add( {
    name = "Project_MMOD_Shotgun.NPC",
    channel = CHAN_STATIC,
    volume = 0.2,
    level = 140,
    pitch = { 65, 75 },
    sound =  { "weapons/projectmmod_shotgun/shotgun_fire1.wav",
			   "weapons/projectmmod_shotgun/shotgun_fire2.wav",
			   "weapons/projectmmod_shotgun/shotgun_fire3.wav"}
} )

sound.Add( {
    name = "Project_MMOD_Shotgun.Draw",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/projectmmod_shotgun/shotgun_deploy.wav"
} )

sound.Add( {
    name = "Project_MMOD_Shotgun.Sling1",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 90, 120 },
    sound =  {"weapons/projectmmod_shotgun/shotgun_reload1.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload2.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload3.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload4.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload5.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload6.wav"}
} )

sound.Add( {
    name = "Project_MMOD_Shotgun.Sling2",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 90, 120 },
    sound =  {"weapons/projectmmod_shotgun/shotgun_reload1.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload2.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload3.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload4.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload5.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload6.wav"}
} )

sound.Add( {
    name = "Project_MMOD_Shotgun.Sling3",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 90, 120 },
    sound =  {"weapons/projectmmod_shotgun/shotgun_reload1.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload2.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload3.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload4.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload5.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload6.wav"}
} )

sound.Add( {
    name = "Project_MMOD_Shotgun.Sling4",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 90, 120 },
    sound =  {"weapons/projectmmod_shotgun/shotgun_reload1.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload2.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload3.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload4.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload5.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload6.wav"}
} )

sound.Add( {
    name = "Project_MMOD_Shotgun.Sling5",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 90, 120 },
    sound =  {"weapons/projectmmod_shotgun/shotgun_reload1.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload2.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload3.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload4.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload5.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload6.wav"}
} )

sound.Add( {
    name = "Project_MMOD_Shotgun.Sling6",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 90, 120 },
    sound =  {"weapons/projectmmod_shotgun/shotgun_reload1.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload2.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload3.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload4.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload5.wav",
			  "weapons/projectmmod_shotgun/shotgun_reload6.wav"}
} )



sound.Add( {
    name = "Project_MMOD_Shotgun.Cock_Back",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 80, 105 },
    sound =  "weapons/projectmmod_shotgun/shotgun_cock_back.wav"
} )

sound.Add( {
    name = "Project_MMOD_Shotgun.Cock_Forward",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 80, 105 },
    sound =  "weapons/projectmmod_shotgun/shotgun_cock_forward.wav"
} )

