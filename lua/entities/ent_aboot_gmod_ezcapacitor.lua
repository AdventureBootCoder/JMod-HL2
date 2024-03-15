-- AdventureBoots 2023
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Jackarunda"
ENT.Information = "glhfggwpezpznore"
ENT.PrintName = "EZ Capactior"
ENT.Category = "JMod - EZ HL:2"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Base = "ent_jack_gmod_ezmachine_base"
---
ENT.Model = "models/props_lab/powerbox02d.mdl"
ENT.Mass = 50
ENT.SpawnHeight = 10
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)
ENT.EZupgradable = false
ENT.EZcolorable = false
ENT.StaticPerfSpecs = {
	MaxDurability = 50,
	MaxElectricity = 100
}
ENT.DynamicPerfSpecs = {
	Armor = 1
}
--
ENT.ShockDistance = 1000

local STATE_BROKEN, STATE_OFF, STATE_ON = -1, 0, 1
---

if(SERVER)then
	function ENT:SetupWire()
		if not(istable(WireLib)) then return end
		local WireInputs = {"Toggle [NORMAL]", "On-Off [NORMAL]", "Shock [ENTITY]"}
		local WireInputDesc = {"Greater than 1 toggles machine on and off", "1 turns on, 0 turns off", "Attempts to shock nearby entity"}
		self.Inputs = WireLib.CreateInputs(self, WireInputs, WireInputDesc)
		--
		local WireOutputs = {"State [NORMAL]", "LastShocked [ENTITY]"}
		local WireOutputDesc = {"The state of the machine \n-1 is broken \n0 is off \n1 is on", "The last entity to be shocked"}
		for _, typ in ipairs(self.EZconsumes) do
			if typ == JMod.EZ_RESOURCE_TYPES.BASICPARTS then typ = "Durability" end
			local ResourceName = string.Replace(typ, " ", "")
			local ResourceDesc = "Amount of "..ResourceName.." left"
			--
			local OutResourceName = string.gsub(ResourceName, "^%l", string.upper).." [NORMAL]"
			table.insert(WireOutputs, OutResourceName)
			table.insert(WireOutputDesc, ResourceDesc)
		end
		self.Outputs = WireLib.CreateOutputs(self, WireOutputs, WireOutputDesc)
	end

	function ENT:UpdateWireOutputs()
		if not istable(WireLib) then return end
		WireLib.TriggerOutput(self, "State", self:GetState())
		WireLib.TriggerOutput(self, "LastShocked", self.LastShockedEnt)
		for _, typ in ipairs(self.EZconsumes) do
			if typ == JMod.EZ_RESOURCE_TYPES.BASICPARTS then
				WireLib.TriggerOutput(self, "Durability", self.Durability)
			else
				local MethodName = JMod.EZ_RESOURCE_TYPE_METHODS[typ]
				if MethodName then
					local ResourceGetMethod = self["Get"..MethodName]
					if ResourceGetMethod then
						local ResourceName = string.Replace(typ, " ", "")
						WireLib.TriggerOutput(self, string.gsub(ResourceName, "^%l", string.upper), ResourceGetMethod(self))
					end
				end
			end
		end
	end

	function ENT:TriggerInput(iname, value)
		local State, Owner = self:GetState(), JMod.GetEZowner(self)
		if State < 0 then return end
		if iname == "On-Off" then
			if value == 1 then
				self:TurnOn(Owner)
			elseif value == 0 then
				self:TurnOff(Owner)
			end
		elseif iname == "Toggle" then
			if value > 0 then
				if State == 0 then
					self:TurnOn(Owner)
				elseif State > 0 then
					self:TurnOff(Owner)
				end
			end
		elseif iname == "Shock" then
			if IsValid(value) then
				--self:Shock(self, {HitEntity = value, HitPos = value:GetPos(), HitNormal = (value:GetPos() - self:GetPos()):GetNormalized()})
			end
		end
	end

	function ENT:CustomInit()
		self.ElectricalCallbacks = {}
		self.LastShockedEnt = nil
	end

	function ENT:TurnOn(activator)
		if self:GetState() ~= STATE_OFF then return end

		if (self:GetElectricity() > 0) then
			if IsValid(activator) then self.EZstayOn = true end
			self:SetState(STATE_ON)
			self:CheckForConnection()
		else
			JMod.Hint(activator, "nopower")
		end
	end
	
	function ENT:TurnOff(activator)
		if (self:GetState() <= 0) then return end
		if IsValid(activator) then self.EZstayOn = nil end
		self:SetState(STATE_OFF)
		for k, v in pairs(self.ElectricalCallbacks) do
			Entity(k):RemoveCallback("PhysicsCollide", v)
			self.ElectricalCallbacks[k] = nil
		end
	end

	function ENT:Use(activator)
		local State = self:GetState()
		local OldOwner = self.EZowner
		local alt = activator:KeyDown(JMod.Config.General.AltFunctionKey)
		JMod.SetEZowner(self, activator, true)

		if State == STATE_BROKEN then
			JMod.Hint(activator, "destroyed", self)

			return
		elseif State == STATE_OFF then
			self:TurnOn(activator)
		elseif State >= STATE_ON then
			self:TurnOff(activator)
		end
	end
	
	function ENT:Think()
		local State, Time = self:GetState(), CurTime()
		--local SelfPos, Up, Right, Forward = self:GetPos(), self:GetUp(), self:GetRight(), self:GetForward()

		self:UpdateWireOutputs()
		self.LastShockedEnt = nil

		self:ConsumeElectricity(math.Rand(0.02, 0.05))

		self:NextThink(Time + 1)
		return true
	end

	local Shockables = {MAT_METAL, MAT_VENT, MAT_DEFAULT, MAT_GRATE, MAT_FLESH, MAT_ALIENFLESH}

	local function IsConnectableEnt(ent1, ent2)
		if (ent2:IsValid()) and (ent2:GetClass() == "prop_physics") and (table.HasValue(Shockables, ent2:GetMaterialType())) then
			if IsValid(ent1) then
				local Rad1, Rad2 = ent1:BoundingRadius() + 5, ent2:BoundingRadius() + 5
				local Dist = ent1:LocalToWorld(ent1:OBBCenter()):Distance(ent2:LocalToWorld(ent2:OBBCenter()))

				return (Dist <= (Rad1 + Rad2))
			else
				return true
			end
		end

		return false
	end

	local function FindNextConnection(ent, entToFind, currentDepth, connected)
		currentDepth = currentDepth or 0
		currentDepth = currentDepth + 1
		if currentDepth >= 5 then 
			if IsValid(entToFind) then 
				
				return false 
			else 
				
				return {} 
			end 
		end
		local FoundEnts = connected or {}
		for _, Weld in pairs(constraint.FindConstraints(ent, "Weld")) do
			local EntToCheck = Weld.Ent1
			if not(EntToCheck ~= ent) then
				EntToCheck = Weld.Ent2
			end
			if IsConnectableEnt(ent, EntToCheck) and not(table.HasValue(FoundEnts, EntToCheck)) then
				table.insert(FoundEnts, EntToCheck)
				table.Add(FoundEnts, FindNextConnection(EntToCheck, nil, currentDepth, FoundEnts))
			end
		end
		if IsValid(entToFind) then
			for _, CEnt in pairs(FoundEnts) do
				if CEnt == entToFind then

					return true
				else
					local DeeperSearch = FindNextConnection(CEnt, entToFind, currentDepth)
					if DeeperSearch then

						return DeeperSearch
					end
				end
			end
		end
		
		return FoundEnts
	end

	function ENT:CheckForConnection(shocker)
		if IsValid(shocker) then
			if FindNextConnection(self, shocker) then

				return true
			end
		else
			local AllConnected = FindNextConnection(self, nil, 0)
			for _, Ent in pairs(AllConnected) do
				local EntID = Ent:EntIndex()
				if not(self.ElectricalCallbacks[EntID]) then
					-- Here's where we do the callback thing
					local ShockCallback = Ent:AddCallback("PhysicsCollide", function(ent, data)
						if not(IsValid(ent)) or not(IsValid(data.HitEntity)) or (data.HitEntity == self) then return end
						if data.DeltaTime > 0.2 then
							timer.Simple(0, function()
								if not(IsValid(Ent)) or not(IsValid(data.HitEntity)) then return end
								if IsValid(self) then
									self:Shock(Ent, data)
								elseif ShockCallback then
									Ent:RemoveCallback("PhysicsCollide", ShockCallback)
								end
							end)
						end
					end)
					if ShockCallback then
						self.ElectricalCallbacks[EntID] = ShockCallback
					end
				end
			end
		end

		return false
	end

	function ENT:Shock(shocker, shockedData)
		if self:GetState() == STATE_ON then
			local ShockEnt = shockedData.HitEntity
			if (ShockEnt ~= self) and not(self.ElectricalCallbacks[ShockEnt:EntIndex()]) and (self:GetPos():Distance(shockedData.HitPos) <= self.ShockDistance) then
				local Connected = self:CheckForConnection(shocker)
				if Connected then
					if (ShockEnt:IsPlayer() or ShockEnt:IsNPC()) or table.HasValue(Shockables, ShockEnt:GetMaterialType()) then
						--[[if ShockEnt:GetGroundEntity() != NULL then
							print("Ground Entity: ", ShockEnt:GetGroundEntity())
						end--]]
						DropEntityIfHeld(ShockEnt)
						local Damage, Force = math.random(1, 10), 500 -- Adjust damage and force factors as desired
						local Zap = DamageInfo()
						Zap:SetDamage(Damage)
						Zap:SetDamageForce(-shockedData.HitNormal * Force)
						Zap:SetDamagePosition(shockedData.HitPos)
						Zap:SetAttacker(JMod.GetEZowner(self))
						Zap:SetInflictor(shocker)
						Zap:SetDamageType(DMG_SHOCK)
						ShockEnt:TakeDamageInfo(Zap)
						-- Electrical effect
						local ZapEff = EffectData()
						ZapEff:SetOrigin(shockedData.HitPos)
						ZapEff:SetNormal(shockedData.HitNormal)
						ZapEff:SetMagnitude(math.Rand(5, 10)) --amount and shoot hardness
						ZapEff:SetScale(math.Rand(.5, 1.5)) --length of strands
						ZapEff:SetRadius(math.Rand(2, 4)) --thickness of strands
						util.Effect("Sparks", ZapEff, true, true)
						-- Electrical sound
						shocker:EmitSound("snd_jack_turretfizzle.wav", 70, 90)
						-- Reduce power
						self:ConsumeElectricity(1)
						if ShockEnt:IsPlayer() then
							JMod.EZimmobilize(ShockEnt, 1.5, self)
							ShockEnt:SetGroundEntity(nil)
							local vec = (shockedData.HitPos - ShockEnt:GetPos()):GetNormalized()
							ShockEnt:SetVelocity(vec * 100)
						end
						self.LastShockedEnt = ShockEnt
					end
				end
			else
				shocker:RemoveCallback("PhysicsCollide", self.ElectricalCallbacks[shocker:EntIndex()])
				self.ElectricalCallbacks[shocker:EntIndex()] = nil
			end
		end
	end

	function ENT:OnRemove()
		for k, v in pairs(self.ElectricalCallbacks) do
			if (IsValid(Entity(k))) then
				Entity(k):RemoveCallback("PhysicsCollide", v)
			end
		end
	end

	function ENT:PostEntityPaste(ply, ent, createdEntities)
		local Time = CurTime()
		JMod.SetEZowner(self, ply, true)
		ent.NextRefillTime = Time + math.Rand(0, 3)
		ent.NextResourceThinkTime = 0
	end

elseif(CLIENT)then
	function ENT:CustomInit()
		self.MaxElectricity = 100
	end

	function ENT:Think()
		local State, FT = self:GetState(), FrameTime()
		if State == STATE_ON then
		end
	end

	local GlowSprite = Material("sprites/mat_jack_basicglow")

	function ENT:Draw()
		local Up, Right, Forward, State = self:GetUp(), self:GetRight(), self:GetForward(), self:GetState()
		local SelfPos, SelfAng = self:GetPos(), self:GetAngles()
		--
		local Obscured = util.TraceLine({start = EyePos(), endpos = MotorPos, filter = {LocalPlayer(), self}, mask = MASK_OPAQUE}).Hit
		local Closeness = LocalPlayer():GetFOV() * (EyePos():Distance(SelfPos))
		local DetailDraw = Closeness < 36000 -- cutoff point is 400 units when the fov is 90 degrees
		if State == STATE_BROKEN then DetailDraw = false end -- look incomplete to indicate damage, save on gpu comp too
		--if Obscured then DetailDraw = false end -- if obscured, at least disable details
		--
		self:DrawModel()
		--
		if DetailDraw then
			if State >= STATE_ON then
				local Opacity = math.random(50, 150)
				local DisplayAng = SelfAng:GetCopy()
				DisplayAng:RotateAroundAxis(DisplayAng:Up(), 90)
				DisplayAng:RotateAroundAxis(DisplayAng:Forward(), 90)

				cam.Start3D2D(SelfPos + Forward * 5 + Up * 0, DisplayAng, .05)
					draw.SimpleTextOutlined("POWER", "JMod-Display",0,-30,Color(255,255,255,Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
					local ElecFrac=self:GetElectricity()/self.MaxElectricity
					local R,G,B = JMod.GoodBadColor(ElecFrac)
					draw.SimpleTextOutlined(tostring(math.Round(ElecFrac*100)).."%","JMod-Display",0,0,Color(R,G,B,Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
				cam.End3D2D()
			end
		end
		if State == STATE_ON then
			render.SetMaterial(GlowSprite)
			local SpritePos = SelfPos + Forward * 5 + Right * 0 + Up * 3
			local Vec = (SpritePos - EyePos()):GetNormalized()
			render.DrawSprite(SpritePos - Vec * 5, 20, 20, Color(255, 0, 0))
			render.DrawSprite(SpritePos - Vec * 5, 10, 10, Color(255, 255, 255, 150))
		end
	end
	language.Add("ent_aboot_gmod_ezpounder","EZ Ground-Pounder")
end