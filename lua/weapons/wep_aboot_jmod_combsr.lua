SWEP.Base = "wep_jack_gmod_gunbase"
SWEP.Spawnable = false -- this obviously has to be set to true
SWEP.Category = "ArcCW - Half Life" -- edit this if you like
SWEP.AdminOnly = false
SWEP.PrintName = "CO-SR"
SWEP.TrueName = "Combine Sniper Rifle"
SWEP.Trivia_Class = "Heavy sniper rifle"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "combine"
SWEP.Trivia_Calibre = "??"
SWEP.Trivia_Mechanism = "??"
SWEP.Trivia_Country = "??"
SWEP.Trivia_Year = "??"
SWEP.NPCFriendly = true
SWEP.Slot = 3
SWEP.ViewModel = "models/weapons/aboot/combsr/c_combsr.mdl"
SWEP.WorldModel = "models/weapons/aboot/combsr/w_combinesniper_e2.mdl"
SWEP.ViewModelFOV = 52

SWEP.CustomToggleCustomizeHUD = false

JMod.ApplyAmmoSpecs(SWEP, "Sniper Pulse Ammo", 1)
-- IN M/S
SWEP.MuzzleVelocity = 400 -- projectile or phys bullet muzzle velocity
SWEP.AlwaysPhysBullet = false
SWEP.NeverPhysBullet = false
SWEP.PhysBullets = true
SWEP.PhysBulletMuzzleVelocity = 120 * 2 -- override phys bullet muzzle velocity
SWEP.PhysBulletDrag = 0.2
SWEP.PhysBulletGravity = 0.3
SWEP.PhysBulletDontInheritPlayerVelocity = true
SWEP.PhysTracerProfile = 6
--
SWEP.AimSwayFactor = .1

SWEP.Bipod_Integral = true -- Integral bipod (ie, weapon model has one)
SWEP.BipodDispersion = 0.3 -- Bipod dispersion for Integral bipods
SWEP.BipodRecoil = 0.1 -- Bipod recoil for Integral bipods

SWEP.ReloadInSights = true
SWEP.ReloadInSights_CloseIn = 0.25
SWEP.ReloadInSights_FOVMult = 0.875
SWEP.LockSightsInReload = false
--
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 1 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 1
SWEP.ReducedClipSize = 1

SWEP.Recoil = -2
SWEP.RecoilSide = 1
SWEP.MaxRecoilBlowback = 1

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

SWEP.NPCWeaponType = {"weapon_ar2", "weapon_crossbow"}
SWEP.NPCWeight = 10

SWEP.AccuracyMOA = 3 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 300 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 500

SWEP.MagID = "cosr" -- the magazine pool this gun draws from

SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "npc/sniper/echo1.wav" --"npc/sniper/sniper1.wav" --"weapons/ar2/fire1.wav"
SWEP.ShootSoundSilenced = "weapons/arccw/m4a1/m4a1_01.wav" -- You can't silence a mag gun
SWEP.DistantShootSound = "npc/sniper/sniper1.wav" --"npc/sniper/echo1.wav" --"weapons/ar2/fire1.wav"

SWEP.MuzzleEffect = "muzzleflash_5"
SWEP.ShellModel = nil--"models/shells/shell_338mag.mdl"
SWEP.ShellPitch = 60
SWEP.ShellScale = 2

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SightTime = 0.25
SWEP.SpeedMult = 0.7
SWEP.SightedSpeedMult = 0.3

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
	-- [0] = "bulletchamber",
	-- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = true

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
	Pos = Vector(-6.15, -11.055, 1.35),
	Ang = Angle(0.792, 0.017, 0),
	Magnification = 1.1,
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG

SWEP.ActivePos = Vector(2, 3, -1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(6, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 50
SWEP.AttachmentElements = {
	["nors"] = {
		VMBodygroups = {{ind = 2, bg = 1}},
		WMBodygroups = {},
	},
	["extendedmag"] = {
		VMBodygroups = {{ind = 1, bg = 1}},
		WMBodygroups = {{ind = 1, bg = 1}},
	},
	["reducedmag"] = {
		VMBodygroups = {{ind = 1, bg = 2}},
		WMBodygroups = {{ind = 1, bg = 2}},
	}
}

SWEP.ExtraSightDist = 5

SWEP.Attachments = {
	{
		PrintName = "Optic", -- print name
		DefaultAttName = "Iron Sights",
		Slot = {"optic", "optic_sniper", "optic_lp", "ez_optic_combine", "ez_optic"}, -- what kind of attachments can fit here, can be string or table
		Bone = "v_weapon.g3sg1_Parent", -- relevant bone any attachments will be mostly referring to
		Offset = {
			vpos = Vector(0.1, -8.5, 0.5),
			vang = Angle(-90, 0, -90),
			wpos = Vector(0, 0, -7),
			wang = Angle(-15, 0, 180)
		},
		--InstalledEles = {"nors"},
		CorrectivePos = Vector(0, 0, 0),
		CorrectiveAng = Angle(0, 0, 0),
		Installed = "optic_aboot_scope_combsr"
	},
	--[[{
		PrintName = "Muzzle",
		DefaultAttName = "Standard Muzzle",
		Slot = "muzzle",
		Bone = "v_weapon.g3sg1_Parent",
		Offset = {
			vpos = Vector(0.1, -6.05, -35),
			vang = Angle(-90, 0, -90),
			wpos = Vector(50, 1.2, -15.3),
			wang = Angle(-10,-3, 0)
		},
		--InstalledEles = {"nobrake"},
	},--]]
	{
		PrintName = "Stock",
		Slot = "stock",
		DefaultAttName = "Standard Stock"
	},
	{
		PrintName = "Ammo",
		Slot = "ammo"
	},
	{
		PrintName = "special",
		Slot = "spec"
	},
	
}

SWEP.Animations = {
	["idle"] = {
		Source = "idle1",
		Time = 1
	},
	["draw"] = {
		Source = "draw",
		Time = 1,
		LHIK = true,
		LHIKIn = 0,
		LHIKOut = 0.25,
	},
	--[[["ready"] = {
		Source = "ready",
		Time = 2,
		LHIK = true,
		LHIKIn = 0,
		LHIKOut = 0.25,
	},--]]
	["fire"] = {
		Source = {"shoot", "shoot2"},
		Time = 1,
	},
	--[[["cycle"] = {
		Source = "cycle",
		Time = 1.25,
		ShellEjectAt = 0.75,
		LHIK = true,
		LHIKIn = 0.15,
		LHIKOut = 0.15,
	},--]]
	--[[["reload"] = {
		Source = "reload",
		Time = 2,
		TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
		Checkpoints = {24, 33, 51},
		FrameRate = 30,
		LHIK = true,
		LHIKIn = 0.5,
		LHIKOut = 0.5,
	},
	["reload_empty"] = {
		Source = "reload",
		Time = 2,
		TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
		Checkpoints = {24, 33, 51},
		FrameRate = 30,
		LHIK = true,
		LHIKIn = 0.5,
		LHIKOut = 0.5,
	},--]]
	["reload"] = {
		Source = "idle1",
		SoundTable = {
			{
				s = "npc/sniper/reload1.wav", -- sound; can be string or table
				p = 100, -- pitch
				v = 75, -- volume
				t = 0, -- time at which to play relative to Animations.Time
				c = CHAN_ITEM, -- channel to play the sound
			}
		},
		Time = 2,
		TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		--Checkpoints = {24, 33, 51},
		FrameRate = 30,
		--LHIK = true,
		--LHIKIn = 0.5,
		--LHIKOut = 0.5,
	},
	["reload_empty"] = {
		Source = "idle1",
		SoundTable = {
			{
				s = "npc/sniper/reload1.wav", -- sound; can be string or table
				p = 100, -- pitch
				v = 75, -- volume
				t = 0, -- time at which to play relative to Animations.Time
				c = CHAN_ITEM, -- channel to play the sound
			}
		},
		Time = 2,
		TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		--Checkpoints = {24, 33, 51},
		FrameRate = 30,
		--LHIK = true,
		--LHIKIn = 0.5,
		--LHIKOut = 0.5,
	},--]]
}

SWEP.Hook_Think = function(self)
	if not SERVER then return end
	if self.Primary.Ammo ~= "Sniper Pulse Ammo" then self.NextRechargeTime = nil return end
	local Time = CurTime()
	local SelfAmmo, MaxAmmo = self.Owner:GetAmmoCount("Sniper Pulse Ammo"), game.GetAmmoMax(game.GetAmmoID("Sniper Pulse Ammo")) * JMod.Config.Weapons.AmmoCarryLimitMult

	self.NextRechargeTime = self.NextRechargeTime or 0
	if (self.NextRechargeTime < Time) and (Time > self:GetNextPrimaryFire() + 1) and (SelfAmmo < MaxAmmo) then
		self.NextRechargeTime = Time + 3
		self.Owner:GiveAmmo(math.min(MaxAmmo - SelfAmmo, 1), "Sniper Pulse Ammo", true)
		--self:EmitSound("npc/sniper/reload1.wav", 65, 50)
	end
end

sound.Add({name = "clipout_com",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 80,
	sound = "sniper/magout.wav"
})

sound.Add({name = "clipin_com",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 80,
	sound = "sniper/magin.wav"
})

sound.Add({name = "boltpull_com",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 80,
	sound = "npc/sniper/reload1.wav"
})

sound.Add({name = "deploy_com",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 80,
	sound = "sniper/foley.wav"
})

function SWEP:GetAimTrace()
	local Owner = self:GetOwner()
	local Attach = self:GetAttachment(self:LookupAttachment("muzzle"))
	local Tr = util.QuickTrace(Attach.Pos, Attach.Ang:Forward() * 40000, Owner)
	return Owner:GetEyeTrace()--Tr
end

if CLIENT then
	function SWEP:ShouldDrawBeam()
		return CurTime() > self:GetNextPrimaryFire() and (self:Clip1() > 0) and (self:GetState() ~= ArcCW.STATE_SPRINT) and (self:GetState() ~= ArcCW.STATE_CUSTOMIZE) and (self:GetFireMode() ~= 2)
	end

	local beam = Material("effects/bluelaser1")
	local sprite = Material("effects/blueflare1")

	function SWEP:DrawHUDBackground()
		if true then return end
		if not(self.GetInZoom and self:GetInZoom()) then
			--return
		end

		for _, target in ents.Iterator() do
			if not IsValid(target) or not (target:IsNPC() or target:IsPlayer()) then
				continue
			end

			if target == self:GetOwner() or target:Health() <= 0 then
				continue
			end

			local tpos = target:WorldSpaceCenter()

			self.PixVis[target] = self.PixVis[target] or util.GetPixelVisibleHandle()

			local vis = util.PixelVisible(tpos, target:GetModelRadius(), self.PixVis[target])

			if vis == 0 then
				--continue
			end

			local time = 0--self:GetTimeToTarget(tpos)

			self.LeadVelocity[target] = LerpVector(FrameTime(), self.LeadVelocity[target] or Vector(), target:GetVelocity())

			local lead = (tpos + (target:GetVelocity() * time)):ToScreen()
			local tpos2 = tpos:ToScreen()

			local w = 5
			local color = Vector(0, 0, 1)

			surface.SetDrawColor(color.x * 255, color.y * 255, color.z * 255)

			surface.DrawLine(tpos2.x, tpos2.y, lead.x, lead.y)

			surface.DrawLine(lead.x - w, lead.y, lead.x, lead.y - w)
			surface.DrawLine(lead.x, lead.y - w, lead.x + w, lead.y)
			surface.DrawLine(lead.x - w, lead.y, lead.x, lead.y + w)
			surface.DrawLine(lead.x, lead.y + w, lead.x + w, lead.y)
		end
	end--]]

	local function CombinePreDrawViewModel(vm, ply, wep)
		if wep:GetClass() ~= "wep_aboot_jmod_combsr" then return end
		wep.ViewModelFOV = 54 + (54 - ply:GetFOV()) * 0.1

		if wep:ShouldDrawBeam() then
			cam.Start3D(nil, nil, ply:GetFOV())
				cam.IgnoreZ(true)

				local Attach = vm:GetAttachment(2)
				local pos = Attach.Pos
				local tr = util.TraceLine({
					start = pos,
					endpos = pos + Attach.Ang:Up() * 10000,
					filter = ply
				})--wep:GetAimTrace()

				render.SetMaterial(beam)
				render.DrawBeam(pos, tr.HitPos, 1, 0, tr.Fraction * 10, Color(255, 0, 0))
				render.SetMaterial(sprite)
				render.DrawSprite(tr.HitPos, 2, 2, Color(50, 190, 255))
			cam.End3D()
		end

		cam.IgnoreZ(true)
	end
	hook.Add("PreDrawViewModel", "CombinePreDrawViewModel", CombinePreDrawViewModel)
	--hook.Remove("PreDrawViewModel", "CombinePreDrawViewModel")

	hook.Add("PostDrawTranslucentRenderables", "JMOD_COMBSR_DRAW", function(bDepth, bSkybox)
		--local ply, Time = LocalPlayer(), CurTime()
		--local ply = self:GetOwner()

		for _, ply in player.Iterator() do
			if not ply:Alive() then continue end
			local Sniper = ply:GetActiveWeapon()

			if not IsValid(Sniper) or Sniper:GetClass() ~= "wep_aboot_jmod_combsr" then
				continue
			end

			if ply == LocalPlayer() and LocalPlayer():GetViewEntity() == LocalPlayer() and not ply:ShouldDrawLocalPlayer() then
				continue
			end

			if ply:InVehicle() then continue end
			if ply:GetNoDraw() then continue end

			if Sniper:ShouldDrawBeam() then
				local Attach = Sniper:GetAttachment(2)
				local pos = Attach.Pos
				local tr = util.TraceLine({
					start = pos,
					endpos = pos + ply:GetAimVector() * 10000,
					filter = ply
				})

				render.SetMaterial(beam)
				render.DrawBeam(pos, tr.HitPos, 1, 0, tr.Fraction * 10, Color(255, 0, 0))
				render.SetMaterial(sprite)
				render.DrawSprite(tr.HitPos, 2, 2, Color(50, 190, 255))
			end
		end
	end)--]]
end
