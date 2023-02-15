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
	end

elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	hook.Remove("RenderScreenspaceEffects", "ABoot_TeleportEffect")
	hook.Add("RenderScreenspaceEffects", "ABoot_TeleportEffect", function()
		local Ply = LocalPlayer()
		local Teleporting = false
		for _, v in ipairs(ents.FindByClass("ent_aboot_gmod_eztelemarker")) do
			if v:GetActivated() and Ply:GetPos():Distance(v:GetPos()) < 245 then
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
