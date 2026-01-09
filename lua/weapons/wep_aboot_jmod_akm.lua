SWEP.Base = "wep_jack_gmod_gunbase"
SWEP.Spawnable = false
SWEP.Category = "ArcCW - Half-Life" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "AR1"

SWEP.Slot = 2

SWEP.UseHands = true
SWEP.NoHideLeftHandInCustomization = true

SWEP.ViewModel = "models/weapons/aboot/akm/c_akm.mdl"
SWEP.WorldModel = "models/weapons/aboot/akm/w_akm.mdl"
SWEP.ViewModelFOV = 60
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(17, 1, -2.5),
    ang = Angle(-6, 180, 180)
}

SWEP.DefaultBodygroups = "00000000000"
JMod.ApplyAmmoSpecs(SWEP, "Light Rifle Round", 1)
SWEP.CustomToggleCustomizeHUD = false

--[[SWEP.Damage = 15
SWEP.DamageMin = 9

SWEP.Force = 15

SWEP.Range = 100 -- in METRES
SWEP.RangeMin = 60
SWEP.Penetration = 12
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity--]]
-- IN M/S
SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 40
SWEP.ReducedClipSize = 20
 
SWEP.PhysBulletMuzzleVelocity = 700

SWEP.Recoil = 0.25
SWEP.RecoilSide = 0.25
SWEP.RecoilRise = 0.35
SWEP.MaxRecoilBlowback = -1
SWEP.VisualRecoilMult = 3
SWEP.RecoilPunch = 3
SWEP.RecoilPunchBackMax = 5
SWEP.RecoilPunchBackMaxSights = nil -- may clip with scopes
SWEP.RecoilVMShake = 4 -- random viewmodel offset when shooty

SWEP.Delay = 60 / 600 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
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

SWEP.NPCWeaponType = "weapon_ar2"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 10 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 300 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 100
SWEP.SightsDispersion = 10

SWEP.MagID = "akm" -- the magazine pool this gun draws from

SWEP.ShootVol = 80 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "Weapon_AKM.Fire"
SWEP.DistantShootSound = "Weapon_AKM.NPC_Fire"

SWEP.MirrorVMWM = false -- Copy the viewmodel, along with all its attachments, to the worldmodel. Super convenient!
SWEP.MirrorWorldModel = true -- Use this to set the mirrored viewmodel to a different model, without any floating speedloaders or cartridges you may have. Needs MirrorVMWM


SWEP.MuzzleEffect = "muzzleflash_smg"
SWEP.ShellModel = "models/shells/shell_762nato.mdl"
SWEP.ShellScale = 1.5
SWEP.ShellMaterial = nil
SWEP.MuzzleFlashColor = Color(255, 150, 0)
SWEP.GMMuzzleEffect = false


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
SWEP.Tracer = "arccw_tracer" -- override tracer (hitscan) effect
SWEP.HullSize = 0 -- HullSize used by FireBullets


SWEP.IronSightStruct = {
    Pos = Vector(-3.4, -8, 1.455),
    Ang = Angle(0.707, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = false
}
SWEP.ProceduralIronFire = true

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

SWEP.CustomizePos = Vector(8, -3, 2)
SWEP.CustomizeAng = Angle(5, 40, 30)

SWEP.BarrelLength = 24

SWEP.AttachmentElements = {
}

SWEP.ExtraSightDist = 10

SWEP.Attachments = {
	{
		PrintName = "Optic",
		DefaultAttName = "No Scope",
		Slot = {"ez_optic", "optic"},
		Bone = "weapon",
		Offset = {
			vang = Angle(0, 180, 90),
			vpos = Vector(-5, -5, 0),
			wpos = Vector(10, 1.1, -6.5),
			wang = Angle(-5, 0.3, 180)
		},
		CorrectiveAng = Angle(0, 0, 0),
		CorrectivePos = Vector(0, 0, 0.03)
	},
	{
		PrintName = "Tactical",
		DefaultAttName = "No Attachment",
		Slot = {"tac", "ez_tac", "flashlight", "light"},
		Bone = "weapon",
		Offset = {
			vpos = Vector(-18, -3.5, 0.5), -- offset that the attachment will be relative to the bone
			vang = Angle(180, 0, 0),
			wpos = Vector(22, 1.5, -6),
			wang = Angle(-5, 0, -92)
		},
		--Hidden = true, -- attachment cannot be seen in customize menu
	},
	{
		PrintName = "Perk",
		Slot = "perk"
	},
	{
		PrintName = "Charm",
		Slot = "charm",
		FreeSlot = true,
		Bone = "weapon",
		Offset = {
			vpos = Vector(-4.4, -3, 0.5), -- offset that the attachment will be relative to the bone
			vang = Angle(0, 180, 90),
			wpos = Vector(8.5, 1.8, -4),
			wang = Angle(0, -5, 180)
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
    ["enter_inspect"] = {
        Source = {"fidget","fidget2"},
    },
    ["fire"] = {
        Source = {"fire1","fire2","fire3"},
		ShellEjectAt = 0,
		
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    },
}

sound.Add({
	name = "Weapon_AKM.Fire",
	channel = CHAN_WEAPON,
	volume = 0.85,
	level = 60,
	pitch = {97, 103},
	sound = {
		"weapon/akm/akm_fire_player_01.wav",
		"weapon/akm/akm_fire_player_02.wav",
		"weapon/akm/akm_fire_player_03.wav",
		"weapon/akm/akm_fire_player_04.wav",
		"weapon/akm/akm_fire_player_05.wav"
	}
})

sound.Add({
	name = "Weapon_AKM.NPC_Fire",
	channel = CHAN_STATIC,
	volume = 0.2,
	level = 140,
	pitch = {65, 80},
	sound = {
		")weapon/akm/akm_fire_player_01.wav",
		")weapon/akm/akm_fire_player_02.wav",
		")weapon/akm/akm_fire_player_03.wav",
		")weapon/akm/akm_fire_player_04.wav",
		")weapon/akm/akm_fire_player_05.wav"
	}
})

sound.Add({
	name = "Weapon_AKM.Mag_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/akm/handling/akm_mag_release_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Mag_Out",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/akm/handling/akm_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/akm/handling/akm_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Mag_In",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/akm/handling/akm_mag_in_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Bolt_Pull",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/akm/handling/akm_bolt_pull_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Bolt_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/akm/handling/akm_bolt_release_01.wav"
})