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
ENT.EZinvThrowable = true

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
			self:GetPhysicsObject():SetMass(10)
			self:GetPhysicsObject():Wake()
		end)
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.Speed > 200 and data.DeltaTime > 0.2 then
			local PokeDir = self:GetForward()
			local ImpactDot = PokeDir:Dot(data.OurOldVelocity:GetNormalized())
			if ImpactDot > .5 then
				self:EmitSound("SolidMetal.ImpactSoft")

				local RelativeSpeed = (data.OurOldVelocity + data.TheirOldVelocity):Length()
				if not (self:IsPlayerHolding()) and (RelativeSpeed > 300) and not IsValid(self.StuckStick) then
					local PokeStart = self:WorldSpaceCenter() + PokeDir * 50
					local PokeTr = util.QuickTrace(PokeStart, PokeDir * 70, {self})
					debugoverlay.Line(PokeStart, PokeTr.HitPos, 2, Color(255, 0, 0), true)
					if PokeTr.Hit then
						timer.Simple(0, function() 
							if IsValid(self) and IsValid(data.HitEntity) or (data.HitEntity == game.GetWorld()) then
								local PokeDam = DamageInfo()
								PokeDam:SetDamageType(DMG_BULLET)
								PokeDam:SetDamage(RelativeSpeed * .05)
								PokeDam:SetAttacker(JMod.GetEZowner(self))
								PokeDam:SetInflictor(self)
								PokeDam:SetDamagePosition(PokeTr.HitPos)
								PokeDam:SetDamageForce(data.OurOldVelocity)
								PokeTr.Entity:TakeDamageInfo(PokeDam)

								if (RelativeSpeed > 800) and (math.random(1, 6) == 1) then
									self:EmitSound("Wood_Solid.Break")
									SafeRemoveEntity(self)

									return
								end

								self:Impale(PokeStart, PokeDir)
							end
						end)
					end
				end
			else
				self:EmitSound("Wood_Plank.ImpactHard")
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
			activator:PrintMessage(HUD_PRINTCENTER, "Harpoon swep coming soon!")
		else
			if IsValid(self.StuckIn) then
				self:SetParent()
			end
			if IsValid(self.StuckStick) then
				SafeRemoveEntity(self.StuckStick)
				self:SetPos(self:GetPos() + self:GetForward() * -38)
			end
			JMod.SetEZowner(self, activator)
			JMod.ThrowablePickup(activator, self, 1500, 500)
		end
	end

	function ENT:Think()
		--[[if self.StuckIn then
			local StaySticked = true

			if IsValid(self.StuckIn) then
				if self.StuckIn:IsPlayer() and not self.StuckIn:Alive() then
					StaySticked = false
				elseif self.StuckIn:IsNPC() and self.StuckIn.Health and self.StuckIn:Health() <= 0 then
					StaySticked = false
				end
			else
				StaySticked = false
			end

			if not StaySticked then
				local NewPos = self:GetPos()
				self:SetParent(nil)
				self.StuckIn = nil

				--self:SetPos(NewPos)
				StuckTr = util.QuickTrace(self:GetPos(), self:GetForward() * 70, {self})

				if StuckTr.Hit then
					if IsValid(StuckTr.Entity) and StuckTr.Entity:GetMoveType() == MOVETYPE_VPHYSICS then
						self:SetPos(StuckTr.HitPos + StuckTr.Normal * -38)
						--self:SetAngles(StuckTr.Normal:Angle())
						self.StuckStick = constraint.Weld(self, StuckTr.Entity, 0, StuckTr.PhysicsBone, 50000, true, false)
					end
				end
			end

			self:NextThink(CurTime() + 1)

			return true
		else--]]
			JMod.AeroDrag(self, self:GetForward(), 2, 100)
		--end
	end

	function ENT:Impale(start, dir)
		--PokeStart = self:WorldSpaceCenter() + dir * 50
		local WeldTr = util.QuickTrace(start, dir * 70, {self})
		debugoverlay.Line(start, WeldTr.HitPos, 2, Color(255, 81, 0), true)

		if WeldTr.Hit and not WeldTr.HitSky then
			local ImpaleEnt = WeldTr.Entity
			if IsValid(ImpaleEnt) or (ImpaleEnt == game.GetWorld()) then
				if (ImpaleEnt:GetMoveType() == MOVETYPE_VPHYSICS) or (ImpaleEnt:GetMoveType() == MOVETYPE_NONE) then
					if self:GetPhysicsObject():GetVelocity():Length() > 10 then
						self:SetPos(WeldTr.HitPos + WeldTr.Normal * -38)
						self:SetAngles(WeldTr.Normal:Angle())
					end
					self.StuckStick = constraint.Weld(self, ImpaleEnt, 0, WeldTr.PhysicsBone, 50000, true, false)
				elseif WeldTr.Health and WeldTr:Health() <= 0 then
					self.StuckIn = ImpaleEnt
					self:SetParent(ImpaleEnt)
				end
			end
		end
	end

	hook.Add("EntityRemoved", "JMod_HarpoonRelease", function(ent)
		for k, v in pairs(ent:GetChildren()) do
			if IsValid(v) and (v:GetClass() == "ent_aboot_gmod_ezharpoon") then
				local StickPos = v:WorldSpaceCenter()
				local StickDir = v:GetAngles():Forward()
				v:SetParent(nil)
				v:Impale(StickPos, StickDir)
			end
		end
	end)

elseif CLIENT then
	function ENT:Initialize()
	end
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_aboot_gmod_ezharpoon", "EZ Harpoon")
end
