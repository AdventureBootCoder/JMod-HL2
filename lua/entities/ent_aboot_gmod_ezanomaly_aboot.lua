-- Jackarunda 2021
AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "T H E   B O O T"
ENT.Author = "AdventureBoots"
ENT.NoSitAllowed = true
ENT.Spawnable = false
ENT.AdminSpawnable = false
---
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)
---
local STATE_GNORMAL, STATE_SHANK_A_BITCH, STATE_DELET_THIS = 0, 1, 2
---
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "VisualState")
end

---
if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_junk/shoe001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(SIMPLE_USE)
		local Phys = self:GetPhysicsObject()

		if IsValid(Phys) then
			Phys:SetMass(100)
			Phys:Wake()
		end

		timer.Simple(0, function()
			self:PhysicsInit(SOLID_VPHYSICS)
			local Phys = self:GetPhysicsObject()

			if IsValid(Phys) then
				Phys:SetMass(100)
				Phys:SetDamping(.5, .5)
				Phys:Wake()
			end
		end)

		self.FreezeTime = 0
		self.Restlessness = 1
		self.CachePos = self:GetPos()
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > 0.2 then
			if data.Speed > 200 then
				self:EmitSound("Drywall.ImpactHard")
				self.FreezeTime = CurTime() + 10
			end
		end
	end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)
		self.FreezeTime = CurTime() + 10
	end

	function ENT:Use(activator)
	end

	---
	local Objectives = {"steal", "kill"}
	function ENT:GetObjective()
		local CurObjective = self.EZobjective
		if self.EZobjective then
			local Target = self:GetTarget(self.EZobjective)
			if self:CanCompleteObjective(self.EZobjective, Target) then
				return self.EZobjective
			end 
		end
		return table.Random(Objectives)
	end

	function ENT:GetTarget(objective)
		local Target = nil

		if objective == "kill" then
			local Closest, SelfPos = 9e9, self:GetPos()

			for k, v in pairs(player.GetAll()) do
				if v:Alive() then
					local Dist = SelfPos:Distance(v:GetPos())

					if Dist < Closest then
						Target = v
						Closest = Dist
					end
				end
			end
		elseif objective == "steal" then
			local Closest, SelfPos = 9e9, self:GetPos()

			local Resources = {}
			for _, v in ipairs(ents.GetAll()) do

				if v.IsJackyEZresource and not(v:IsPlayerHolding()) and (v:GetPos():Distance(self.CachePos) > 200) then
					table.insert(Resources, v)
				end
			end
			if table.IsEmpty(Resources) then return Target end

			for k, v in pairs(Resources) do
				local Dist = SelfPos:Distance(v:GetPos())

				if (Dist < 2000) and (Dist < Closest) then
					Target = v
					Closest = Dist
				end
			end
		end

		return Target
	end

	function ENT:FindGroundAt(pos)
		local Tr = util.QuickTrace(pos + Vector(0, 0, 30), Vector(0, 0, -300), {self})

		if Tr.Hit and not Tr.StartSolid then return Tr.HitPos end

		return nil
	end

	function ENT:IsLocationClear(pos)
		return true -- todo
	end

	function ENT:TryMoveTowardPoint(pos, ent)
		if not ent then ent = self end
		local SelfPos = ent:GetPos()
		local Dir = (pos - SelfPos):GetNormalized()
		local NewPos = SelfPos + Dir * 100
		local NewGroundPos = self:FindGroundAt(NewPos)

		if NewGroundPos then
			if not self:IsLocationBeingWatched(NewGroundPos) then
				if self:IsLocationClear(NewGroundPos) then
					--self:SnapTo(NewGroundPos, ent and ent)
					self:JumpTo(NewGroundPos, ent and ent)

					return true
				end
			end
		end

		return false
	end

	function ENT:TryMoveRandomly()
		local SelfPos = self:GetPos()
		local Dir = VectorRand()
		local NewPos = SelfPos + Dir * 50 * self.Restlessness
		local NewGroundPos = self:FindGroundAt(NewPos)

		if NewGroundPos then
			if not self:IsLocationBeingWatched(NewGroundPos) then
				if self:IsLocationClear(NewGroundPos) then
					--self:SnapTo(NewGroundPos)
					self:JumpTo(NewGroundPos)

					return true
				end
			end
		end

		return false
	end

	function ENT:SnapTo(pos, ent)
		if not ent then ent = self end
		local Yaw = (pos - self:GetPos()):GetNormalized():Angle().y
		ent:SetPos(pos + Vector(0, 0, 5))
		ent:SetAngles(Angle(0, Yaw, 0))
		ent:GetPhysicsObject():Sleep()
		ent:EmitSound("player/footsteps/sand"..tostring(math.random(1, 4))..".wav", 75, 100, 1)
	end

	function ENT:JumpTo(targetPos, ent)
		if not ent then ent = self end
		local SelfPos = self:GetPos()
		local ToVec = targetPos - SelfPos
		ToVec.z = 0
		local ToDir = ToVec:GetNormalized()
		local ToAng = ToDir:Angle()
		local Dist = SelfPos:Distance(targetPos)
		local LaunchAngle = 60
		ToAng:RotateAroundAxis(ToAng:Right(), LaunchAngle)
		ToDir = ToAng:Forward() 
		-----
		local Speed = math.sqrt((600 * Dist) / math.sin(2 * math.rad(LaunchAngle))) * self.Restlessness -- Fancy math
		-----
		constraint.RemoveAll(ent)

		local Phys = ent:GetPhysicsObject()
		timer.Simple(0, function()
			if IsValid(Phys) then
				Phys:EnableMotion(true)
				Phys:SetDragCoefficient(0)
				Phys:AddVelocity((ToDir * Speed) + VectorRand(-1, 1))
			end
		end)
	end

	function ENT:IsLocationBeingWatched(pos)
		if(true)then return false end
		local PotentialObservers = table.Merge(ents.FindByClass("gmod_cameraprop"), player.GetAll())

		for k, obs in pairs(PotentialObservers) do
			local ObsPos = (obs.GetShootPos and obs:GetShootPos()) or obs:GetPos()
			local DirectVec = ObsPos - pos
			local DirectDir = DirectVec:GetNormalized()
			local FacingDir = (obs.GetAimVector and obs:GetAimVector()) or obs:GetForward()
			local ApproachAngle = -math.deg(math.asin(DirectDir:Dot(FacingDir)))

			if ApproachAngle > 30 then
				local Dist = DirectVec:Length()

				if Dist < 5000 then
					local Tr = util.TraceLine({
						start = pos,
						endpos = ObsPos,
						filter = {self, obs},
						mask = MASK_SHOT - CONTENTS_WINDOW
					})

					if not Tr.Hit then return true end
				end
			end
		end

		return false
	end

	function ENT:AmBeingWatched()
		local SelfPos = self:LocalToWorld(self:OBBCenter())

		return self:IsLocationBeingWatched(SelfPos)
	end

	function ENT:GetDesiredPosition(objective, target)
		if objective == "kill" then
			if target then return self:FindGroundAt(target:GetShootPos() - target:GetAimVector() * 100) end
		elseif objective == "steal" then
			if target then
				local RandomDir = VectorRand()
				RandomDir.z = 0
				local Trace = util.QuickTrace(target:LocalToWorld(target:OBBCenter()), RandomDir * 20, target)
				return self:FindGroundAt(Trace.HitPos)
			end
		end

		return nil
	end

	function ENT:FindPatsy(victim)
		local Playas = player.GetAll()

		if #Playas > 1 then
			for k, v in pairs(Playas) do
				if v ~= victim then return v end
			end
		end

		return victim
	end

	function ENT:CanCompleteObjective(objective, target)
		if not IsValid(target) then return false end
		local SelfPos = self:GetPos()

		if objective == "kill" then
			local TargPos = target:GetShootPos()
			local Dist = TargPos:Distance(SelfPos)

			if (Dist <= 220) and (Dist >= 80) then
				return not util.TraceLine({
					start = SelfPos,
					endpos = TargPos,
					filter = {self, target},
					mask = MASK_SHOT
				}).Hit
			end
		elseif objective == "steal" then
			local TargPos = target:GetPos()
			local Dist = TargPos:Distance(SelfPos)

			if Dist <= 50 then
				return not util.TraceLine({
					start = SelfPos,
					endpos = TargPos,
					filter = {self, target},
					mask = MASK_SHOT
				}).Hit
			end
		end

		return false
	end

	function ENT:Think()
		local Time, SelfPos = CurTime(), self:GetPos()

		if not (self:AmBeingWatched() or (self.FreezeTime > Time)) then
			local Objective = self:GetObjective()
			local Target = self:GetTarget(Objective)
			local DesiredPosition = self:GetDesiredPosition(Objective, Target)
			self.EZobjective = Objective

			if DesiredPosition and (DesiredPosition:Distance(SelfPos) >= 100) then
				local Moved = self:TryMoveTowardPoint(DesiredPosition)

				if not Moved then
					self:TryMoveRandomly()
				end
			elseif self:CanCompleteObjective(Objective, Target) then
				if Objective == "kill" then
					if Target then
						local Attacker = self:FindPatsy(Target)

						if Attacker ~= Target then
							self:SetPhysicsAttacker(Attacker, 1)
						end

						local Vec = ((Target:GetShootPos() - Vector(0, 0, 10)) - SelfPos):GetNormalized()
						self:GetPhysicsObject():ApplyForceCenter(Vec * 100000)
					end
				elseif Objective == "steal" then
					if Target then
						self:TryMoveTowardPoint(self.CachePos, Target)
						self:TryMoveTowardPoint(self.CachePos)
					end
				end
			else
				self:TryMoveRandomly()
			end

			self.Restlessness = math.Clamp(self.Restlessness + .1, 1, 5)
		else
			self.Restlessness = 1
		end

		self:NextThink(Time + math.Rand(2, 4) / self.Restlessness)

		return true
	end

	function ENT:OnRemove()
	end
	--
elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_aboot_gmod_ezanomaly_aboot", "A   B O O T")
end
