-- Jackarunda 2021
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Jackarunda"
ENT.Category = "JMod - EZ Misc."
ENT.Information = "glhfggwpezpznore"
ENT.PrintName = "EZ OSINC"--"EZ Overwatch Standard Issue Necrotics Containment"
ENT.NoSitAllowed = true
ENT.Spawnable = true
ENT.AdminSpawnable = true
---
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)
ENT.DamageThreshold = 80
ENT.JModEZstorable = true

function ENT:SetupDataTables() 
	self:NetworkVar("Float", 0, "Gas")
end

if SERVER then
	function ENT:SpawnFunction(ply, tr)
		local SpawnPos = tr.HitPos + tr.HitNormal * 40
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(Angle(0, 0, 0))
		ent:SetPos(SpawnPos)
		JMod.SetEZowner(ent, ply)
		if JMod.Config.Machines.SpawnMachinesFull then
			ent.SpawnFull = true
		end
		ent:Spawn()
		ent:Activate()
		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/aboot/weapons/w_nc1.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(SIMPLE_USE)

		---
		local Phys = self:GetPhysicsObject()
		timer.Simple(.01, function()
			if not IsValid(Phys) then return end
			Phys:SetMass(50)
			Phys:Wake()
		end)
		self.MaxGas = 100
		if self.SpawnFull then
			self:SetGas(self.MaxGas)
		end
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > 0.2 then
			if data.Speed > 100 then
				self:EmitSound("Metal_Box.ImpactHard")
				self:EmitSound("Canister.ImpactHard")
			end
		end
	end

	function ENT:OnTakeDamage(dmginfo)
		self.Entity:TakePhysicsDamage(dmginfo)

		if dmginfo:GetDamage() > self.DamageThreshold then
			local Pos = self:GetPos()
			sound.Play("Metal_Box.Break", Pos)

			self:Remove()
		end
	end

	function ENT:Use(activator)
		local SwepToGive = "wep_aboot_jmod_ezosinc"
		if activator:KeyDown(JMod.Config.General.AltFunctionKey) then
			activator:PickupObject(self)
		elseif not activator:HasWeapon(SwepToGive) then
			activator:Give(SwepToGive)
			activator:SelectWeapon(SwepToGive)

			local ToolBox = activator:GetWeapon(SwepToGive)
			ToolBox:SetEZsupplies(JMod.EZ_RESOURCE_TYPES.GAS, self:GetGas())

			self:Remove()
		else
			activator:PickupObject(self)
		end
	end

elseif CLIENT then
	function ENT:Initialize()
		self.MaxGas = 100
	end
	function ENT:Draw()
		self:DrawModel()
		local Opacity = math.random(50, 200)
		local GasFrac = self:GetGas()/self.MaxGas
		JMod.HoloGraphicDisplay(self, Vector(2.5, 5, 10), Angle(0, 0, 90), .05, 300, function()
			draw.SimpleTextOutlined("GAS "..math.Round(GasFrac*100).."%","JMod-Display",0,10,JMod.GoodBadColor(GasFrac, true, Opacity),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,Opacity))
		end)
	end

	language.Add("ent_jack_gmod_eztoolbox", "EZ Toolbox")
end
