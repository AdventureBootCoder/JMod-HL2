-- Jackarunda 2021 - AdventureBoots 2023
AddCSLuaFile()
SWEP.Base = "wep_jack_gmod_ezmeleebase"
SWEP.PrintName = "EZ Harpoon"
SWEP.Author = "Jackarunda"
SWEP.Purpose = ""
--JMod.SetWepSelectIcon(SWEP, "entities/ent_jack_gmod_ezcrowbar")
SWEP.ViewModel = "models/weapons/v_jmod_musket.mdl"--"models/weapons/crowbar/c_crowbar.mdl"
SWEP.WorldModel = "models/props_junk/harpoon002a.mdl"
SWEP.BodyHolsterModel = "models/props_junk/harpoon002a.mdl"
SWEP.BodyHolsterSlot = "back"
SWEP.BodyHolsterAng = Angle(-93, -90, 0)
SWEP.BodyHolsterAngL = Angle(-93, -90, 0)
SWEP.BodyHolsterPos = Vector(3, -10, -3)
SWEP.BodyHolsterPosL = Vector(4, -10, 3)
SWEP.BodyHolsterScale = 1
SWEP.ViewModelFOV = 70
SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.ShowWorldModel = false
SWEP.ShowViewModel = false
SWEP.UseHands = false

SWEP.VElements = {
	--[[["harpoon"] = { 
		type = "Model", 
		model = "models/props_junk/harpoon002a.mdl", 
		bone = "ValveBiped.Bip01_R_Hand", 
		rel = "", 
		pos = Vector(0, -200, 0), 
		angle = Angle(-90, 0, 0), 
		size = Vector(1, 1, 1), 
		color = Color(255, 255, 255, 255), 
		surpresslightning = false, 
		material = "", 
		skin = 0, 
		bodygroup = {} 
	}--]]
	["harpoon"] = { 
		type = "Model", 
		model = "models/props_junk/harpoon002a.mdl", 
		bone = "Musket", 
		rel = "", 
		pos = Vector(0, -40, 0), 
		angle = Angle(5, 75, 20), 
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
SWEP.HitSpace 			= 5
SWEP.HitAngle 			= 45
SWEP.HitPushback		= 200
SWEP.StartSwingAngle	= 130
SWEP.MaxSwingAngle		= 50
SWEP.SwingSpeed 		= 1
SWEP.SwingPullback 		= 0
SWEP.SwingOffset 		= Vector(5, 10, -3)
SWEP.PrimaryAttackSpeed = 1
SWEP.SecondaryAttackSpeed 	= 2
SWEP.DoorBreachPower 	= 0
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
SWEP.IdleHoldType 	= "knife"
SWEP.SprintHoldType = "knife"
SWEP.SwingSeq = "dryfire"
SWEP.SwingVisualLowerAmount = -5
--

function SWEP:CustomInit()
	self:SetSwinging(false)
	self.SwingProgress = 1
	self.NextStopStab = 0
end

function SWEP:CustomThink()
	local Time = CurTime()
	local Swinging = self:GetSwinging()
	local SwingFrac = self.SwingProgress/self.MaxSwingAngle	
	--if self:GetSwinging() == true then jprint(self.SwingProgress, SwingFrac) end
	if (Swinging) and (self.NextStopStab < Time) then
		self.NextStopStab = Time + self.PrimaryAttackSpeed * .75
	end

	if self.NextStopStab > Time then
		self.VElements["harpoon"].pos = LerpVector(SwingFrac + .1, self.VElements["harpoon"].pos, Vector(-15, -35, -5))
		self.VElements["harpoon"].angle = LerpAngle(SwingFrac, self.VElements["harpoon"].angle,  Angle(10, 80, 25))
	elseif not(Swinging) then
		self.VElements["harpoon"].pos = LerpVector(FrameTime() * 25, self.VElements["harpoon"].pos, Vector(-15, 0, 0))
		self.VElements["harpoon"].angle = LerpAngle(FrameTime() * 25, self.VElements["harpoon"].angle,  Angle(10, 75, 20))
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
		Boolet.Num = 1
		Boolet.Damage = 1
		Boolet.Src = Owner:GetShootPos()
		Boolet.Dir = Owner:GetAimVector()
		self:FireBullets(Boolet)
		--jprint("Boolet")--]]
	end
end

function SWEP:FinishSwing(swingProgress)
end