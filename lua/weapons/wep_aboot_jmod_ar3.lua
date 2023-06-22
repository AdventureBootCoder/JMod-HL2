SWEP.Base = "wep_jack_gmod_gunbase"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "JMod: Half-Life - ArcCW" -- edit this if you like
SWEP.AdminOnly = false
SWEP.PrintName = "Pulse LMG"
SWEP.Slot = 4

SWEP.ViewModel = "models/weapons/aboot/c_iiopnar3.mdl"
SWEP.WorldModel = "models/weapons/aboot/tfa_mmod/w_ar3.mdl"
SWEP.ViewModelFOV = 60
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(23, 4, -1),
    ang = Angle(-10, 180, 180)
}

SWEP.MirrorVMWM = false -- Copy the viewmodel, along with all its attachments, to the worldmodel. Super convenient!
SWEP.MirrorWorldModel = true -- Use this to set the mirrored viewmodel to a different model, without any floating speedloaders or cartridges you may have. Needs MirrorVMWM

SWEP.Force = 15
SWEP.DefaultBodygroups = "00000000000"

SWEP.BodyDamageMults = {
    [HITGROUP_HEAD] = 1.1,
 }
 
SWEP.Damage = 13
SWEP.DamageMin = 8

SWEP.Range = 60 -- in METRES
SWEP.RangeMin = 30
SWEP.Penetration = 8
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 100 -- DefaultClip is automatically set.
SWEP.BottomlessClip = true

SWEP.PhysBulletMuzzleVelocity = 700


SWEP.Recoil = 0.3
SWEP.RecoilSide = 0.4
SWEP.RecoilRise = 0.3
SWEP.MaxRecoilBlowback = 3
SWEP.VisualRecoilMult = 1.5
SWEP.RecoilPunch = 2
SWEP.RecoilPunchBackMax = 2
SWEP.RecoilPunchBackMaxSights = nil -- may clip with scopes
SWEP.RecoilVMShake = 3.5 -- random viewmodel offset when shooty

SWEP.Delay = 60 / 900 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_ar2"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 10 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 700 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 100
SWEP.SightsDispersion = 300
SWEP.ShotgunSpreadDispersion = false

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses
SWEP.MagID = "ar2" -- the magazine pool this gun draws from

SWEP.ShootVol = 90 -- volume of shoot sound
SWEP.ShootPitch = 80 -- pitch of shoot sound

SWEP.ShootSound = "TFA_MMOD.AR3.1"
SWEP.DistantShootSound = "TFA_MMOD.AR3.NPC"

SWEP.MuzzleEffect = "muzzleflash_minimi"
SWEP.ShellModel = "models/weapons/shells/projectmmodirifleshell.mdl"
SWEP.ShellScale = 1.5
SWEP.MuzzleFlashColor = Color(100, 100, 255)
SWEP.GMMuzzleEffect = false
SWEP.ShellPitch = 50
SWEP.ShellRotate = 90

SWEP.ImpactEffect = "AR2Impact"
SWEP.ImpactDecal = nil

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 0 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.6
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.66
SWEP.ShootSpeedMult = 0.6

SWEP.FreeAimAngle = nil -- defaults to HipDispersion / 80. overwrite here
SWEP.NeverFreeAim = nil
SWEP.AlwaysFreeAim = nil

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerFinalMag = 0 -- the last X bullets in a magazine are all tracers
SWEP.Tracer = "tfa_mmod_tracer_ar3" -- override tracer (hitscan) effect
SWEP.TracerCol = Color(0, 0, 255)
SWEP.HullSize = 0 -- HullSize used by FireBullets

-- If Jamming is enabled, a heat meter will gradually build up until it reaches HeatCapacity.
-- Once that happens, the gun will overheat, playing an animation. If HeatLockout is true, it cannot be fired until heat is 0 again.
SWEP.Jamming = true
SWEP.HeatGain = 3 -- heat gained per shot
SWEP.HeatCapacity = 200 -- rounds that can be fired non-stop before the gun jams, playing the "fix" animation
SWEP.HeatDissipation = 30 -- rounds' worth of heat lost per second
SWEP.HeatLockout = false -- overheating means you cannot fire until heat has been fully depleted
SWEP.HeatDelayTime = 0.2
SWEP.HeatFix = true -- when the "fix" animation is played, all heat is restored.
SWEP.HeatOverflow = nil -- if true, heat is allowed to exceed capacity (this only applies when the default overheat handling is overridden)



SWEP.IronSightStruct = {
    Pos = Vector(2, -8, 5),
    Ang = Angle(0, 0, 0),
    Magnification = 1.3,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = true
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "physgun"
SWEP.HoldtypeSights = "crossbow"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW

SWEP.ActivePos = Vector(0,0,0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-1, -2, -1)
SWEP.CrouchAng = Angle(0, 0, -15)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.NoHideLeftHandInCustomization = true
SWEP.CustomizePos = Vector(12, -8, 1)
SWEP.CustomizeAng = Angle(15, 30, 10)

SWEP.BarrelLength = 24

SWEP.AttachmentElements = {
}

SWEP.ExtraSightDist = 10

SWEP.Attachments = {

}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    ["draw"] = {
        Source = "IR_draw",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.5,
    },
    ["holster"] = {
        Source = "IR_holster",
    },
    ["fix"] = {
        Source = "overheat",
		ShellEjectAt = 0,
		TPAnim = ACT_HL2MP_GESTURE_RELOAD_DUEL,
    },
    ["fire"] = {
        Source = {"fire1","fire2","fire3","fire4"},
		ShellEjectAt = 0,
    },
    ["enter_inspect"] = {
        Source = {"inspect1","inspect2"},
    },
    ["reload"] = {
        Source = "reload",
		TPAnim = ACT_HL2MP_GESTURE_RELOAD_DUEL,
        
    },
}

sound.Add( {
    name = "TFA_MMOD.AR3.1",
    channel = CHAN_WEAPON,
    volume = 0.8,
    level = SNDLVL_GUNFIRE,
    pitch = { 90, 110 },
    sound =  { "weapons/tfa_mmod/ar3/ar3_fire1.wav", "weapons/tfa_mmod/ar3/ar3_fire2.wav", "weapons/tfa_mmod/ar3/ar3_fire3.wav" }
} )

sound.Add( {
    name = "TFA_MMOD.AR3.NPC",
    channel = CHAN_ITEM,
    volume = 0.3,
    level = 140,
    pitch = { 60, 70 },
    sound =  { "weapons/tfa_mmod/ar3/ar3_fire1.wav", "weapons/tfa_mmod/ar3/ar3_fire2.wav", "weapons/tfa_mmod/ar3/ar3_fire3.wav" }
} )

sound.Add( {
    name = "TFA_MMOD.AR3.Draw",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/tfa_mmod/ar3/ar3_deploy.wav"
} )

sound.Add( {
    name = "TFA_MMOD.AR3.Pump",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/tfa_mmod/ar3/ar3_pump.wav"
} )

sound.Add( {
    name = "TFA_MMOD.AR3.Fidget",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/tfa_mmod/ar3/ar3_fidget.wav"
} )

sound.Add( {
    name = "TFA_MMOD.AR3.Barrel_Open",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/tfa_mmod/ar3/ar3_barrel_open.wav"
} )

sound.Add( {
    name = "TFA_MMOD.AR3.Barrel_Close",
    channel = CHAN_AUTO,
    volume = 1,
    level = SNDLVL_NORM,
    pitch = { 95, 105 },
    sound =  "weapons/tfa_mmod/ar3/ar3_barrel_close.wav"
} )