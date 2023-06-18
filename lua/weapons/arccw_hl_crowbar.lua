SWEP.Base = "arccw_base_melee"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Half-Life" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Crowbar"

SWEP.Slot = 1

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/crowbar/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/crowbar/w_crowbar.mdl"
SWEP.ViewModelFOV = 60
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(4, 2, -4),
    ang = Angle(-90, 182, 0)
}

SWEP.MeleeDamage = 15
SWEP.MeleeDamageBackstab = nil -- If not exists, use multiplier on standard damage
SWEP.MeleeRange = 32
SWEP.MeleeDamageType = DMG_CLUB
SWEP.MeleeTime = 0.4
SWEP.MeleeGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MeleeAttackTime = 0.1

SWEP.Melee2 = false
SWEP.Melee2Damage = 25
SWEP.Melee2DamageBackstab = nil -- If not exists, use multiplier on standard damage
SWEP.Melee2Range = 16
SWEP.Melee2Time = 0.5
SWEP.Melee2Gesture = nil
SWEP.Melee2AttackTime = 0.2

SWEP.Lunge = false

SWEP.Backstab = false
SWEP.BackstabMultiplier = 2

SWEP.DefaultBodygroups = "00000000000"

SWEP.CanBash = true
SWEP.PrimaryBash = true -- primary attack triggers melee attack

SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "MELEE"
    },
}

SWEP.AccuracyMOA = 1 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 150 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 100
SWEP.SightsDispersion = 0

SWEP.NotForNPCs = true

SWEP.MirrorVMWM = false -- Copy the viewmodel, along with all its attachments, to the worldmodel. Super convenient!
SWEP.MirrorWorldModel = true -- Use this to set the mirrored viewmodel to a different model, without any floating speedloaders or cartridges you may have. Needs MirrorVMWM

SWEP.Force = 40

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "melee"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER

SWEP.ActivePos = Vector(0,0,0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-1, -2, -1)
SWEP.CrouchAng = Angle(0, 0, -15)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.NoHideLeftHandInCustomization = true
SWEP.CustomizePos = Vector(17, -12, 1)
SWEP.CustomizeAng = Angle(10, 50, 30)

SWEP.SprintPos = Vector( -0.0637, 0, 0.1897 )
SWEP.SprintAng = Angle( -11.0898, 9.5787, -10.7118 )

SWEP.BarrelLength = 0

SWEP.AttachmentElements = {
}

SWEP.ExtraSightDist = 10

SWEP.Attachments = {

}

SWEP.MeleeSwingSound = "Weapon_HEV.Crowbar_Swing"
SWEP.MeleeMissSound = "Weapon_Crowbar.Melee_Miss2"
SWEP.MeleeHitSound = "Weapon_Crowbar.Melee_Hit2"
SWEP.MeleeHitNPCSound = "Weapon_Crowbar.Melee_Hit2"

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
    ["bash"] = {
        Source = {"misscenter1","misscenter2"},
		
    },
}

sound.Add({
	name = "Weapon_Crowbar.Melee_Miss2",
	channel = CHAN_WEAPON,
	level = 79,
	volume = 0.6,
	pitch = {97, 103},
	sound = {
		"weapon/crowbar/crowbar_swing1.wav",
		"weapon/crowbar/crowbar_swing2.wav",
		"weapon/crowbar/crowbar_swing3.wav"
	}
})
sound.Add({
	name = "Weapon_Crowbar.Melee_Hit2",
	channel = CHAN_STATIC,
	level = 60,
	volume = 0.75,
	pitch = {97, 103},
	sound = {
		")weapon/crowbar/crowbar_hit_world01.wav",
		")weapon/crowbar/crowbar_hit_world02.wav",
		")weapon/crowbar/crowbar_hit_world03.wav",
		")weapon/crowbar/crowbar_hit_world04.wav",
		")weapon/crowbar/crowbar_hit_world05.wav",
		")weapon/crowbar/crowbar_hit_world06.wav"
	}
})

sound.Add({
	name = "Weapon_HEV.Crowbar_Draw",
	channel = CHAN_STATIC,
	level = 60,
	volume = 0.75,
	sound = {
		"fx/hev_suit/hev_draw_crowbar_01.wav",
		"fx/hev_suit/hev_draw_crowbar_02.wav",
		"fx/hev_suit/hev_draw_crowbar_03.wav"
	}
})
sound.Add({
	name = "Weapon_HEV.Crowbar_Swing",
	channel = CHAN_WEAPON,
	level = 79,
	volume = 0.6,
	pitch = {97, 103},
	sound = {
		"fx/hev_suit/hev_swing_crowbar_01.wav",
		"fx/hev_suit/hev_swing_crowbar_02.wav",
		"fx/hev_suit/hev_swing_crowbar_03.wav",
		"fx/hev_suit/hev_swing_crowbar_04.wav",
		"fx/hev_suit/hev_swing_crowbar_05.wav",
		"fx/hev_suit/hev_swing_crowbar_06.wav"
	}
})
