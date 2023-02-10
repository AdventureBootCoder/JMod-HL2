-- AdventureBoots 2023
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "AdventureBoots"
ENT.Category = "JMod - EZ HL:2"
ENT.Information = ""
ENT.PrintName = "EZ Manifesto"
ENT.NoSitAllowed = true
ENT.Spawnable = false
ENT.AdminSpawnable = true
--- func_breakable
ENT.JModPreferredCarryAngles = Angle(90, -90, 90)
---

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Active")
end

---
if SERVER then
	function ENT:SpawnFunction(ply, tr)
		local SpawnPos = tr.HitPos + tr.HitNormal * 40
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(Angle(0, 0, 0))
		ent:SetPos(SpawnPos)
		JMod.SetOwner(ent, ply)
		ent:Spawn()
		ent:Activate()

		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/props_lab/clipboard.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(ONOFF_USE)

		if self:GetPhysicsObject():IsValid() then
			self:GetPhysicsObject():SetMass(15)
			self:GetPhysicsObject():Wake()
		end

		---
		self:SetActive(false)
		self.NextStick = 0
	end

	--[[function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > 0.2 and data.Speed > 25 then
			self:EmitSound("snd_jack_claythunk.wav", 55, math.random(80, 120))
		end
	end]]--

	function ENT:OnTakeDamage(dmginfo)
		if dmginfo:GetInflictor() == self then return end
		self:TakePhysicsDamage(dmginfo)
	end

	function ENT:Use(activator, activatorAgain, onOff)
		local Dude = activator or activatorAgain
		JMod.SetOwner(self, Dude)
		local Time = CurTime()

		if tobool(onOff) then
			local State = self:GetActive()
			local Alt = Dude:KeyDown(JMod.Config.AltFunctionKey)

			if State == false then
				if Alt then
					self:EmitSound("snd_jack_minearm.wav", 60, 70)
					self:SetActive(true)
				else
					constraint.RemoveAll(self)
					self.StuckStick = nil
					self.StuckTo = nil
					Dude:PickupObject(self)
					self.NextStick = Time + .5
					JMod.Hint(Dude, "sticky")
				end
			else
				self:EmitSound("snd_jack_minearm.wav", 60, 70)
				self:SetActive(false)
			end
		else
			if self:IsPlayerHolding() and (self.NextStick < Time) then
				local Tr = util.QuickTrace(Dude:GetShootPos(), Dude:GetAimVector() * 80, {self, Dude})

				if Tr.Hit and IsValid(Tr.Entity:GetPhysicsObject()) and not Tr.Entity:IsNPC() and not Tr.Entity:IsPlayer() then
					self.NextStick = Time + .5
					local Ang = Tr.HitNormal:Angle()
					Ang:RotateAroundAxis(Ang:Right(), -90)
					Ang:RotateAroundAxis(Ang:Forward(), 0)
					Ang:RotateAroundAxis(Ang:Up(), 0)
					self:SetAngles(Ang)
					self:SetPos(Tr.HitPos)

					-- crash prevention
					if Tr.Entity:GetClass() == "func_breakable" then
						timer.Simple(0, function()
							self:GetPhysicsObject():Sleep()
						end)
					else
						local Weld = constraint.Weld(self, Tr.Entity, 0, Tr.PhysicsBone, 3000, false, false)
						self.StuckTo = Tr.Entity
						self.StuckStick = Weld
					end

					self:EmitSound("snd_jack_claythunk.wav", 65, math.random(80, 120))
					Dude:DropObject()
				end
			end
		end
	end

elseif CLIENT then
	function ENT:Initialize()
	end

	--
	local GlowSprite = Material("sprites/mat_jack_basicglow")

	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_aboot_gmod_ezmanifesto", "EZ Manifesto")
end
