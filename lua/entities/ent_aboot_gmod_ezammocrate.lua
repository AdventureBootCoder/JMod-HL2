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
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)
ENT.DamageThreshold = 240
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
if SERVER then
	function ENT:SpawnFunction(ply, tr)
		local SpawnPos = tr.HitPos + tr.HitNormal * 18
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(Angle(0, 0, 0))
		ent:SetPos(SpawnPos)
		JMod.SetOwner(ent, ply)
		ent:Spawn()
		ent:Activate()
		--local effectdata=EffectData()
		--effectdata:SetEntity(ent)
		--util.Effect("propspawn",effectdata)

		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/items/ammocrate_smg1.mdl")
		self:SetSubMaterial(0, "models/aboot/ezammocrate_clean_sheet.vmt")
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

		--[[for k, v in pairs(JMod.EZ_RESOURCE_TYPES) do
			table.insert(self.EZconsumes, v)
		end]]--

		self.NextLoad = 0

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
		self:GetPhysicsObject():SetMass(100 + Frac * 300)
		self:GetPhysicsObject():Wake()
	end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)

		if dmginfo:GetDamage() > self.DamageThreshold then
			local Pos = self:GetPos()
			sound.Play("Wood_Crate.Break", Pos)
			sound.Play("Wood_Box.Break", Pos)

			if self:GetResourceType() ~= "generic" and self:GetResource() > 0 then
				for i = 1, math.floor(self:GetResource() / 100) do
					local Box = ents.Create(JMod.EZ_RESOURCE_ENTITIES[self:GetResourceType()])
					Box:SetPos(Pos + self:GetUp() * 20)
					Box:SetAngles(self:GetAngles())
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
			if IsValid(self) and self.LastOpenTime < CurTime() then
				self:SetSequence("Close")
				self:ResetSequenceInfo()
				self:EmitSound("AmmoCrate.Close")
			else
				self:Close()
			end
		end)
	end

	function ENT:GiveAmmo(ply)
			local Wep = ply:GetActiveWeapon()

			if Wep then
				local PrimType, SecType, PrimSize, SecSize, WepClass = Wep:GetPrimaryAmmoType(), Wep:GetSecondaryAmmoType(), Wep:GetMaxClip1(), Wep:GetMaxClip2(), Wep:GetClass()
				if table.HasValue(JMod.Config.WeaponAmmoBlacklist, WepClass) then return end
				local IsMunitionBox = ent.EZsupplies == "munitions"
				--[[ PRIMARY --]]
				local PrimName = game.GetAmmoName(PrimType)

				if PrimName and JMod.AmmoTable[PrimName] then
					-- use JMOD ammo rules
					local AmmoInfo, CurrentAmmo = JMod.AmmoTable[PrimName], ply:GetAmmoCount(PrimName)

					if ent.EZsupplies == AmmoInfo.resourcetype then
						local ResourceLeftInBox = ent:GetResource() * 3
						local SpaceLeftInPlayerInv, MaxAmtToGive, AmtLeftInBox = AmmoInfo.carrylimit - CurrentAmmo, math.ceil(100 / AmmoInfo.sizemult), math.ceil(ResourceLeftInBox * 6 / AmmoInfo.sizemult)
						local AmtToGive = math.min(SpaceLeftInPlayerInv, MaxAmtToGive, AmtLeftInBox)

						if AmtToGive > 0 then
							local ResourceToTake = math.ceil(AmtToGive / 18 * AmmoInfo.sizemult)
							ply:GiveAmmo(AmtToGive, PrimType)
							ent:UseEffect(ent:GetPos(), ent)
							ent:SetResource(ent:GetResource() - ResourceToTake)

							if ent:GetResource() <= 0 then
								if not noRemove then
									ent:Remove()
								end

								return
							end
						end
					end
				else
					-- use DEFAULT ammo rules
					if table.HasValue(JMod.Config.WeaponsThatUseMunitions, WepClass) then
						if not IsMunitionBox then return end
					else
						if IsMunitionBox then return end
					end

					if PrimType and (PrimType ~= -1) then
						if PrimSize == -1 then
							PrimSize = -PrimSize
						end

						local PrimMax = game.GetAmmoData(PrimType).maxcarry

						if ply:GetAmmoCount(PrimType) <= PrimMax then
							ply:GiveAmmo(PrimMax - ply:GetAmmoCount(PrimType), PrimType)
							ent:UseEffect(ent:GetPos(), ent)
							ent:SetResource(ent:GetResource() - 100 * .1)

							if ent:GetResource() <= 0 then
								if not noRemove then
									ent:Remove()
								end

								return
							end
						end
					end
				end

				--[[ SECONDARY --]]
				local SecName = game.GetAmmoName(SecType)

				if PrimName and JMod.AmmoTable[PrimName] then
				else -- use JMOD ammo rules -- TODO, no jmod weapons use secondary ammo currently
					-- use DEFAULT ammo rules
					if table.HasValue(JMod.Config.WeaponsThatUseMunitions, WepClass) then
						if not IsMunitionBox then return end
					else
						if IsMunitionBox then return end
					end

					if SecType and (SecType ~= -1) then
						if SecSize == -1 then
							SecSize = -SecSize
						end

						if ply:GetAmmoCount(SecType) <= SecSize * 5 * JMod.Config.AmmoCarryLimitMult then
							ply:GiveAmmo(math.ceil(SecSize / 2), SecType)
							ent:UseEffect(ent:GetPos(), ent)
							ent:SetResource(ent:GetResource() - 100 * .1)

							if ent:GetResource() <= 0 then
								if not noRemove then
									ent:Remove()
								end

								return
							end
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
		local Alt = activator:KeyDown(JMod.Config.AltFunctionKey)

		if self.LastOpenTime < Time then
			self:Open(true)
		end

		if Alt then
			local Wep = activator:GetActiveWeapon()
			local PriAmmo, SecAmmo = Wep:GetPrimaryAmmoType(), Wep:GetSecondaryAmmoType()
			--local ClipsLeft = 
			JMod.GiveAmmo(activator, self, true)
		else
			local Box, Given = ents.Create(JMod.EZ_RESOURCE_ENTITIES[self:GetResourceType()]), math.min(Resource, 100)
			Box:SetPos(self:GetPos() + self:GetUp() * 5)
			Box:SetAngles(self:GetAngles())
			Box:Spawn()
			Box:Activate()
			Box:SetResource(Given)
			activator:PickupObject(Box)
			Box.NextLoad = CurTime() + 2
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

	--aw fuck you
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
elseif CLIENT then
	--53, 51, 31, 220 Box sample
	local TxtCol = Color(14, 12, 1, 240)

	function ENT:Draw()
		local Ang, Pos = self:GetAngles(), self:GetPos()
		local Closeness = LocalPlayer():GetFOV() * EyePos():Distance(Pos)
		local DetailDraw = Closeness < 45000 -- cutoff point is 500 units when the fov is 90 degrees
		local ResourceType = self:GetResourceType()
		self:DrawModel()

		if DetailDraw then
			local Up, Right, Forward, Resource = Ang:Up(), Ang:Right(), Ang:Forward(), tostring(self:GetResource())
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
