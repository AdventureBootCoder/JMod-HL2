-- Jackarunda 2021 - AdventureBoots 2023
AddCSLuaFile()
SWEP.Base = "wep_jack_gmod_ezmeleebase"
SWEP.PrintName = "EZ Harpoon"
SWEP.Author = "Jackarunda"
SWEP.Purpose = ""
--JMod.SetWepSelectIcon(SWEP, "entities/ent_jack_gmod_ezcrowbar")
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"--"models/weapons/crowbar/c_crowbar.mdl"
SWEP.WorldModel = "models/props_junk/harpoon002a.mdl"
SWEP.BodyHolsterModel = "models/props_junk/harpoon002a.mdl"
SWEP.BodyHolsterSlot = "back"
SWEP.BodyHolsterAng = Angle(-93, -90, 0)
SWEP.BodyHolsterAngL = Angle(-93, -90, 0)
SWEP.BodyHolsterPos = Vector(3, -10, -3)
SWEP.BodyHolsterPosL = Vector(4, -10, 3)
SWEP.BodyHolsterScale = 1
SWEP.ViewModelFOV = 50
SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.ShowWorldModel = false
SWEP.ShowViewModel = false
SWEP.UseHands = false

SWEP.VElements = {
	["harpoon"] = { 
		type = "Model", 
		model = "models/props_junk/harpoon002a.mdl", 
		bone = "ValveBiped.Bip01_R_Hand", 
		rel = "", 
		pos = Vector(30, 0, 0), 
		angle = Angle(-10, -10, -30), 
		size = Vector(1, 1, 1), 
		color = Color(255, 255, 255, 255), 
		surpresslightning = false, 
		material = "", 
		skin = 0, 
		bodygroup = {} 
	}
}

SWEP.WElements = {
	["harpoon"] = {
		type = "Model",
		model = "models/props_junk/harpoon002a.mdl",
		bone = "ValveBiped.Bip01_R_Hand",
		rel = "",
		pos = Vector(6, 1.5, -15),
		angle = Angle(-80, 0, 0),
		size = Vector(1, 1, 1),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	}--]]
}

SWEP.DropEnt = "ent_aboot_gmod_ezharpoon"
--
SWEP.HitDistance		= 90
SWEP.HitInclination		= 0
SWEP.HitSpace 			= 0
SWEP.HitAngle 			= 45
SWEP.HitPushback		= 200
SWEP.StartSwingAngle	= 135
SWEP.MaxSwingAngle		= 5
SWEP.SwingSpeed 		= 2
SWEP.SwingPullback 		= 5
SWEP.SwingOffset 		= Vector(5, 10, -3)
SWEP.PrimaryAttackSpeed = 1
SWEP.SecondaryAttackSpeed 	= 2
SWEP.DoorBreachPower 	= .5
--
SWEP.SprintCancel 	= true
SWEP.StrongSwing 	= true
SWEP.SecondaryPush	= false
--
SWEP.SwingSound 	= Sound( "Weapon_Crowbar.Single" )
SWEP.HitSoundWorld 	= Sound( "SolidMetal.ImpactHard" )
SWEP.HitSoundBody 	= Sound( "Flesh.ImpactHard" )
SWEP.PushSoundBody 	= Sound( "Flesh.ImpactSoft" )
--
SWEP.IdleHoldType 	= "melee2"
SWEP.SprintHoldType = "knife"
SWEP.SwingVisualLowerAmount = -5
--

function SWEP:CustomInit()
	self:SetSwinging(false)
	self.SwingProgress = 1
end

function SWEP:CustomThink()
	local Time = CurTime()
	if self:GetSwinging() == true then
		self.VElements["harpoon"].pos = Vector(30, 10, 0)
	else
		self.VElements["harpoon"].pos = Vector(30, 0, 0)
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

	if SERVER then
		local PokeDam = DamageInfo()
		PokeDam:SetAttacker(Owner)
		PokeDam:SetInflictor(self)
		PokeDam:SetDamagePosition(tr.HitPos)
		PokeDam:SetDamageType(DMG_BULLET)
		PokeDam:SetDamage(math.random(30, 80) * JMod.GetPlayerStrength(Owner) * JMod.Config.Weapons.DamageMult)
		PokeDam:SetDamageForce(StrikeVector:GetNormalized() * 2000 * JMod.GetPlayerStrength(Owner))
		tr.Entity:TakeDamageInfo(PokeDam)

		local Boolet = {}
		Boolet.Damage = 0
		Boolet.Src = Owner:GetShootPos()
		Boolet.Dir = Owner:GetAimVector()
		self:FireBullets(Boolet)
		--jprint("Boolet")--]]
	end
end

function SWEP:FinishSwing(swingProgress)
end