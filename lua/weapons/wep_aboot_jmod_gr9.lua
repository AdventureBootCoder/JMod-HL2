SWEP.Base = "wep_jack_gmod_gunbase"
SWEP.Spawnable = false
SWEP.Category = "JMod: Half-Life - ArcCW" -- edit this if you like
SWEP.AdminOnly = false
SWEP.PrintName = "GR9-LMG"
SWEP.Slot = 4

SWEP.ViewModel = "models/weapons/aboot/hmg/c_gr9.mdl"
SWEP.WorldModel = "models/weapons/aboot/hmg/w_gr9.mdl"
SWEP.ViewModelFOV = 65
SWEP.DefaultBodygroups = "00000200000"
SWEP.DefaultWMBodygroups = "01000000"
SWEP.MirrorVMWM = false -- Copy the viewmodel, along with all its attachments, to the worldmodel. Super convenient!
SWEP.MirrorWorldModel = true -- Use this to set the mirrored viewmodel to a different model, without any floating speedloaders or cartridges you may have. Needs MirrorVMWM
SWEP.WorldModelOffset = {
    pos = Vector(9, .8, -3.5),
    ang = Angle(-10, 180, 180),
	scale = 0.9
}
---

SWEP.BodyHolsterSlot = "back"
SWEP.BodyHolsterAng = Angle(10, 10, 0)
SWEP.BodyHolsterAngL = Angle(-10, 10, 180)
SWEP.BodyHolsterPos = Vector(5, -10, -4)
SWEP.BodyHolsterPosL = Vector(5, -10, 4)

JModHL2.ApplyAmmoSpecs(SWEP, "Light Rifle Round", 1)
SWEP.CustomToggleCustomizeHUD = false

--[[
SWEP.Damage = 15
SWEP.DamageMin = 10

SWEP.Range = 80 -- in METRES
SWEP.RangeMin = 50
SWEP.Penetration = 16
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
--]]
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 72 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 100
SWEP.ReducedClipSize = 52

SWEP.PhysBulletMuzzleVelocity = 700

SWEP.Recoil = 0.3
SWEP.RecoilSide = 0.2
SWEP.RecoilRise = 0.2
SWEP.MaxRecoilBlowback = -1
SWEP.VisualRecoilMult = 3
SWEP.RecoilPunch = 1
SWEP.RecoilPunchBackMax = 3
SWEP.RecoilPunchBackMaxSights = nil -- may clip with scopes
SWEP.RecoilVMShake = 2 -- random viewmodel offset when shooty

SWEP.Delay = 60 / 850 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
	{
		Mode = 2
	},
    {
        Mode = -4,
		RunawayBurst = true,
		AutoBurst = true,
		PostBurstDelay = 0.01,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_ar2"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 500 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 180
SWEP.SightsDispersion = 150

SWEP.MagID = "GR9" -- the magazine pool this gun draws from

SWEP.ShootVol = 90 -- volume of shoot sound
SWEP.ShootPitch = 80 -- pitch of shoot sound

SWEP.ShootSound = "Weapon_HMG.Fire"
SWEP.DistantShootSound = "Weapon_HMG.NPC"

SWEP.MuzzleEffect = "muzzleflash_minimi"
SWEP.ShellModel = "models/shells/shell_762nato.mdl"
SWEP.ShellScale = 2
SWEP.ShellMaterial = nil
SWEP.MuzzleFlashColor = Color(255, 150, 0)
SWEP.GMMuzzleEffect = false
SWEP.ShellPitch = 80
SWEP.ShellPhysScale = 1
SWEP.ShellRotate = 240
SWEP.ShellTime = 30

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.9
SWEP.SightedSpeedMult = 0.6
SWEP.ShootSpeedMult = 0.8
SWEP.SightTime = 0.44

SWEP.FreeAimAngle = nil -- defaults to HipDispersion / 80. overwrite here
SWEP.NeverFreeAim = nil
SWEP.AlwaysFreeAim = nil

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerFinalMag = 0 -- the last X bullets in a magazine are all tracers
SWEP.Tracer = "arccw_tracer" -- override tracer (hitscan) effect
SWEP.HullSize = 0 -- HullSize used by FireBullets

-- If Jamming is enabled, a heat meter will gradually build up until it reaches HeatCapacity.
-- Once that happens, the gun will overheat, playing an animation. If HeatLockout is true, it cannot be fired until heat is 0 again.
SWEP.Jamming = false
SWEP.HeatGain = 1 -- heat gained per shot
SWEP.HeatCapacity = 100 -- rounds that can be fired non-stop before the gun jams, playing the "fix" animation
SWEP.HeatDissipation = 20 -- rounds' worth of heat lost per second
SWEP.HeatLockout = true -- overheating means you cannot fire until heat has been fully depleted
SWEP.HeatDelayTime = 0.2
SWEP.HeatFix = true -- when the "fix" animation is played, all heat is restored.
SWEP.HeatOverflow = nil -- if true, heat is allowed to exceed capacity (this only applies when the default overheat handling is overridden)

SWEP.IronSightStruct = {
    Pos = Vector( -4.5, -4, 3 ),
    Ang = Angle( 0, 0, 0 ),
    Magnification = 2.0,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = true
}

--[[SWEP.Bipod_Integral = true -- Integral bipod (ie, weapon model has one)
SWEP.BipodDispersion = 0.5 -- Bipod dispersion for Integral bipods
SWEP.BipodRecoil = 0.2 -- Bipod recoil for Integral bipods--]]

SWEP.InBipodPos = Vector(-6, 0, -6)
SWEP.InBipodMult = Vector(2, 1, 1)

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "ar2"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(-2,0,2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-4,0,2)
SWEP.CrouchAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.NoHideLeftHandInCustomization = true
SWEP.CustomizePos = Vector(18, -15, 2)
SWEP.CustomizeAng = Angle(15, 60, 30)

SWEP.BarrelLength = 24

SWEP.AttachmentElements = {
}

SWEP.ExtraSightDist = 10

SWEP.Attachments = {
	{
		PrintName = "Forward Grip",
		DefaultAttName = "No Attachment",
		Slot = {"gr9_bipod", "ez_bipod"},
		Bone = "base",
		Offset = {
			vpos = Vector(-32.15, -1.2, 0),
			vang = Angle(0, 180, 90),
			wpos = Vector(31.5, 0.6, -9.6),
			wang = Angle(-15, 0, 180)
		},
		Installed = "underbarrel_aboot_gr9_bipod",
		--Hidden = true, -- attachment cannot be seen in customize menu
		--Integral = true
	},
	{
		PrintName = "Tactical",
		DefaultAttName = "No Attachment",
		Slot = {"tac", "ez_tac", "flashlight", "light"},
		Bone = "Base",
		Offset = {
			vpos = Vector(-30, -2, 1.5), -- offset that the attachment will be relative to the bone
			vang = Angle(180, 0, 180),
			wpos = Vector(28, -1, -10),
			wang = Angle(-5, 0, -92)
		},
		--Hidden = true, -- attachment cannot be seen in customize menu
	},
	{
		PrintName = "Optic",
		DefaultAttName = "No Scope",
		Slot = {"ez_optic", "gr9_optic"},
		Bone = "base",
		Offset = {
			vang = Angle(0, 180, 90),
			vpos = Vector(-5.5, -3.5, 0),
			wpos = Vector(0.7, 0.5, -7),
			wang = Angle(-10, 0.3, 180)
		},
		CorrectiveAng = Angle(0, 0, 0),
		CorrectivePos = Vector(0, 0, 0.03),
		Installed = "optic_aboot_scope_gr9"
	},
	{
		PrintName = "Perk",
		Slot = "perk"
	},
	{
		PrintName = "Charm",
		Slot = "charm",
		FreeSlot = true,
		Bone = "base",
		Offset = {
			vpos = Vector(-8, 0.5, 0.5), -- offset that the attachment will be relative to the bone
			vang = Angle(0, 180, 90),
			wpos = Vector(4, 1.5, -3),
			wang = Angle(0, -4.211, 180)
		},
	},
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
        Source = {"fire","fire2","fire3","fire4"},
		ShellEjectAt = 0,
		
    },
    ["reload"] = {
        Source = "reload",
		Mult = 1.2,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    },
}


sound.Add({
	name = "Weapon_HMG.Fire",
	channel = CHAN_WEAPON,
	volume = 0.85,
    level = SNDLVL_GUNFIRE,
	pitch = {97, 103},
	sound = {
		"weapon/hmg/hmg_fire_player_01.wav",
		"weapon/hmg/hmg_fire_player_02.wav",
		"weapon/hmg/hmg_fire_player_03.wav"
	}
})

sound.Add({
	name = "Weapon_HMG.NPC",
	channel = CHAN_STATIC,
	volume = 0.25,
	level = 140,
	pitch = {60, 70},
	sound = {
		")weapon/hmg/hmg_fire_player_01.wav",
		")weapon/hmg/hmg_fire_player_02.wav",
		")weapon/hmg/hmg_fire_player_03.wav"
	}
})

sound.Add({
	name = "Weapon_HMG.Bolt_Grab",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_bolt_grab_01.wav"
})
sound.Add({
	name = "Weapon_HMG.Bolt_Pull",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_bolt_pull_01.wav"
})
sound.Add({
	name = "Weapon_HMG.Bolt_Lock",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_bolt_lock_01.wav"
})
sound.Add({
	name = "Weapon_HMG.Bolt_Slap",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_bolt_slap_01.wav"
})
sound.Add({
	name = "Weapon_HMG.Mag_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_mag_release_01.wav"
})
sound.Add({
	name = "Weapon_HMG.Mag_Out",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_HMG.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_HMG.Mag_In",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_mag_in_01.wav"
})
