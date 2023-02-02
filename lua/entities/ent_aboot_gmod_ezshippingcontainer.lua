-- Jackarunda 2021
AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "EZ Shipping Container"
ENT.Author = "Jackarunda, AdventureBoots"
ENT.Category = "JMod - EZ HL:2"
ENT.NoSitAllowed = true
ENT.Spawnable = true
ENT.AdminSpawnable = true
---
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)
ENT.DamageThreshold = 120
---

---
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Resource")
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
		--local effectdata=EffectData()
		--effectdata:SetEntity(ent)
		--util.Effect("propspawn",effectdata)

		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/props_wasteland/cargo_container01.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(SIMPLE_USE)
		self:SetSkin(math.random(0, 2))
		---
		self:SetResource(0)
		
		self.MaxResource = 100 * 900 -- standard size
		self.EZconsumes = {}

		for k, v in pairs(JMod.EZ_RESOURCE_TYPES) do
			table.insert(self.EZconsumes, v)
		end

		self.Contents = {}

		for k, v in pairs(JMod.EZ_RESOURCE_TYPES) do
			self.Contents[v] = {}
		end

		self.NextLoad = 0

		---
		timer.Simple(.01, function()
			self:CalcWeight()
		end)
	end

	function ENT:ApplySupplyType(typ)
		self.EZsupplies = typ
		if typ == "generic" then
			self.ChildEntity = ""
		else
			self.ChildEntity = JMod.EZ_RESOURCE_ENTITIES[typ]
		end
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > 0.2 then
			if data.Speed > 100 then
				self.Entity:EmitSound("Metal_Box.ImpactSoft")
				self.Entity:EmitSound("Metal_Box.ImpactHard")
			end
		end
	end

	function ENT:CalcWeight()
		local Frac = self:GetResource() / self.MaxResource
		self:GetPhysicsObject():SetMass(100 + Frac * 300)
		self:GetPhysicsObject():Wake()
	end

	function ENT:OnTakeDamage(dmginfo)
		self.Entity:TakePhysicsDamage(dmginfo)

		if dmginfo:GetDamage() > self.DamageThreshold then
			local Pos = self:GetPos()
			sound.Play("Metal_Box.Break", Pos)
			sound.Play("Metal_Box.Break", Pos)

			if self.ChildEntity ~= "" and self:GetResource() > 0 then
				for i = 1, math.floor(self:GetResource() / 100) do
					local Box = ents.Create(self.ChildEntity)
					Box:SetPos(Pos + self:GetUp() * 20)
					Box:SetAngles(self:GetAngles())
					Box:Spawn()
					Box:Activate()
				end
			end

			self:Remove()
		end
	end

	function ENT:Use(activator)
		JMod.Hint(activator, "crate")
		local Resource = self:GetResource()
		if Resource <= 0 then return end
		--[[local Box, Given = ents.Create(self.ChildEntity), math.min(Resource, 100)
		Box:SetPos(self:GetPos() + self:GetUp() * 5)
		Box:SetAngles(self:GetAngles())
		Box:Spawn()
		Box:Activate()
		Box:SetResource(Given)
		Box.NextLoad = CurTime() + 2
		self:SetResource(Resource - Given)]]--
		self:EmitSound("Ammo_Crate.Close")
		self:CalcWeight()
	end

	function ENT:Think()
	end

	--pfahahaha
	function ENT:OnRemove()
	end

	--aw fuck you
	function ENT:TryLoadResource(typ, amt)
		local Time = CurTime()
		if self.NextLoad > Time then self.NextLoad = math.min(self.NextLoad, Time + .5) return 0 end
		if amt < 1 then return 0 end

		-- Consider the loaded type
		local Resource = self:GetResource()
		local Missing = self.MaxResource - Resource
		if Missing <= 0 then return 0 end
		local Accepted = math.min(Missing, amt)

		self.Contents[typ].Amt = Accepted
		if not self.Contents[typ].Ent then
			self.Contents[typ].Ent = JMod.EZ_RESOURCE_ENTITIES[typ]
		end

		self:SetResource(Resource + Accepted)
		self:CalcWeight()
		self.NextLoad = Time + .5

		return Accepted
	end

elseif CLIENT then
	local TxtCol = Color(5, 5, 5, 220)

	function ENT:Initialize()
		self.MaxResource = 100 * 200
	end

	function ENT:Draw()
		local Ang, Pos = self:GetAngles(), self:GetPos()
		local Closeness = LocalPlayer():GetFOV() * EyePos():Distance(Pos)
		local DetailDraw = Closeness < 45000 -- cutoff point is 500 units when the fov is 90 degrees
		self:DrawModel()

		if DetailDraw then
			local Up, Right, Forward, Resource = Ang:Up(), Ang:Right(), Ang:Forward(), tostring(self:GetResource())
			Ang:RotateAroundAxis(Ang:Right(), 90)
			Ang:RotateAroundAxis(Ang:Up(), -90)
			cam.Start3D2D(Pos + Up * 40 - Forward * 65 + Right * 10, Ang, .4)
			draw.SimpleText("ABOOT MANUFACTURING", "JMod-Stencil", 0, 0, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(Resource .. "/" .. tostring(self.MaxResource), "JMod-Stencil", 0, 85, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			cam.End3D2D()
			---
			Ang:RotateAroundAxis(Ang:Right(), 180)
			cam.Start3D2D(Pos + Up * 40 + Forward * 65 - Right * 10, Ang, .4)
			draw.SimpleText("ABOOT MANUFACTURING", "JMod-Stencil", 0, 0, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(Resource .. "/" .. tostring(self.MaxResource), "JMod-Stencil", 0, 85, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			cam.End3D2D()
		end
	end

	language.Add("ent_jack_gmod_ezcontainer", "EZ Shipping Container")
end
