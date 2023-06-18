SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Half-Life" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "BFSR"

SWEP.Slot = 3

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/sniper/c_sniper.mdl"
SWEP.WorldModel = "models/weapons/sniper/w_sniper.mdl"
SWEP.ViewModelFOV = 70
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(-2, 0, 1),
    ang = Angle(0, 184, 180)
}

SWEP.DefaultBodygroups = "00000000000"

SWEP.Damage = 100
SWEP.DamageMin = 80

SWEP.Range = 150 -- in METRES
SWEP.RangeMin = 50
SWEP.Penetration = 24
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 1 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 1
SWEP.ReducedClipSize = 1

SWEP.PhysBulletMuzzleVelocity = 700


SWEP.Recoil = 1.5
SWEP.RecoilSide = 0.3
SWEP.RecoilRise = 0.6
SWEP.MaxRecoilBlowback = -1
SWEP.VisualRecoilMult = 3
SWEP.RecoilPunch = 4
SWEP.RecoilPunchBackMax = 3
SWEP.RecoilPunchBackMaxSights = nil -- may clip with scopes
SWEP.RecoilVMShake = 8 -- random viewmodel offset when shooty

SWEP.Delay = 60 / 90 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_ar2"
SWEP.NPCWeight = 100
SWEP.Force = 45

SWEP.Primary.DefaultClip = -1

SWEP.AccuracyMOA = 0 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 800 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 50
SWEP.SightsDispersion = 0
SWEP.JumpDispersion = 500

SWEP.Primary.Ammo = "SniperPenetratedRound" -- what ammo type the gun uses
SWEP.MagID = "Sniper" -- the magazine pool this gun draws from

SWEP.ShootVol = 90 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "Weapon_SniperRifle.Fire"
SWEP.DistantShootSound = "Weapon_SniperRifle.NPC"

SWEP.MirrorVMWM = false -- Copy the viewmodel, along with all its attachments, to the worldmodel. Super convenient!
SWEP.MirrorWorldModel = true -- Use this to set the mirrored viewmodel to a different model, without any floating speedloaders or cartridges you may have. Needs MirrorVMWM


SWEP.MuzzleEffect = ""
SWEP.ShellModel = "models/shells/shell_338mag.mdl"
SWEP.ShellScale = 3
SWEP.ShellMaterial = nil
SWEP.MuzzleFlashColor = Color(255, 150, 0)
SWEP.GMMuzzleEffect = true
SWEP.ShellRotate = 80
SWEP.ShellPhysScale = 1
SWEP.ShellPitch = 60
SWEP.NoFlash = true


SWEP.MuzzleEffectAttachment = 0 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 1 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.8
SWEP.SightedSpeedMult = 0.3
SWEP.SightTime = 0.66

SWEP.FreeAimAngle = nil -- defaults to HipDispersion / 80. overwrite here
SWEP.NeverFreeAim = nil
SWEP.AlwaysFreeAim = nil

SWEP.TracerNum = 0 -- tracer every X
SWEP.TracerFinalMag = 0 -- the last X bullets in a magazine are all tracers
SWEP.Tracer = "arccw_tracer" -- override tracer (hitscan) effect
SWEP.HullSize = 1 -- HullSize used by FireBullets


SWEP.IronSightStruct = {
    Pos = Vector( -2, 0, 2 ),
    Ang = Angle( 2, 0, 0 ),
    Magnification = 3,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = true
}

SWEP.BodyDamageMults = {
    [HITGROUP_HEAD] = 2,
 }

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "crossbow"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW

SWEP.ActivePos = Vector(-1,2,0)
SWEP.ActiveAng = Angle(2, 0, 0)

SWEP.CrouchPos = Vector(-1,-4,1)
SWEP.CrouchAng = Angle(2, 0, 0)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.CustomizePos = Vector(8, 0, 1)
SWEP.CustomizeAng = Angle(5, 30, 30)

SWEP.SprintPos = Vector(6, 0, 2.25)
SWEP.SprintAng = Angle(-12, 45, -10)

SWEP.BarrelLength = 24

SWEP.AttachmentElements = {
}

SWEP.ExtraSightDist = 10

SWEP.Attachments = {

}

SWEP.Animations = {
    ["idle"] = {
        Source = "sniper_idle01",
    },
    ["draw"] = {
        Source = "sniper_draw",
		Mult = 1.1,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.5,
    },
    ["fire"] = {
        Source = {"sniper_fire"},
		
		
    },
    ["reload"] = {
        Source = "sniper_reload",
		Mult = 0.8,
		ShellEjectAt = 0.12,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
    },
}

sound.Add({
	name = "Weapon_SniperRifle.Fire",
	channel = CHAN_WEAPON,
	volume = 1,
	level = SNDLVL_GUNFIRE,
	pitch = {90, 105},
	sound = {
		"weapon/sniperrifle/sniperrifle_fire_player_01.wav",
		"weapon/sniperrifle/sniperrifle_fire_player_02.wav",
		"weapon/sniperrifle/sniperrifle_fire_player_03.wav"
	}
})

sound.Add({
	name = "Weapon_SniperRifle.NPC",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 140,
	pitch = {60, 70},
	sound = {
		")weapon/sniperrifle/sniperrifle_fire_player_01.wav",
		")weapon/sniperrifle/sniperrifle_fire_player_02.wav",
		")weapon/sniperrifle/sniperrifle_fire_player_03.wav"
	}
})

sound.Add({
	name = "Weapon_SniperRifle.Zoom_In",
	channel = CHAN_AUTO,
	level = SNDLVL_NORM,
	sound = "weapon/sniperrifle/handling/sniperrifle_zoom_in_01.wav"
})
sound.Add({
	name = "Weapon_SniperRifle.Zoom_Out",
	channel = CHAN_AUTO,
	level = SNDLVL_NORM,
	sound = "weapon/sniperrifle/handling/sniperrifle_zoom_out_01.wav"
})

sound.Add({
	name = "Weapon_SniperRifle.Bolt_Up",
	channel = CHAN_AUTO,
	volume = 0.5,
	level = SNDLVL_NORM,
	sound = {
		"weapon/sniperrifle/handling/sniperrifle_bolt_up_01.wav",
		"weapon/sniperrifle/handling/sniperrifle_bolt_up_02.wav",
		"weapon/sniperrifle/handling/sniperrifle_bolt_up_03.wav"
	}
})
sound.Add({
	name = "Weapon_SniperRifle.Bolt_Back",
	channel = CHAN_AUTO,
	volume = 0.75,
	level = SNDLVL_NORM,
	sound = {
		"weapon/sniperrifle/handling/sniperrifle_bolt_back_01.wav",
		"weapon/sniperrifle/handling/sniperrifle_bolt_back_02.wav",
		"weapon/sniperrifle/handling/sniperrifle_bolt_back_03.wav"
	}
})
sound.Add({
	name = "Weapon_SniperRifle.Bolt_Forward",
	channel = CHAN_AUTO,
	volume = 0.5,
	level = SNDLVL_NORM,
	sound = {
		"weapon/sniperrifle/handling/sniperrifle_bolt_forward_01.wav",
		"weapon/sniperrifle/handling/sniperrifle_bolt_forward_02.wav",
		"weapon/sniperrifle/handling/sniperrifle_bolt_forward_03.wav"
	}
})
sound.Add({
	name = "Weapon_SniperRifle.Bolt_Down",
	channel = CHAN_AUTO,
	volume = 0.5,
	level = SNDLVL_NORM,
	sound = {
		"weapon/sniperrifle/handling/sniperrifle_bolt_down_01.wav",
		"weapon/sniperrifle/handling/sniperrifle_bolt_down_02.wav",
		"weapon/sniperrifle/handling/sniperrifle_bolt_down_03.wav"
	}
})
sound.Add({
	name = "Weapon_SniperRifle.Bullet_Futz",
	channel = CHAN_AUTO,
	volume = 0.25,
	level = SNDLVL_NORM,
	sound = {
		"weapon/sniperrifle/handling/sniperrifle_bullet_futz_01.wav",
		"weapon/sniperrifle/handling/sniperrifle_bullet_futz_02.wav",
		"weapon/sniperrifle/handling/sniperrifle_bullet_futz_03.wav"
	}
})
sound.Add({
	name = "Weapon_SniperRifle.Bullet_Load",
	channel = CHAN_AUTO,
	volume = 0.5,
	level = SNDLVL_NORM,
	sound = {
		"weapon/sniperrifle/handling/sniperrifle_bullet_load_01.wav",
		"weapon/sniperrifle/handling/sniperrifle_bullet_load_02.wav",
		"weapon/sniperrifle/handling/sniperrifle_bullet_load_03.wav"
	}
})
