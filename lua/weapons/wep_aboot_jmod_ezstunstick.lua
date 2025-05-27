-- Jackarunda 2021 - AdventureBoots 2023
AddCSLuaFile()
SWEP.Base = "wep_jack_gmod_ezmeleebase"
SWEP.PrintName = "EZ Stun-Stick"
SWEP.Author = "Jackarunda"
SWEP.Purpose = ""
JMod.SetWepSelectIcon(SWEP, "entities/ent_aboot_gmod_ezstunstick")
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"--"models/weapons/crowbar/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.BodyHolsterModel = "models/weapons/w_stunbaton.mdl"
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

SWEP.DropEnt = "ent_aboot_gmod_ezstunstick"
--
SWEP.HitDistance		= 50
SWEP.HitInclination		= 0
SWEP.HitSpace 			= -15
SWEP.HitAngle 			= 45
SWEP.HitPushback		= 100
SWEP.MaxSwingAngle		= 100
SWEP.SwingSpeed 		= 2
SWEP.SwingPullback 		= 1
SWEP.SwingOffset 		= Vector(5, 10, -3)
SWEP.PrimaryAttackSpeed = 0.9
SWEP.SecondaryAttackSpeed 	= 1
SWEP.DoorBreachPower 	= .1
--
SWEP.SprintCancel 	= false
SWEP.StrongSwing 	= true
SWEP.SecondaryPush	= false
--
SWEP.SwingSound 	= Sound( "Weapon_StunStick.Swing" )
SWEP.HitSoundWorld 	= Sound( "Weapon_StunStick.Melee_HitWorld" )
SWEP.HitSoundBody 	= Sound( "Weapon_StunStick.Melee_Hit" )
SWEP.PushSoundBody 	= Sound( "Weapon_StunStick.Melee_Miss" )
--
SWEP.IdleHoldType 	= "melee"
SWEP.SprintHoldType = "melee"
SWEP.ShowWorldModel = true
SWEP.SwingVisualLowerAmount = 2
--

function SWEP:CustomInit()
	self:SetSwinging(false)
	self.SwingProgress = 1
end

function SWEP:CustomThink()
	--local Time = CurTime()
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
	CrowDam:SetDamageType(DMG_CLUB)
	CrowDam:SetDamage(math.random(10, 25) * JMod.GetPlayerStrength(Owner) * JMod.Config.Weapons.DamageMult)
	CrowDam:SetDamageForce(StrikeVector:GetNormalized() * 2000 * JMod.GetPlayerStrength(Owner))

	local Ent = tr.Entity
	local Pos = tr.HitPos
	local Surface = util.GetSurfaceData(tr.SurfaceProps)

	if tr.Hit and not tr.HitSky and not tr.StartSolid then
		local fx = EffectData()
		fx:SetOrigin(tr.HitPos)
		fx:SetNormal(tr.HitNormal)
		util.Effect("StunstickImpact", fx, true, true)

		if tr.Hit and (Surface) then
			EmitSound(Surface.bulletImpactSound, Pos, 0, CHAN_WEAPON)
		end
	end
	
	if SERVER then
		if IsValid(Ent) then
			if Ent:IsNPC() then
				Ent.EZNPCincapacitate = (Ent.EZNPCincapacitate or CurTime()) + math.Rand(2, 3)
			elseif Ent:IsPlayer() then
				Ent:ViewPunch(Angle(math.random(-40, 2), math.random(-20, 20), math.random(-2, 2)))
				if secondary then
					JMod.EZimmobilize(Ent, 1, Ent)
					JModHL2.EZstun(Ent, 2, Ent)
				else
					JModHL2.EZstun(Ent, .5, Ent)
				end
			end
		end
	end
	tr.Entity:TakeDamageInfo(CrowDam)

	if tr.Hit and Surface then
		EmitSound(Surface.impactHardSound, Pos, 0, CHAN_WEAPON)
	end
end

function SWEP:FinishSwing(swingProgress)
end

if CLIENT then
	local LastProg = 0

	SWEP.Hook_DrawHUD = function(self)
		if GetConVar("cl_drawhud"):GetBool() == false then return end
		local Ply = self.Owner
		if Ply:ShouldDrawLocalPlayer() then return end
	end
end