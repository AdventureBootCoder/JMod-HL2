SWEP.Base = "wep_jack_gmod_gunbase"
SWEP.Spawnable = true
SWEP.Category = "JMod: Half-Life - ArcCW" -- edit this if you like
SWEP.AdminOnly = false
SWEP.PrintName = "RPG"
SWEP.Slot = 4

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/aboot/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
SWEP.ViewModelFOV = 60
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(16, 2, -3),
    ang = Angle(-15, 180, 180)
}
SWEP.DefaultBodygroups = "00000000000"
---
SWEP.CustomToggleCustomizeHUD = false
---
--SWEP.Damage = 150
--SWEP.DamageType = DMG_BLAST
JMod.ApplyAmmoSpecs(SWEP, "Mini Rocket")
SWEP.ManualAction = false
SWEP.AutoReload = false
SWEP.ShootEntity = "ent_aboot_gmod_ezhl2rocket"
SWEP.ShootEntityAngle = Angle(0, -90, 0)
SWEP.ShootEntityOffset = Vector(10, 0, -4)
SWEP.ShootEntityAngleCorrection = Angle(0, -90, 0)
SWEP.MuzzleVelocity = 1200 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 1 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 1
SWEP.ReducedClipSize = 1


SWEP.Recoil = 1
SWEP.RecoilSide = 0
SWEP.RecoilRise = 0.5
SWEP.MaxRecoilBlowback = -1
SWEP.VisualRecoilMult = 5
SWEP.RecoilPunch = 3
SWEP.RecoilPunchBackMax = 2
SWEP.RecoilPunchBackMaxSights = nil -- may clip with scopes
SWEP.RecoilVMShake = 5 -- random viewmodel offset when shooty

SWEP.Delay = 60 / 100 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_rpg"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 0 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 100 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 100
SWEP.SightsDispersion = 0
SWEP.JumpDispersion = 1000 -- dispersion penalty when in the air

SWEP.Primary.Ammo = "RPG_Round" -- what ammo type the gun uses
SWEP.MagID = "rpg" -- the magazine pool this gun draws from

SWEP.ShootVol = 90 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "TFA_MMOD.RPG.1"
SWEP.DistantShootSound = "TFA_MMOD.RPG.NPC"

SWEP.MuzzleEffect = "muzzleflash_minimi"

SWEP.MirrorVMWM = false -- Copy the viewmodel, along with all its attachments, to the worldmodel. Super convenient!
SWEP.MirrorWorldModel = true -- Use this to set the mirrored viewmodel to a different model, without any floating speedloaders or cartridges you may have. Needs MirrorVMWM

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.7
SWEP.SightedSpeedMult = 0.6
SWEP.SightTime = 0.44

SWEP.Force = 40

SWEP.IronSightStruct = {
    Pos = Vector(-3.19, -2, 1.2),
    Ang = Angle(0.1, 0, 0),
    Magnification = 1.2,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = true
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "rpg"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG

SWEP.ActivePos = Vector(0,0,0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-4, -2, -1)
SWEP.CrouchAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.NoHideLeftHandInCustomization = true
SWEP.CustomizePos = Vector(17, -12, 1)
SWEP.CustomizeAng = Angle(10, 50, 30)

SWEP.SprintPos = Vector( -0.0637, 0, 0.1897 )
SWEP.SprintAng = Angle( -20, 9.5787, -10.7118 )

SWEP.BarrelLength = 24

SWEP.AttachmentElements = {
}

SWEP.ExtraSightDist = 10

SWEP.Attachments = {
	{
		PrintName = "Guidence System",
		DefaultAttName = "None",
		Slot = "missile_guidence", -- what kind of attachments can fit here, can be string or table
		Bone = "rpg_base", -- relevant bone any attachments will be mostly referring to
		Offset = {
			vpos = Vector(0, 0, 0), -- offset that the attachment will be relative to the bone
			vang = Angle(0, 0, 0),
			wpos = Vector(0, 0, 0),
			wang = Angle(0, 0, 0)
		}
	}
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle1",
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
        Source = {"fire"},
		
    },
    ["enter_inspect"] = {
        Source = {"fidget1","fidget2"},
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    },
}

sound.Add({
	name = 			"TFA_MMOD.RPG.1",
	channel = 		CHAN_WEAPON,
	level = SNDLVL_GUNFIRE,
	volume = 		1.0,
	pitch = {95, 110},
	sound = 			{"weapons/tfa_mmod/rpg/rocketfire1.wav"}
})

sound.Add({
	name = 			"TFA_MMOD.RPG.NPC",
	channel = 		CHAN_ITEM,
	level = 140,
	volume = 		0.3,
	pitch = {70, 80},
	sound = 			{"weapons/tfa_mmod/rpg/rocketfire1.wav"}
})

sound.Add({
	name = 			"TFA_MMOD.RPG.Draw",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/rpg/rpg_deploy.wav"
})

sound.Add({
	name = 			"TFA_MMOD.RPG.Loop",
	channel = 		CHAN_ITEM,
	level = 		100,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/rpg/rocket1.wav"
})

sound.Add({
	name = 			"TFA_MMOD.RPG.Button",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/rpg/rpg_button.wav"
})

sound.Add({
	name = 			"TFA_MMOD.RPG.Pet1",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/rpg/rpg_pet1.wav"
})

sound.Add({
	name = 			"TFA_MMOD.RPG.Pet2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/rpg/rpg_pet2.wav"
})

sound.Add({
	name = 			"TFA_MMOD.RPG.Insert",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/rpg/rpg_reload1.wav"
})

sound.Add({
	name = 			"TFA_MMOD.RPG.Inspect",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tfa_mmod/rpg/rpg_fidget.wav"
})
