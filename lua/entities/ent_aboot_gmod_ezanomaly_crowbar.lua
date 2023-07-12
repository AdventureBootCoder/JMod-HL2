-- AdventureBoots 2023
AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "C R O B A R"
ENT.Author = "AdventureBoots"
ENT.NoSitAllowed = true
ENT.Spawnable = false
ENT.AdminSpawnable = false
---
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)
---

---
function ENT:SetupDataTables()
end
--
---
if SERVER then
	function ENT:Initialize()
		self:SetModel("models/weapons/w_crowbar.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(SIMPLE_USE)
		self.NextPurr = 0
		local Phys = self:GetPhysicsObject()

		if IsValid(Phys) then
			Phys:Wake()
		end
	end

	--function ENT:PhysicsCollide(data, physobj)
	--end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)
	end

	function ENT:Use(activator)
		if IsValid(activator) and activator:IsPlayer() then
			activator:Give("wep_aboot_jmod_crowbar")
			activator:SelectWeapon("wep_aboot_jmod_crowbar")
			local TrPos = util.QuickTrace(activator:GetPos(), Vector(0, 0, 200), {activator, self}).HitPos
			for i = 0, 20 do
				timer.Simple(0.1 * i, function()
					local RandVec = TrPos + VectorRand(-100, 100)
					local Crab = ents.Create("prop_ragdoll")
					Crab:SetModel("models/headcrabclassic.mdl")
					Crab:SetPos(RandVec)
					Crab:Spawn()
					Crab:Activate()
					timer.Simple(1, function() 
						if IsValid(Crab) then
							local RealCrab = ents.Create("npc_headcrab")
							RealCrab:SetPos(Crab:GetPos())
							RealCrab:Spawn()
							RealCrab:Activate()
							Crab:Remove()
						end
					end)
				end)
			end
			SafeRemoveEntityDelayed(self, 0)
		end
	end

	---
	function ENT:Think()
		local Time = CurTime()
		if self.NextPurr <= Time then
			self.NextPurr = Time + 2
			self:EmitSound("npc/headcrab/idle"..tostring(math.random(1, 2))..".wav", 110)
		end
	end


elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_aboot_gmod_ezanomaly_crowbar", "C R O W B A R")
end