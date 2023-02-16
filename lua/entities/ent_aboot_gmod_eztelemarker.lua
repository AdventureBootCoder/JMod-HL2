-- Jackarunda 2021
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Jackarunda, AdventureBoots"
ENT.PrintName = "EZ TeleMarker"
ENT.Category = "JMod - EZ HL:2"
ENT.Spawnable = false
ENT.JModPreferredCarryAngles = Angle(0, 0, 90)
ENT.Model = "models/aboot/tpnade_lid.mdl"
ENT.Mass = 5

local Overlay = Material("effects/tp_eyefx/tpeye")

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Activated")
end

local TeleportBlacklist = {"ent_aboot_gmod_eztelemarker", "ent_aboot_gmod_eztelenade"}
function ENT:ShouldTeleport(ent)
	--print("Checking... "..tostring(ent))
	if table.HasValue(TeleportBlacklist, ent:GetClass()) then return false end
	--print("Checking LoS "..tostring(ent))
	if not JMod.ClearLoS(self, ent, true) then return false end
	--print("Checking phys object "..tostring(ent))
	if SERVER then
		local Phys = ent:GetPhysicsObject()
		if not(IsValid(Phys)) or (Phys:GetMass() > 100) then return false end
		if ent:IsConstrained() or not(Phys:IsMotionEnabled()) then return false end
	end
	return true
end

if SERVER then
	function ENT:Initialize()

		self:SetModel("models/aboot/tpnade_lid.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)

		---
		timer.Simple(.01, function()
			if IsValid(self) then
				self:GetPhysicsObject():SetMass(self.Mass)
				self:GetPhysicsObject():Wake()
			end
		end)
		timer.Simple(0.5, function()
			if IsValid(self) then
				local Tr = util.QuickTrace(self:GetPos(), Vector(0, 0, -100), {self, self.ToNade})
				if Tr.Hit then
					self:SetPos(Tr.HitPos + Vector(0, 0, 2))
					self:SetAngles(Tr.HitNormal:Angle() + Angle(90, 0, -90))
					local Weld = constraint.Weld(self, Tr.Entity, 0, Tr.PhysicsBone, 500, false, false)
				end
			end
		end)
		self.LastState = self:GetActivated()
	end

	function ENT:Think()
		local Active = self:GetActivated()
		if Active ~= self.LastState then
			if Active == true then
				self:EmitSound("weapons/physcannon/physcannon_charge.wav", 90, 60)
			end
			self.LastState = Active
		end
	end

elseif CLIENT then
	function ENT:Initialize()
		self.TimeSinceActivated = CurTime()
		self.Scl = 0.1
		self.Rotation = 1
	end

	local Refract, White, AccretionDisk, Glow, TeleGlow = Material("mat_jack_gmod_gravlens"), Color(255, 255, 255, 255), Material("sprites/mat_jack_gmod_blurrycircle"), Material("sprites/mat_jack_basicglow"), Color(225, 255, 93, 150)

	function ENT:Draw()
		local Active, Pos= self:GetActivated(), self:LocalToWorld(self:OBBCenter())
		local Up = self:GetRight()

		self:DrawModel()

		if Active then
			render.SetMaterial(Refract)
			local QuadPos = Pos
			render.DrawQuadEasy(QuadPos, Up, 100 * self.Scl, 100 * self.Scl, White, Rotation)
			render.DrawQuadEasy(QuadPos, -Up, 100 * self.Scl, 100 * self.Scl, White, Rotation)
			render.SetMaterial(Glow)
			render.DrawSprite(Pos, 200 * self.Scl, 200 * self.Scl, TeleGlow)

			self.Rotation = self.Rotation + FrameTime() * 100
			self.Scl = self.Scl + FrameTime()
		end
	end

	function ENT:Think()
		local Active, Time = self:GetActivated(), CurTime()
		local Pos, Ang = self:LocalToWorld(self:OBBCenter()), self:GetAngles()
		if Active then
			local Up, Right, Forward, Mult, Col = Ang:Up(), Ang:Right(), Ang:Forward(), .8, self:GetColor()
			local R, G, B = math.Clamp(Col.r + 20, 0, 255), math.Clamp(Col.g + 20, 0, 255), math.Clamp(Col.b + 20, 0, 255)
			local DLight = DynamicLight(self:EntIndex())

			if DLight then
				DLight.Pos = Pos + Up * 10 + Vector(0, 0, 20)
				DLight.r = R
				DLight.g = G
				DLight.b = B
				DLight.Brightness = math.Rand(.5, 1) * Mult ^ 2
				DLight.Size = math.random(1300, 1500) * Mult ^ 2
				DLight.Decay = 15000
				DLight.DieTime = CurTime() + .3
				DLight.Style = 0
			end
		end
		if Active ~= self.LastState then
			if Active == true then
				self.TimeSinceActivated = CurTime()
			end
			self.LastState = Active
		end
		self:NextThink(Time + 1)
		return true
	end

	hook.Remove("RenderScreenspaceEffects", "ABoot_TeleportEffect")
	hook.Add("RenderScreenspaceEffects", "ABoot_TeleportEffect", function()
		local Ply = LocalPlayer()
		local Teleporting = false
		for _, v in ipairs(ents.FindByClass("ent_aboot_gmod_eztelemarker")) do
			if (v:GetPos():Distance(Ply:GetPos()) < 245) and v:GetActivated() and v:ShouldTeleport(Ply) then
				Teleporting = true
			end
		end
		if Teleporting then
			render.UpdateScreenEffectTexture()
			render.SetMaterial(Overlay)
			render.DrawScreenQuad(true)
		end
	end)

	language.Add("ent_aboot_gmod_eztelemarker", "EZ Teleport Marker")
end
