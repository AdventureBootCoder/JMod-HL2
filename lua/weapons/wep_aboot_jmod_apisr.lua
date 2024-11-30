SWEP.Base = "wep_jack_gmod_gunbase"
SWEP.Spawnable = false
SWEP.Category = "ArcCW - Half-Life" -- edit this if you like
SWEP.AdminOnly = false
SWEP.PrintName = "API-SR"
SWEP.Slot = 3
SWEP.ViewModel = "models/weapons/aboot/sniper/c_sniper.mdl"
SWEP.WorldModel = "models/weapons/aboot/sniper/w_sniper.mdl"
SWEP.ViewModelFOV = 75
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(-2, 0, 1),
    ang = Angle(180, 0, 0),--Angle(0, 184, 180)
}
SWEP.NoHideLeftHandInCustomization = true

SWEP.DefaultBodygroups = "00000000000"
JModHL2.ApplyAmmoSpecs(SWEP, "Heavy Rifle Round-API", 1.5)
SWEP.CustomToggleCustomizeHUD = false
--
SWEP.RicPenShotData = {150, true, false, 1}
SWEP.RicPenShotCallback = function(att, tr, dmg)
	local ent = tr.Entity
	local Poof = EffectData()
	Poof:SetOrigin(tr.HitPos)
	Poof:SetScale(1)
	Poof:SetNormal(tr.HitNormal)
	util.Effect("eff_jack_gmod_incbullet", Poof, true, true)
	---
	local DmgI = DamageInfo()
	DmgI:SetDamage(dmg:GetDamage() / 2)
	DmgI:SetDamageType(DMG_BURN)
	DmgI:SetDamageForce(dmg:GetDamageForce())
	DmgI:SetAttacker(dmg:GetAttacker())
	DmgI:SetInflictor(dmg:GetInflictor())
	DmgI:SetDamagePosition(dmg:GetDamagePosition())

	if ent.TakeDamageInfo then
		ent:TakeDamageInfo(DmgI)
	end

	---
	if not ent:IsWorld() and ent.GetPhysicsObject then
		local Mass = 100
		local Phys = ent:GetPhysicsObject()

		if IsValid(Phys) and Phys.GetMass then
			Mass = Phys:GetMass()
		end

		local Chance = (dmg:GetDamage() / Mass) * 2

		if math.Rand(0, 1) < Chance then
			ent:Ignite(math.Rand(1, 2))
		end
	end
end

SWEP.Bipod_Integral = true -- Integral bipod (ie, weapon model has one)
SWEP.BipodDispersion = 1 -- Bipod dispersion for Integral bipods
SWEP.BipodRecoil = 1 -- Bipod recoil for Integral bipods

SWEP.BodyHolsterSlot = "back"
SWEP.BodyHolsterAng = Angle(-10, 0, 0)
SWEP.BodyHolsterAngL = Angle(-10, 10, 180)
SWEP.BodyHolsterPos = Vector(4, -10, -6)
SWEP.BodyHolsterPosL = Vector(4, -10, 4)
SWEP.BodyHolsterScale = .75

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
SWEP.Num = 0 -- number of shots per trigger pull.
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

SWEP.AccuracyMOA = 25 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 800 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 100
SWEP.SightsDispersion = 0
SWEP.JumpDispersion = 500

SWEP.MagID = "Sniper" -- the magazine pool this gun draws from

SWEP.ShootVol = 90 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "Weapon_SniperRifle.Fire"
SWEP.DistantShootSound = "Weapon_SniperRifle.NPC"

SWEP.MirrorVMWM = false -- Copy the viewmodel, along with all its attachments, to the worldmodel. Super convenient!
SWEP.MirrorWorldModel = true -- Use this to set the mirrored viewmodel to a different model, without any floating speedloaders or cartridges you may have. Needs MirrorVMWM

SWEP.MuzzleEffect = "muzzle_center_M82"
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

SWEP.SpeedMult = 0.7
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
	{
		PrintName = "Optic", -- print name
		DefaultAttName = "Iron Sights",
		Slot = {"optic_sniper", "reb_optic", "ez_optic"}, -- what kind of attachments can fit here, can be string or table
		Bone = "gun", -- relevant bone any attachments will be mostly referring to
		Offset = {
			vpos = Vector(0, 0, 5),
			vang = Angle(0, 180, 0),
			wpos = Vector(0, 0, 0),
			wang = Angle(0, 0, 0)
		},
		CorrectivePos = Vector(0, 0, 0),
		CorrectiveAng = Angle(0, 0, 0),
		Installed = "optic_aboot_scope_reb"
	},
	--[[{
		PrintName = "Forward Grip",
		DefaultAttName = "No Attachment",
		Slot = {"ez_bipod"},
		Bone = "gun",
		Offset = {
			vpos = Vector(-18.15, 0.5, 1.1),
			vang = Angle(0, 180, 0),
			wpos = Vector(31.5, 0.6, -9.6),
			wang = Angle(-15, 0, 180)
		},
		--Installed = "underbarrel_aboot_gr9_bipod",
		--Hidden = true, -- attachment cannot be seen in customize menu
		--Integral = true
	},--]]
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
