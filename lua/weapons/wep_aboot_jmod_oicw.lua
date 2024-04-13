SWEP.Base = "wep_jack_gmod_gunbase"
SWEP.Spawnable = false
SWEP.Category = "ArcCW - Half-Life" -- edit this if you like
SWEP.AdminOnly = false
SWEP.PrintName = "OICW"
SWEP.Slot = 2
SWEP.ViewModel = "models/weapons/aboot/oicw/c_oicw.mdl"
SWEP.WorldModel = "models/weapons/aboot/oicw/w_oicw.mdl"
SWEP.ViewModelFOV = 70
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(10, 1, -3),
    ang = Angle(-4, 180, 180)
}

SWEP.DefaultBodygroups = "00000000000"
JModHL2.ApplyAmmoSpecs(SWEP, "Light Rifle Round", 0.8)
SWEP.CustomToggleCustomizeHUD = false

SWEP.BodyHolsterSlot = "back"
SWEP.BodyHolsterAng = Angle(-10, 0, 0)
SWEP.BodyHolsterAngL = Angle(-10, 10, 180)
SWEP.BodyHolsterPos = Vector(4, -10, -6)
SWEP.BodyHolsterPosL = Vector(4, -10, 4)

SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 40
SWEP.ReducedClipSize = 20

SWEP.PhysBulletMuzzleVelocity = 700

SWEP.Recoil = 0.15
SWEP.RecoilSide = 0.1
SWEP.RecoilRise = 0.25
SWEP.MaxRecoilBlowback = -1
SWEP.VisualRecoilMult = 1
SWEP.RecoilPunch = 2
SWEP.RecoilPunchBackMax = 0
SWEP.RecoilPunchBackMaxSights = 0 -- may clip with scopes
SWEP.RecoilVMShake = 0 -- random viewmodel offset when shooty

SWEP.Delay = 60 / 650 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = -3,
		RunawayBurst = true,
		AutoBurst = true,
		PostBurstDelay = 0.2,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_ar2"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 1 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 800 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 100
SWEP.SightsDispersion = 50

SWEP.MagID = "OICW" -- the magazine pool this gun draws from

SWEP.ShootVol = 80 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "Weapon_OICW.Fire"
SWEP.DistantShootSound = "Weapon_OICW.NPC"

SWEP.MirrorVMWM = false -- Copy the viewmodel, along with all its attachments, to the worldmodel. Super convenient!
SWEP.MirrorWorldModel = true -- Use this to set the mirrored viewmodel to a different model, without any floating speedloaders or cartridges you may have. Needs MirrorVMWM


SWEP.MuzzleEffect = "muzzleflash_smg"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellScale = 1.5
SWEP.ShellMaterial = nil
SWEP.MuzzleFlashColor = Color(200, 255, 0)
SWEP.GMMuzzleEffect = false


SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.8
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.55

SWEP.FreeAimAngle = nil -- defaults to HipDispersion / 80. overwrite here
SWEP.NeverFreeAim = nil
SWEP.AlwaysFreeAim = nil

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerFinalMag = 0 -- the last X bullets in a magazine are all tracers
SWEP.Tracer = "arccw_tracer" -- override tracer (hitscan) effect
SWEP.HullSize = 0 -- HullSize used by FireBullets
SWEP.TracerCol = Color(21, 248, 40)
SWEP.PhysTracerProfile = 2


SWEP.IronSightStruct = {
    Pos = Vector( -5.5, 0, 3 ),
    Ang = Angle( 2, 0, 0 ),
    Magnification = 2,
    SwitchToSound = JMod.GunHandlingSounds.aim.inn,
	SwitchFromSound = JMod.GunHandlingSounds.aim.out,
    CrosshairInSights = true
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "shotgun"
SWEP.HoldtypeSights = "ar2"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(-1,0,1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-1, -2, -1)
SWEP.CrouchAng = Angle(0, 0, -15)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.NoHideLeftHandInCustomization = true
SWEP.CustomizePos = Vector(18, -15, 2)
SWEP.CustomizeAng = Angle(15, 60, 30)

SWEP.BarrelLength = 24

SWEP.Attachments = {
	{
		PrintName = "Optic",
		DefaultAttName = "No Scope",
		Slot = {"ez_optic", "ez_optic_combine"},
		Bone = "OICW_weapon",
		Offset = {
			vang = Angle(0, 180, 90),
			vpos = Vector(2.6, -3.5, -0.05),
			wpos = Vector(0.6, 0.8, -8.2),
			wang = Angle(-4, 0, 180)
		},
		CorrectiveAng = Angle(0, 0, 0),
		CorrectivePos = Vector(0, 0, 0.03),
		-- remove Slide because it ruins my life
		Installed = "optic_aboot_scope_oicw"
		--Installed = "optic_jack_scope_acog"
	},
	{
		PrintName = "Tactical",
		DefaultAttName = "No Attachment",
		Slot = {"tac", "ez_tac", "flashlight", "light"},
		Bone = "OICW_weapon",
		Offset = {
			vpos = Vector(-14, -1.5, 1.4), -- offset that the attachment will be relative to the bone
			vang = Angle(0, 180, 180),
			wpos = Vector(28, -1, -10),
			wang = Angle(-5, 0, -92)
		},
		--Hidden = true, -- attachment cannot be seen in customize menu
	},
    {
        PrintName = "Grenade Launcher",
        Slot = {"ez_oicw_gl"},
        DefaultAttName = "DISABLED",
        Installed = "ubgl_aboot_oicw_gl",
    },
	{
		PrintName = "Perk",
		Slot = "perk"
	}
}

SWEP.ExtraSightDist = 10


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
        Source = {"fire1","fire2","fire3","fire4"},
		ShellEjectAt = 0,
    },
    ["enter_inspect"] = {
		Mult = 0.8,
        Source = {"fidget","fidget2"},
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    },
	["altreload"] = {
        Source = "reloadsecondary",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
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
}

hook.Add( "StartCommand", "JModHL2_OICWscrollCapture", function( ply, cmd )
	local Wep = ply:GetActiveWeapon()
	if IsValid(Wep) and (Wep:GetClass() == "wep_aboot_jmod_oicw") and Wep.GetState and (Wep:GetState() == ArcCW.STATE_SIGHTS) and (Wep:GetActiveSights().ScrollFunc == ArcCW.SCROLL_NONE) then
		if (cmd:KeyDown(IN_USE)) then
			local Tr = util.QuickTrace(ply:GetShootPos(), ply:GetAimVector() * 32768, ply)
			local DistToTime = Tr.HitPos:Distance(Tr.StartPos) / 2400
			--jprint(Tr.HitPos:Distance(Tr.StartPos) / 10000)
			Wep:SetNW2Float("EZfuseTime", math.Clamp(math.Round(DistToTime, 2), 0.1, 2))
		end
		if (cmd:GetMouseWheel() ~= 0) then
			Wep:SetNW2Float("EZfuseTime", math.Clamp(Wep:GetNW2Float("EZfuseTime", 2) + cmd:GetMouseWheel() * 0.1, 0.1, 2))
			--jprint(Wep:GetNW2Float("EZfuseTime", 1))
			--jprint(ply, " scrolled ", cmd:GetMouseWheel())
		end
	end
end)

sound.Add({
	name = "Weapon_OICW.Fire",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = 80,
	pitch = {97, 103},
	sound = {
		"weapon/oicw/oicw_fire_player_01.wav",
		"weapon/oicw/oicw_fire_player_02.wav",
		"weapon/oicw/oicw_fire_player_03.wav",
		"weapon/oicw/oicw_fire_player_04.wav",
		"weapon/oicw/oicw_fire_player_05.wav",
		"weapon/oicw/oicw_fire_player_06.wav",
	}
})
sound.Add({
	name = "Weapon_OICW.Fire_Alt",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = 80,
	pitch = {97, 103},
	sound = {
		"weapon/oicw/oicw_20mm_fire1.wav",
		"weapon/oicw/oicw_20mm_fire2.wav",
		"weapon/oicw/oicw_20mm_fire3.wav"
	}
})

sound.Add({
	name = "Weapon_OICW.NPC",
	channel = CHAN_STATIC,
	volume = 0.2,
	level = 140,
	pitch = {60, 70},
	sound = {
		")weapon/oicw/oicw_fire_player_01.wav",
		")weapon/oicw/oicw_fire_player_02.wav",
		")weapon/oicw/oicw_fire_player_03.wav",
		")weapon/oicw/oicw_fire_player_04.wav",
		")weapon/oicw/oicw_fire_player_05.wav",
		")weapon/oicw/oicw_fire_player_06.wav",
	}
})

sound.Add({
	name = "Weapon_OICW.Mag_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_mag_release_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Mag_Out",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Mag_In",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_mag_in_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Mag_Slap",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_mag_slap_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Bolt_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_bolt_release_01.wav"
})
