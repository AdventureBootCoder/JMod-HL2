-- AdventureBoots 2022
AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "EZ Ammo Crate"
ENT.Author = "AdventureBoots, Jackarunda, TheOnly8Z"
ENT.Category = "JMod - EZ HL:2"
ENT.NoSitAllowed = true
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = true
---
ENT.JModPreferredCarryAngles = Angle(0, 180, 0)
ENT.DamageThreshold = 240
ENT.IsJackyEZcrate = true
---
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Resource")
	self:NetworkVar("String", 0, "ResourceType")
end

function ENT:ApplySupplyType(typ)
	self:SetResourceType(typ)
	self.EZsupplies = typ
	self.MaxResource = 100 * 15 -- slightly smaller than standard
end
---
function ENT:GetEZsupplies(typ)
	local Supplies = {[self:GetResourceType()] = self:GetResource()}
	if typ then
		if Supplies[typ] then
			return Supplies[typ]
		else
			return nil
		end
	else
		return Supplies
	end
end

function ENT:SetEZsupplies(typ, amt, setter)
	if not SERVER then print("[JMOD] - You can't set EZ supplies on client") return end
	if typ ~= self:GetResourceType() then return end
	if amt <= 0 then self:ApplySupplyType("generic") end
	self:SetResource(math.Clamp(amt, 0, self.MaxResource))
end
---
if SERVER then
	function ENT:SpawnFunction(ply, tr)
		local SpawnPos = tr.HitPos + tr.HitNormal * 18
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(Angle(0, 0, 0))
		ent:SetPos(SpawnPos)
		JMod.SetEZowner(ent, ply)
		ent:Spawn()
		ent:Activate()
		--local effectdata=EffectData()
		--effectdata:SetEntity(ent)
		--util.Effect("propspawn",effectdata)

		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/aboot/ammocrate_aboot.mdl")
		--self:SetModelScale(1.5,0)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(SIMPLE_USE)
		---
		self:SetResource(0)
		self:ApplySupplyType("generic")
		self.EZconsumes = {JMod.EZ_RESOURCE_TYPES.AMMO, JMod.EZ_RESOURCE_TYPES.MUNITIONS}
		self.LastOpenTime = 0

		self.NextLoad = 0
		---
		if istable(WireLib) then
			self.Outputs = WireLib.CreateOutputs(self, {"Type [STRING]", "Amount Left [NORMAL]"}, {"Will be 'generic' by default", "Amount of resources left in the crate"})
		end
		---
		timer.Simple(.01, function()
			self:CalcWeight()
		end)
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > 0.2 then
			if data.Speed > 100 then
				self:EmitSound("Metal_Box.ImpactHard")
				--self:EmitSound("Wood_Box.ImpactHard")
			end
		end
	end

	function ENT:CalcWeight()
		local Frac = self:GetResource() / self.MaxResource
		self:GetPhysicsObject():SetMass(150 + Frac * 300)
		self:GetPhysicsObject():Wake()
		if (WireLib) then
			WireLib.TriggerOutput(self, "Type", self:GetResourceType())
			WireLib.TriggerOutput(self, "Amount Left", self:GetResource())
		end
		if self:GetResource() > 0 then
			self:SetBodygroup(1, 2)

			local Resource = self:GetResourceType()
			if Resource == JMod.EZ_RESOURCE_TYPES.AMMO then
				self:SetSubMaterial(2, "models/mat_jack_gmod_ezammobox")
			elseif Resource == JMod.EZ_RESOURCE_TYPES.MUNITIONS then
				self:SetSubMaterial(2, "models/mat_jack_gmod_ezmunitionbox")
			end

		else
			self:SetBodygroup(1, 0)
		end
	end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)

		local Attacker = dmginfo:GetAttacker()
		if (IsValid(Attacker) and Attacker:IsPlayer()) then
			local Wep = Attacker:GetActiveWeapon()
			if IsValid(Wep) and (Wep:GetClass() == "weapon_crowbar") then
				local HL2Ammo = {"AR2", "Pistol", "XBowBolt", "SMG1", "357", "Buckshot", "RPG_Round", "slam", "Grenade", "AlyxGun", "SniperRound"}
				for k, v in ipairs(HL2Ammo) do
					self:Open(true)
					timer.Simple(1, function()
						if IsValid(self) and IsValid(activator) then
							self:GivePlyAmmo(activator, true, v)
						end
					end)
				end
			end
		end

		if dmginfo:GetDamage() > self.DamageThreshold then
			local Pos = self:GetPos()
			sound.Play("Wood_Crate.Break", Pos)
			sound.Play("Wood_Box.Break", Pos)

			if self:GetResourceType() ~= "generic" and self:GetResource() > 0 then
				for i = 1, math.floor(self:GetResource() / 100) do
					local Box = ents.Create(JMod.EZ_RESOURCE_ENTITIES[self:GetResourceType()])
					Box:SetPos(Pos + self:GetUp() * 20)
					Box:SetAngles(self:GetAngles())
					Box:SetVelocity(self:GetVelocity())
					Box:Spawn()
					Box:Activate()
				end
			end

			self:Remove()
		end
	end

	function ENT:UseEffect(pos, ent)
		JMod.ResourceEffect(self:GetResourceType(), self:GetPos(), nil, 1, 1)
	end

	function ENT:Open(closeAfter)
		self:EmitSound("AmmoCrate.Open")
		self:SetSequence("Open")
		self:ResetSequenceInfo()
		if closeAfter then 
			self:Close()
		end
	end

	function ENT:Close()
		timer.Simple(0.5, function()
			if IsValid(self) then
				if self.LastOpenTime < CurTime() then
					self:SetSequence("Close")
					self:ResetSequenceInfo()
					self:EmitSound("AmmoCrate.Close")
				else
					self:Close()
				end
			end
		end)
	end

	local IsAmmoOnTable = function(ammoName, tableToCheck)
		if not ammoName then return false end
		local IsListed = false
		for k, v in ipairs(tableToCheck) do
			if ammoName == v then
				IsListed = true
				break
			elseif string.find(v, '%*$') then
				IsListed = (string.find(ammoName, '^'..string.sub(v, 1, -2)) ~= nil)
				break
			end
		end
		return IsListed
	end

	function ENT:GivePlyAmmo(ply, fillStack, ammoType)
		if self:GetResource() <= 0 then return end
		local Wep = ply:GetActiveWeapon()

		if IsValid(Wep) then
			local PrimType, SecType, PrimSize, SecSize = (ammotype and game.GetAmmoID(ammoType)) or Wep:GetPrimaryAmmoType(), Wep:GetSecondaryAmmoType(), Wep:GetMaxClip1(), Wep:GetMaxClip2()
			local PrimMax, SecMax, PrimName, SecName = game.GetAmmoMax(PrimType), game.GetAmmoMax(SecType), game.GetAmmoName(PrimType), game.GetAmmoName(SecType)
			
			local IsMunitionBox = self.EZsupplies == "munitions"

			--[[ PRIMARY --]]
			if PrimName then 
				PrimMax = PrimMax * JMod.Config.Weapons.AmmoCarryLimitMult
				local IsPrimMunitions = table.HasValue(JMod.Config.Weapons.AmmoTypesThatAreMunitions, PrimName)
				if (IsPrimMunitions == IsMunitionBox) and not(IsAmmoOnTable(PrimName, JMod.Config.Weapons.WeaponAmmoBlacklist)) then
					if PrimType and (PrimType ~= -1) then
						if PrimSize == -1 then
							PrimSize = -PrimSize
						end

						local CurrentAmmo, ResourceLeftInBox = ply:GetAmmoCount(PrimName), self:GetResource()
						local SpaceLeftInPlayerInv = PrimMax - CurrentAmmo
						local AmmoPerResourceUnit = PrimMax / 30
						local ResourceUnitPerAmmo = 1 / AmmoPerResourceUnit
						local AmtToGive = math.min(PrimSize, math.floor(ResourceLeftInBox / ResourceUnitPerAmmo), SpaceLeftInPlayerInv)

						if fillStack then
							AmtToGive = math.min(SpaceLeftInPlayerInv, math.floor(ResourceLeftInBox / ResourceUnitPerAmmo))
						else
							AmtToGive = math.min(SpaceLeftInPlayerInv, PrimSize, math.floor(ResourceLeftInBox / ResourceUnitPerAmmo))
						end
						
						if ply:GetAmmoCount(PrimType) < PrimMax then
							ply:GiveAmmo(AmtToGive, PrimType)
							self:SetResource(ResourceLeftInBox - math.ceil(AmtToGive * ResourceUnitPerAmmo))
							self:UseEffect(self:GetPos(), self)
						end
					end
				end
			end
			
			if self:GetResource() <= 0 then return end
			--[[ SECONDARY --]]
			if SecName then 
				SecMax = SecMax * JMod.Config.Weapons.AmmoCarryLimitMult
				local IsSecMunitions = table.HasValue(JMod.Config.Weapons.AmmoTypesThatAreMunitions, SecName)
				if (IsSecMunitions == IsMunitionBox) and not(IsAmmoOnTable(SecName, JMod.Config.Weapons.WeaponAmmoBlacklist)) then
					if SecType and (SecType ~= -1) then
						if SecSize == -1 then
							SecSize = -SecSize
						end

						local CurrentAmmo, ResourceLeftInBox = ply:GetAmmoCount(SecName), self:GetResource()
						local SpaceLeftInPlayerInv = SecMax - CurrentAmmo
						local AmmoPerResourceUnit = SecMax / 30
						local ResourceUnitPerAmmo = 1 / AmmoPerResourceUnit
						local AmtToGive = 0

						if fillStack then
							AmtToGive = math.min(SpaceLeftInPlayerInv, math.floor(ResourceLeftInBox / ResourceUnitPerAmmo))
						else
							AmtToGive = math.min(SpaceLeftInPlayerInv, SecSize, math.floor(ResourceLeftInBox / ResourceUnitPerAmmo))
						end
						
						if ply:GetAmmoCount(SecType) < SecMax then
							ply:GiveAmmo(AmtToGive, SecType)
							self:SetResource(ResourceLeftInBox - math.ceil(AmtToGive * ResourceUnitPerAmmo))
							self:UseEffect(self:GetPos(), self)
						end
					end
				end
			end
		end
	end

	function ENT:Use(activator)
		JMod.Hint(activator, "crate")
		local Resource, Time = self:GetResource(), CurTime()
		if Resource <= 0 then return end
		local Alt = activator:KeyDown(JMod.Config.General.AltFunctionKey)

		if self.LastOpenTime < Time then
			self:Open(true)
		end

		if Alt then
			timer.Simple(0.5, function()
				if IsValid(self) and IsValid(activator) then
					self:GivePlyAmmo(activator, true)
				end
			end)
		else
			local Box, Given = ents.Create(JMod.EZ_RESOURCE_ENTITIES[self:GetResourceType()]), math.min(Resource, 100)
			timer.Simple(0.5, function()
				if IsValid(self) then
					Box:SetPos(self:GetPos() + self:GetUp() * 5)
					Box:SetAngles(self:GetAngles())
					Box:Spawn()
					Box:Activate()
					Box:SetResource(Given)
					Box.NextLoad = CurTime() + 2
					if IsValid(activator) and activator:Alive() then
						Box:Use(activator, activator)
					end
				end
			end)
			self:SetResource(Resource - Given)
		end
		self:CalcWeight()

		if self:GetResource() <= 0 then
			self:ApplySupplyType("generic")
		end
		self.LastOpenTime = Time + 1
	end

	function ENT:Think()
	end

	--pfahahaha
	function ENT:OnRemove()
	end

	function ENT:TryLoadResource(typ, amt)
		local Time = CurTime()
		if self.NextLoad > Time then return 0 end
		if amt <= 0 then return 0 end

		-- If unloaded, we set our type to the item type
		if self:GetResource() <= 0 and self:GetResourceType() == "generic" then
			self:ApplySupplyType(typ)
		end

		-- Consider the loaded type
		if typ == self:GetResourceType() then
			local Resource = self:GetResource()
			local Missing = self.MaxResource - Resource
			if Missing <= 0 then return 0 end
			local Accepted = math.min(Missing, amt)
			self:SetResource(Resource + Accepted)
			self:CalcWeight()
			self.NextLoad = Time + .5

			return Accepted
		end

		return 0
	end
	
	local RestrictedMaterials = {
		JMod.EZ_RESOURCE_TYPES.FISSILEMATERIAL,
		JMod.EZ_RESOURCE_TYPES.ANTIMATTER
	}
	function ENT:PostEntityPaste(ply)
		local Type = self:GetResourceType()
		if not(JMod.IsAdmin(ply)) and table.HasValue(RestrictedMaterials, Type) then
			self:SetEZsupplies(Type, 0, self)
		end
		self.NextLoad = 0
	end

elseif CLIENT then
	function ENT:Initialize()
		self:DrawShadow(true)
		--self.MaxResource = 100 * 15
	end
	-- 53, 51, 31, 220 Box sample
	--local TxtCol = Color(14, 12, 1, 240)

	function ENT:Draw()
		local Ang, Pos = self:GetAngles(), self:GetPos()
		local Closeness = LocalPlayer():GetFOV() * EyePos():Distance(Pos)
		local DetailDraw = Closeness < 45000 -- cutoff point is 500 units when the fov is 90 degrees
		local ResourceType = self:GetResourceType()
		self:DrawModel()

		if DetailDraw then
			local Up, Right, Forward, Resource = Ang:Up(), Ang:Right(), Ang:Forward(), self:GetResource()
			local BasePos = Pos - Up * 5

			--local BoxAng = Ang:GetCopy()
			--BoxAng:RotateAroundAxis(Up, 90)
			--JMod.RenderModel(self.AmmoBoxModel, BasePos + Right * 20, AmmoAng, Vector(1, 0.9, 1))

			Ang:RotateAroundAxis(Ang:Right(), 90)
			Ang:RotateAroundAxis(Ang:Up(), -90)
			cam.Start3D2D(Pos + Up * 14 - Forward * 16, Ang, .15)
			if string.lower(ResourceType) ~= "generic" then
				JMod.StandardResourceDisplay(ResourceType, Resource, nil, 0, 95, 100, true, "JMod-Stencil-S")
			end
			--draw.SimpleText(string.upper(ResourceType), "JMod-Stencil", 0, -10, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			--draw.SimpleText(Resource .. " UNITS", "JMod-Stencil-S", 0, 150, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			cam.End3D2D()
			---
			Ang:RotateAroundAxis(Ang:Right(), 180)
			cam.Start3D2D(Pos + Up * 14 + Forward * 16.5, Ang, .15)
			if string.lower(ResourceType) ~= "generic" then
				JMod.StandardResourceDisplay(ResourceType, Resource, nil, 0, 95, 100, true, "JMod-Stencil-S")
			end
			--draw.SimpleText(string.upper(ResourceType), "JMod-Stencil", 0, -10, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			--draw.SimpleText(Resource .. " UNITS", "JMod-Stencil-S", 0, 150, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			cam.End3D2D()
		end
	end

	language.Add("ent_jack_gmod_ezammocrate", "EZ Ammo Crate")
end
