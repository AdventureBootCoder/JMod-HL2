-- AdventureBoots 2022
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "AdventureBoots"
ENT.Category = "JMod - EZ HL:2"
ENT.Information = "Magnum Opus"
ENT.PrintName = "EZ Hopper Mine"
ENT.NoSitAllowed = true
ENT.Spawnable = true
ENT.AdminSpawnable = true
---
ENT.JModGUIcolorable = true
ENT.JModEZstorable = true
ENT.EZscannerDanger = true
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)

ENT.BlacklistedNPCs = {"bullseye_strider_focus", "npc_turret_floor", "npc_turret_ceiling", "npc_turret_ground"}

ENT.WhitelistedNPCs = {"npc_rollermine"}

---
local STATE_BROKEN, STATE_OFF, STATE_ARMING, STATE_ARMED, STATE_WARNING = -1, 0, 1, 2, 3

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "State")
end

---
if SERVER then
	function ENT:SpawnFunction(ply, tr)
		local SpawnPos = tr.HitPos + tr.HitNormal * 40
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(Angle(0, 0, 0))
		ent:SetPos(SpawnPos)
		JMod.Owner(ent, ply)
		ent:Spawn()
		ent:Activate()

		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/props_combine/combine_mine01.mdl")
		--self:SetMaterial("models/jacky_camouflage/digi2")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(SIMPLE_USE)
		self:GetPhysicsObject():SetMass(20)
		---
		timer.Simple(.01, function()
			self:GetPhysicsObject():SetMass(20)
			self:GetPhysicsObject():Wake()
		end)
		---
		self:SetState(STATE_OFF)
		---
		if istable(WireLib) then
			self.Inputs = WireLib.CreateInputs(self, {"Detonate", "Arm"}, {"This will directly detonate the bomb", "Arms bomb when > 0"})
			self.Outputs = WireLib.CreateOutputs(self, {"State"}, {"1 is armed \n 0 is not \n -1 is broken \n 2 is arming \n 3 is warning"})
		end
		---
		self.StillTicks = 0
		--self:SetLegs(110)
		--self:SetClaws(40)
		self.AutoArm = true
		if self.AutoArm then
			self:NextThink(CurTime() + math.Rand(.1, 1))
		end
		self.WarningSnd = CreateSound(self, "npc/roller/mine/combine_mine_active_loop1.wav")
	end

	function ENT:TriggerInput(iname, value)
		if iname == "Detonate" and value > 0 then
			self:Detonate()
		elseif iname == "Arm" and value > 0 then
			self:SetState(STATE_ARMING)
		end
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > 0.2 then
			if data.Speed > 10 then
				if self:GetState() == STATE_WARNING then
					self:Detonate()
				else
					self:EmitSound("Weapon.ImpactHard")
				end
			end
		end
	end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)

		if JMod.LinCh(dmginfo:GetDamage(), 10, 50) then
			local Pos, State = self:GetPos(), self:GetState()

			if State == STATE_ARMED then
				self:Detonate()
			elseif not (State == STATE_BROKEN) then
				sound.Play("Metal_Box.Break", Pos)
				self:SetState(STATE_BROKEN)
				SafeRemoveEntityDelayed(self, 10)
			end
		end
	end

	function ENT:Use(activator)
		local State = self:GetState()
		if State < 0 then return end
		self.AutoArm = false
		local Alt = activator:KeyDown(JMod.Config.AltFunctionKey)

		if State == STATE_OFF then
			if Alt then
				JMod.Owner(self, activator)
				net.Start("JMod_ColorAndArm")
				net.WriteEntity(self)
				net.Send(activator)
			else
				activator:PickupObject(self)
				JMod.Hint(activator, "arm")
			end
		elseif not (activator.KeyDown and activator:KeyDown(IN_SPEED)) then
			self:EmitSound("snd_jack_minearm.wav", 60, 70)
			self:SetState(STATE_OFF)
			JMod.Owner(self, activator)
			self:DrawShadow(true)
		end
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		local SelfPos = self:LocalToWorld(self:OBBCenter())
		local Up = Vector(0, 0, 1)
		local EffectType = 1
		local Traec = util.QuickTrace(self:GetPos(), Vector(0, 0, -5), self)

		if Traec.Hit then
			if (Traec.MatType == MAT_DIRT) or (Traec.MatType == MAT_SAND) then
				EffectType = 1
			elseif (Traec.MatType == MAT_CONCRETE) or (Traec.MatType == MAT_TILE) then
				EffectType = 2
			elseif (Traec.MatType == MAT_METAL) or (Traec.MatType == MAT_GRATE) then
				EffectType = 3
			elseif Traec.MatType == MAT_WOOD then
				EffectType = 4
			end
		else
			EffectType = 5
		end

		local plooie = EffectData()
		plooie:SetOrigin(SelfPos)
		plooie:SetScale(1)
		plooie:SetRadius(EffectType)
		plooie:SetNormal(Up)
		util.Effect("eff_jack_minesplode", plooie, true, true)
		util.ScreenShake(SelfPos, 99999, 99999, 1, 500)
		self:EmitSound("snd_jack_fragsplodeclose.wav", 90, 100)
		JMod.Sploom(self.Owner, SelfPos, math.random(50, 100))
		--JMod.FragSplosion(self, SelfPos, 1000, 20 * JMod.Config.MinePower, 3000, self.Owner, Up, 1.2, 3)
		self:Remove()
	end

	function ENT:Arm(armer, autoColor)
		local State = self:GetState()
		if State ~= STATE_OFF then return end
		JMod.Hint(armer, "mine friends")
		JMod.Owner(self, armer)
		self:SetState(STATE_ARMING)
		self:EmitSound("snd_jack_minearm.wav", 60, 110)

		if autoColor then
			local Tr = util.QuickTrace(self:GetPos() + Vector(0, 0, 10), Vector(0, 0, -50), self)

			if Tr.Hit then
				local Info = JMod.HitMatColors[Tr.MatType]

				if Info then
					self:SetColor(Info[1])

					if Info[2] then
						self:SetMaterial(Info[2])
					end
				end
			end
		end

		timer.Simple(3, function()
			if IsValid(self) then
				if self:GetState() == STATE_ARMING then
					self:SetState(STATE_ARMED)
					self:DrawShadow(false)
					local Tr = util.QuickTrace(self:GetPos() + Vector(0, 0, 20), Vector(0, 0, -40), self)

					if Tr.Hit then
						self.Weld = constraint.Weld(Tr.Entity, self, 0, 0, 5000, false, false)
						if self.Weld then
							self.Weld:Activate()
						end
					end
				end
			end
		end)
	end

	function ENT:SetLegs(angle)
		self:ManipulateBoneAngles(1,Angle(0,0,angle))
		self:ManipulateBoneAngles(3,Angle(0,0,angle))
		self:ManipulateBoneAngles(5,Angle(0,0,angle))
	end

	function ENT:SetClaws(angle)
		self:ManipulateBoneAngles(2,Angle(0,angle,0))
		self:ManipulateBoneAngles(4,Angle(0,angle,0))
		self:ManipulateBoneAngles(6,Angle(0,angle,0))
		sound.Play("snd_jack_metallicclick.wav",self:GetPos(),70,110)
	end

	function ENT:Launch(targetPos)
		local SelfPos = self:GetPos()
		local ToVec = targetPos - SelfPos
		ToVec.z = 0
		local ToDir = ToVec:GetNormalized()
		local ToAng = ToDir:Angle()
		ToAng:RotateAroundAxis(ToAng:Right(), 66)
		local Dist = SelfPos:Distance(targetPos)
		local Speed = math.sqrt((600 * Dist) / math.sin(2 * math.rad(66)))
		ToDir = ToAng:Forward()*Speed

		constraint.RemoveAll(self)

		local Phys = self:GetPhysicsObject()
		Phys:SetDragCoefficient(0)
		Phys:SetVelocity(ToDir)
	end

	function ENT:Think()
		if istable(WireLib) then
			WireLib.TriggerOutput(self, "State", self:GetState())
		end

		local SelfPos, State, Time = self:GetPos(), self:GetState(), CurTime()

		if State == STATE_ARMED then
			for k, targ in pairs(ents.FindInSphere(SelfPos, 5000)) do
				if not (targ == self) and (targ:IsPlayer() or targ:IsNPC() or targ:IsVehicle()) then

					if JMod.ShouldAttack(self, targ) and JMod.ClearLoS(self, targ) then
						local targPos = targ:GetPos()

						self:SetState(STATE_WARNING)
						self.WarningSnd:Play()

						if targPos:Distance(SelfPos) < 5000 then
							timer.Simple(0.2 * JMod.Config.MineDelay, function()
								if IsValid(self) then
									if self:GetState() == STATE_WARNING then
										self.WarningSnd:Stop()
										self:EmitSound("npc/roller/mine/combine_mine_deploy1.wav", 100)
										local TargetPos = targ:LocalToWorld(targ:OBBCenter()) + targ:GetVelocity()
										self:Launch(TargetPos)
									end
								end
							end)
						end
					else
						self:SetState(STATE_ARMED)
						self.WarningSnd:Stop()
					end
				end
			end

			self:NextThink(Time + .3)

			return true
		elseif self.AutoArm then
			local Vel = self:GetPhysicsObject():GetVelocity()

			if Vel:Length() < 1 then
				self.StillTicks = self.StillTicks + 1
			else
				self.StillTicks = 0
			end

			if self.StillTicks > 4 then
				self:Arm(self.Owner or game.GetWorld(), true)
			end

			self:NextThink(Time + .5)

			return true
		end
	end

	function ENT:OnRemove()
		self.WarningSnd:Stop()
	end

elseif CLIENT then
	function ENT:Initialize()
	end

	--
	local GlowSprite = Material("sprites/mat_jack_basicglow")

	function ENT:Draw()
		self:DrawModel()
		local State, Vary = self:GetState(), math.sin(CurTime() * 50) / 2 + .5

		if State == STATE_ARMING then
			render.SetMaterial(GlowSprite)
			render.DrawSprite(self:GetPos() + Vector(0, 0, 8), 20, 20, Color(255, 0, 0))
			render.DrawSprite(self:GetPos() + Vector(0, 0, 8), 10, 10, Color(255, 0, 0))
		elseif State == STATE_WARNING then
			render.SetMaterial(GlowSprite)
			render.DrawSprite(self:GetPos() + Vector(0, 0, 8), 30, 30, Color(255, 0, 0))
			render.DrawSprite(self:GetPos() + Vector(0, 0, 8), 15, 15, Color(255, 0, 0))
		end
	end

	language.Add("ent_jack_gmod_ezhoppermine", "EZ Hopper Mine")
end
