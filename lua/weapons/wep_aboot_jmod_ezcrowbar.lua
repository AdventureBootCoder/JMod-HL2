-- Jackarunda 2021 - AdventureBoots 2023
AddCSLuaFile()
SWEP.Base = "wep_jack_gmod_ezmeleebase"
SWEP.PrintName = "EZ Crowbar"
SWEP.Author = "Jackarunda"
SWEP.Purpose = ""
JMod.SetWepSelectIcon(SWEP, "entities/ent_aboot_gmod_ezcrowbar")
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"--"models/weapons/crowbar/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.BodyHolsterModel = "models/weapons/w_crowbar.mdl"
SWEP.BodyHolsterSlot = "back"
SWEP.BodyHolsterAng = Angle(-93, -90, 0)
SWEP.BodyHolsterAngL = Angle(-93, -90, 0)
SWEP.BodyHolsterPos = Vector(3, -10, -3)
SWEP.BodyHolsterPosL = Vector(4, -10, 3)
SWEP.BodyHolsterScale = 1
SWEP.ViewModelFOV = 50
SWEP.Slot = 1
SWEP.SlotPos = 5


SWEP.VElements = {
	--[[["crowbar"] = {
		type = "Model",
		model = "models/weapons/w_crowbar.mdl",
		bone = "ValveBiped.Bip01_L_Hand",
		rel = "",
		pos = Vector(3, 2, 10),
		angle = Angle(0, 0, -85),
		size = Vector(1, 1, 1),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	}--]]
}

SWEP.WElements = {
	--[[["crowbar"] = {
		type = "Model",
		model = "models/weapons/w_crowbar.mdl",
		bone = "ValveBiped.Bip01_R_Hand",
		rel = "",
		pos = Vector(0, 0, 0),
		angle = Angle(90, 0, 0),
		size = Vector(1, 1, 1),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	}--]]
}

SWEP.DropEnt = "ent_aboot_gmod_ezcrowbar"
--
SWEP.HitDistance		= 50
SWEP.HitInclination		= 0
SWEP.HitSpace 			= -15
SWEP.HitAngle 			= 45
SWEP.HitPushback		= 100
SWEP.MaxSwingAngle		= 100
SWEP.SwingSpeed 		= 2
SWEP.SwingPullback 		= 5
SWEP.SwingOffset 		= Vector(5, 10, -3)
SWEP.PrimaryAttackSpeed = 0.4
SWEP.SecondaryAttackSpeed 	= 0.8
SWEP.DoorBreachPower 	= .5
--
SWEP.SprintCancel 	= false
SWEP.StrongSwing 	= true
SWEP.SecondaryPush	= false
--
SWEP.SwingSound 	= Sound( "Weapon_Crowbar.Single" )
SWEP.HitSoundWorld 	= Sound( "SolidMetal.ImpactHard" )
SWEP.HitSoundBody 	= Sound( "Flesh.ImpactHard" )
SWEP.PushSoundBody 	= Sound( "Flesh.ImpactSoft" )
--
SWEP.IdleHoldType 	= "melee"
SWEP.SprintHoldType = "melee"
SWEP.ShowWorldModel = true
SWEP.SwingVisualLowerAmount = 2
--

function SWEP:CustomInit()
	self:SetTaskProgress(0)
	self.NextTaskTime = 0
	self:SetSwinging(false)
	self.SwingProgress = 1
end

function SWEP:CustomSetupDataTables()
	self:NetworkVar("Float", 1, "TaskProgress")
end

function SWEP:CustomThink()
	local Time = CurTime()
	if self.NextTaskTime < Time then
		self:SetTaskProgress(0)
		self.NextTaskTime = Time + self.SecondaryAttackSpeed + 1
	end
end

local FleshTypes = {
	MAT_ANTLION,
	MAT_FLESH,
	MAT_BLOODYFLESH,
	MAT_FLESH,
	MAT_ALIENFLESH
}

function SWEP:OnHit(swingProgress, tr, secondary)
	local Owner = self:GetOwner()
	local SwingAng = Owner:EyeAngles()
	local SwingPos = Owner:GetShootPos()
	local StrikeVector = tr.HitNormal
	local StrikePos = (SwingPos - (SwingAng:Up() * 15))

	local CrowDam = DamageInfo()
	CrowDam:SetAttacker(Owner)
	CrowDam:SetInflictor(self)
	CrowDam:SetDamagePosition(tr.HitPos)
	CrowDam:SetDamageType(DMG_SLASH)
	CrowDam:SetDamage(math.random(10, 25) * JMod.GetPlayerStrength(Owner) * JMod.Config.Weapons.DamageMult)
	CrowDam:SetDamageForce(StrikeVector:GetNormalized() * 2000 * JMod.GetPlayerStrength(Owner))

	if secondary then
		if IsValid(tr.Entity) then
			local Message = JMod.EZprogressTask(tr.Entity, StrikePos, Owner, "loosen")

			if Message then
				self.Owner:PrintMessage(HUD_PRINTCENTER, Message)
				self:TryBustDoor(Ent, self.DoorBreachPower, Pos)
			else
				JMod.Hint(Owner, "work spread")
				self:SetTaskProgress(tr.Entity:GetNW2Float("EZloosenProgress", 0))
				CrowDam:SetDamage(0)
			end
		elseif JMod.IsDoor(tr.Entity) then
			self:TryBustDoor(tr.Entity, math.random(35, 50), tr.HitPos)
			self:SetTaskProgress(0)
		else
			CrowDam:SetDamage(CrowDam:GetDamage() * 1.2)
			self:SetTaskProgress(0)
		end
	end

	tr.Entity:TakeDamageInfo(CrowDam)

	sound.Play(util.GetSurfaceData(tr.SurfaceProps).impactHardSound, tr.HitPos, 75, 100, 1)
	util.Decal("ManhackCut", tr.HitPos + tr.HitNormal * 10, tr.HitPos - tr.HitNormal * 10, {self, Owner})
end

function SWEP:FinishSwing(swingProgress)
	if swingProgress >= self.MaxSwingAngle then
		self:SetTaskProgress(0)
	else
		self.NextTaskTime = CurTime() + self.SecondaryAttackSpeed + 1
	end
end

local LastProg = 0

function SWEP:DrawHUD()
	if GetConVar("cl_drawhud"):GetBool() == false then return end
	local Ply = self.Owner
	if Ply:ShouldDrawLocalPlayer() then return end
	local W, H = ScrW(), ScrH()

	local Prog = self:GetTaskProgress()

	if Prog > 0 then
		draw.SimpleTextOutlined("Loosening... ", "Trebuchet24", W * .5, H * .45, Color(255, 255, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, 50))
		draw.RoundedBox(10, W * .3, H * .5, W * .4, H * .05, Color(0, 0, 0, 100))
		draw.RoundedBox(10, W * .3 + 5, H * .5 + 5, W * .4 * LastProg / 100 - 10, H * .05 - 10, Color(255, 255, 255, 100))
	end

	LastProg = Lerp(FrameTime() * 5, LastProg, Prog)
end

if CLIENT then
	local LastProg = 0

	SWEP.Hook_DrawHUD = function(self)
		if GetConVar("cl_drawhud"):GetBool() == false then return end
		local Ply = self.Owner
		if Ply:ShouldDrawLocalPlayer() then return end
		local Prog = self:GetNW2Float("EZtaskProgress", 0)
		local W, H, Build = ScrW(), ScrH()

		if Prog > 0 then
			draw.SimpleTextOutlined("Loosening...", "Trebuchet24", W * .5, H * .45, Color(255, 255, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, 50))
			draw.RoundedBox(10, W * .3, H * .5, W * .4, H * .05, Color(0, 0, 0, 100))
			draw.RoundedBox(10, W * .3 + 5, H * .5 + 5, W * .4 * LastProg / 100 - 10, H * .05 - 10, Color(255, 255, 255, 100))
		end
		LastProg = Lerp(FrameTime() * 5, LastProg, Prog)
	end
end

sound.Add({name = "JMod_Weapon_Crowbar.Melee_Miss2",
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
sound.Add({name = "JMod_Weapon_Crowbar.Melee_Hit2",
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

sound.Add({name = "JMod_Weapon_HEV.Crowbar_Draw",
	channel = CHAN_STATIC,
	level = 60,
	volume = 0.75,
	sound = {
		"fx/hev_suit/hev_draw_crowbar_01.wav",
		"fx/hev_suit/hev_draw_crowbar_02.wav",
		"fx/hev_suit/hev_draw_crowbar_03.wav"
	}
})
sound.Add({name = "JMod_Weapon_HEV.Crowbar_Swing",
	channel = CHAN_WEAPON,
	level = 79,
	volume = 0.6,
	pitch = {97, 103},
	sound = {
		"fx/hev_suit/hev_swing_crowbar_01.wav",
		"fx/hev_suit/hev_swing_crowbar_02.wav",
		"fx/hev_suit/hev_swing_crowbar_03.wav"
	}
})
