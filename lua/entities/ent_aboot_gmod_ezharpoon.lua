-- Jackarunda 2021 -- AdventureBoots 2023
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Adventure Boots"
ENT.Category = "JMod - EZ HL:2"
ENT.Information = "glhfggwpezpznore"
ENT.PrintName = "EZ Harpoon"
ENT.NoSitAllowed = true
ENT.Spawnable = true
ENT.AdminSpawnable = true
---
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)
ENT.DamageThreshold = 120
ENT.JModEZstorable = true
ENT.SWEPtoGive = "wep_aboot_jmod_ezharpoon"

---
if SERVER then
	function ENT:SpawnFunction(ply, tr)
		local SpawnPos = tr.HitPos + tr.HitNormal * 10
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(Angle(0, 0, 0))
		ent:SetPos(SpawnPos)
		JMod.SetEZowner(ent, ply)
		ent:Spawn()
		ent:Activate()
		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/props_junk/harpoon002a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(SIMPLE_USE)

		self.StuckStick = nil
		---
		timer.Simple(.01, function()
			self:GetPhysicsObject():SetMass(100)
			self:GetPhysicsObject():Wake()
		end)
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > 0.2 then
			if data.Speed > 100 then
				self:EmitSound("Wood_Plank.ImpactHard")
				self:EmitSound("SolidMetal.ImpactHard")
				local RelativeSpeed = (data.OurOldVelocity + data.TheirOldVelocity):Length()
				jprint(RelativeSpeed)
				if (RelativeSpeed > 200) then
					local PokeTr = util.QuickTrace(self:LocalToWorld(self:OBBCenter()), self:GetForward() * 70, {self})
					debugoverlay.Line(self:LocalToWorld(self:OBBCenter()), PokeTr.HitPos, 1, Color(255, 0, 0), true)
					if PokeTr.Hit then
						timer.Simple(0, function() 
							if IsValid(self) and IsValid(data.HitEntity) then
								local PokeDam = DamageInfo()
								PokeDam:SetDamageType(DMG_BULLET)
								PokeDam:SetDamage(RelativeSpeed)
								PokeDam:SetAttacker(JMod.GetEZowner(self))
								PokeDam:SetInflictor(self)
								PokeDam:SetDamagePosition(PokeTr.HitPos)
								PokeDam:SetDamageForce(data.OurOldVelocity)
								PokeTr.Entity:TakeDamageInfo(PokeDam)

								local WeldTr = util.QuickTrace(self:LocalToWorld(self:OBBCenter()), self:GetForward() * 70, {self})

								if WeldTr.Hit then
									self:SetPos(WeldTr.HitPos + WeldTr.HitNormal * 38)
									self.StuckStick = constraint.Weld(self, WeldTr.Entity, 0, WeldTr.PhysicsBone, 0, true, false)
								end
							end
						end)
					end
				end
			end
		end
	end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)

		if dmginfo:GetDamage() > self.DamageThreshold then
			local Pos = self:GetPos()
			sound.Play("Metal_Box.Break", Pos)

			self:Remove()
		end
	end

	function ENT:Use(activator)
		if activator:KeyDown(JMod.Config.General.AltFunctionKey) and not activator:HasWeapon(self.SWEPtoGive) then
			--activator:Give(self.SWEPtoGive)
			--activator:SelectWeapon(self.SWEPtoGive)

			--self:Remove()
		else
			if IsValid(self.StuckStick) then
				SafeRemoveEntity(self.StuckStick)
				self:GetPhysicsObject():EnableCollisions(false)
				timer.Simple(.1, function() 
					if IsValid(self) then 
						self:GetPhysicsObject():EnableCollisions(true) 
					end 
				end)
			end
			JMod.SetEZowner(self, activator)
			JMod.ThrowablePickup(activator, self, 1500, 500)
		end
	end

	function ENT:Think()
		JMod.AeroDrag(self, self:GetForward(), 2, 100)
	end

elseif CLIENT then
	function ENT:Initialize()
	end
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_aboot_gmod_ezharpoon", "EZ Harpoon")
end
