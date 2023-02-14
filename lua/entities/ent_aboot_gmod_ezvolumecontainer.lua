-- Jackarunda 2021
AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "EZ Experimental Container"
ENT.Author = "Jackarunda, AdventureBoots"
ENT.Category = "JMod - EZ HL:2"
ENT.NoSitAllowed = true
ENT.Spawnable = false
ENT.AdminSpawnable = true
---
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)
ENT.DamageThreshold = 1000
---

---
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Room")
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
		self:SetRoom(0)
		
		self.MaxVolume = 6500000 -- MAGA size
		self.Contents = {}
		self.NextLoad = 0
		self.NextUse = 0

		---
		timer.Simple(.01, function()
			self:CalcWeight()
		end)
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > 0.2 then
			if data.Speed > 100 then
				self.Entity:EmitSound("Metal_Box.ImpactSoft")
				self.Entity:EmitSound("Metal_Box.ImpactHard")
			end
			local Ent = data.HitEntity
			timer.Simple(0, function()
				if IsValid(Ent) and not(Ent:IsPlayer()) and IsValid(data.HitObject) and (Ent:GetClass() ~= "ent_aboot_gmod_ezmanifesto") then
					for k, v in pairs(constraint.GetAllConstrainedEntities(Ent)) do
						if (v:GetClass() == "ent_aboot_gmod_ezmanifesto") then
							self:TryLoadEntity(Ent)
							break
						end
					end
				end
			end)
		end
	end

	function ENT:TryLoadEntity(ent)
		local Time = CurTime()
		if not IsValid(ent) then return false end
		local Index, Phys = ent:EntIndex(), ent:GetPhysicsObject()
		if istable(self.Contents[Index]) then return end
		if not IsValid(Phys) then return false end
		local SpaceNeeded = math.Round(Phys:GetVolume() or Phys:GetMass() ^ 3)
		if SpaceNeeded > (self.MaxVolume - self:GetRoom()) then return end
		self.Contents[Index] = {}
		self.Contents[Index].Ent = ent:GetClass()
		self.Contents[Index].Volume = math.Round(Phys:GetVolume() or Phys:GetMass() ^ 3)
		constraint.RemoveAll(ent)
		ent:SetParent(self)
		ent:SetNoDraw(true)
		ent:SetNotSolid(true)
		Phys:Sleep()
		
		ent:SetPos(self:GetPos())
		ent:SetVelocity(Vector(0, 0, 0))
		
		print(Phys:GetVelocity())

		self:CalcWeight()

		return true
	end

	function ENT:CalcWeight()
		--[[local Frac = self:GetRoom() / self.MaxVolume
		self:GetPhysicsObject():SetMass(4000 + Frac * 300)
		self:GetPhysicsObject():Wake()]]--
		local OurMass = 4000
		self:SetRoom(0)
		for k, v in pairs(self.Contents) do
			if IsValid(Entity(tonumber(k))) then
				OurMass = OurMass + Entity(tonumber(k)):GetPhysicsObject():GetMass()
			else
				if IsValid(Entity(tonumber(k))) then
					SafeRemoveEntity(Entity(tonumber(k)))
				end
				self.Contents[k] = nil
			end
			if v.Volume > 0 then
				self:SetRoom(self:GetRoom() + v.Volume)
			end
		end
		self:GetPhysicsObject():SetMass(OurMass)
		self:GetPhysicsObject():Wake()
	end

	function ENT:OnTakeDamage(dmginfo)
		self.Entity:TakePhysicsDamage(dmginfo)

		if dmginfo:GetDamage() > self.DamageThreshold then
			local Pos = self:GetPos()
			sound.Play("Metal_Box.Break", Pos)
			sound.Play("Metal_Box.Break", Pos)

			if self:GetRoom() > 0 then
				for k, v in pairs(self.Contents) do
					
				end
			end

			self:Remove()
		end
	end

	function ENT:Use(activator)
		local Time = CurTime()
		if self.NextUse > Time then return end
		self.NextUse = Time + 1
		JMod.Hint(activator, "crate")
		local TrimmedTable = {}
		for k, v in pairs(self.Contents) do
			if IsValid(Entity(tonumber(k))) then
				TrimmedTable[k] = {v.Ent, v.Volume}
			else
				self.Contents[k] = nil
			end
		end
		if table.IsEmpty(TrimmedTable) then self:CalcWeight() return end
		net.Start("ABoot_ContainerMenu")
			net.WriteEntity(self)
			net.WriteTable(self.Contents)
		net.Send(activator)

		self:EmitSound("Ammo_Crate.Open")
	end

	net.Receive("ABoot_ContainerMenu", function() 
		local Container = net.ReadEntity()
		local StoredEnt = net.ReadString()

		if not IsValid(Container) then return end
		timer.Simple(0.5, function()
			if not IsValid(Entity(tonumber(StoredEnt))) then return end
			local UnpackedEnt = Entity(tonumber(StoredEnt))
			local Maxs, Mins = UnpackedEnt:OBBMaxs(), UnpackedEnt:OBBMins()
			local SideLengths = Maxs - Mins
			UnpackedEnt:SetPos(Container:GetPos() + Container:GetRight() * (-210 - SideLengths.x) + Container:GetUp() * (SideLengths.z / 2))
			UnpackedEnt:SetAngles(Container:GetAngles())
			UnpackedEnt:SetNoDraw(false)
			UnpackedEnt:SetNotSolid(false)
			UnpackedEnt:SetParent(nil)
			local Phys = UnpackedEnt:GetPhysicsObject()

			if IsValid(Phys) then
				Phys:Wake()
				Phys:SetVelocity(Container:GetPhysicsObject():GetVelocity())
			end
			if IsValid(Container) then
				Container:CalcWeight()
			end
		end)

		Container.Contents[tonumber(StoredEnt)] = nil
		Container.NextUse = CurTime() + 1
		--PrintTable(Container.Contents)
	end)

	function ENT:Think()
	end

	--pfahahaha
	function ENT:OnRemove()
		for k, v in pairs(self.Contents) do 
			if IsValid(Entity(tonumber(k))) then 
				SafeRemoveEntity(Entity(tonumber(k)))
			end 
		end
	end

elseif CLIENT then
	local TxtCol = Color(5, 5, 5, 220)

	function ENT:Initialize()
		self.MaxVolume = 6500000
	end

	function ENT:Draw()
		local Ang, Pos = self:GetAngles(), self:GetPos()
		local Closeness = LocalPlayer():GetFOV() * EyePos():Distance(Pos)
		local DetailDraw = Closeness < 45000 -- cutoff point is 500 units when the fov is 90 degrees
		self:DrawModel()

		if DetailDraw then
			local Up, Right, Forward, Room = Ang:Up(), Ang:Right(), Ang:Forward(), tostring(self:GetRoom())
			Ang:RotateAroundAxis(Ang:Right(), 90)
			Ang:RotateAroundAxis(Ang:Up(), -90)
			cam.Start3D2D(Pos + Up * 40 - Forward * 65 + Right * 10, Ang, .4)
			draw.SimpleText("ADVENTURE INDUSTRIES", "JMod-Stencil", 0, 0, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(Room .. "/" .. tostring(self.MaxVolume), "JMod-Stencil", 0, 85, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			cam.End3D2D()
			---
			Ang:RotateAroundAxis(Ang:Right(), 180)
			cam.Start3D2D(Pos + Up * 40 + Forward * 65 - Right * 10.1, Ang, .4)
			draw.SimpleText("ADVENTURE INDUSTRIES", "JMod-Stencil", 0, 0, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(Room .. "/" .. tostring(self.MaxVolume), "JMod-Stencil", 0, 85, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			cam.End3D2D()
		end
	end

	local blurMat = Material("pp/blurscreen")
	local Dynamic = 0
	local function BlurBackground(panel)
		if not (IsValid(panel) and panel:IsVisible()) then return end
		local layers, density, alpha = 1, 1, 255
		local x, y = panel:LocalToScreen(0, 0)
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.SetMaterial(blurMat)
		local FrameRate, Num, Dark = 1 / FrameTime(), 5, 150
	
		for i = 1, Num do
			blurMat:SetFloat("$blur", (i / layers) * density * Dynamic)
			blurMat:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
		end
	
		surface.SetDrawColor(0, 0, 0, Dark * Dynamic)
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
		Dynamic = math.Clamp(Dynamic + (1 / FrameRate) * 7, 0, 1)
	end

	net.Receive("ABoot_ContainerMenu", function() 
		local Container = net.ReadEntity()
		local Contents = net.ReadTable()

		JMod.SelectionMenuIcons = JMod.SelectionMenuIcons or {}
		-- first, populate icons
		for index, info in pairs(Contents) do
			if not JMod.SelectionMenuIcons[info.Ent] then
				
			end
		end
		
		local MotherFrame = vgui.Create("DFrame")
		MotherFrame.positiveClosed = false
		MotherFrame.storted = false
		MotherFrame:SetSize(500, 700)
		MotherFrame:SetVisible(true)
		MotherFrame:SetDraggable(true)
		MotherFrame:ShowCloseButton(true)
		MotherFrame:SetTitle("EZ Shipping Container")

		function MotherFrame:Paint()
			if not self.storted then
				self.storted = true
				surface.PlaySound("snds_jack_gmod/ez_gui/menu_open.wav")
			end
	
			BlurBackground(self)
		end

		MotherFrame:MakePopup()
		MotherFrame:Center()

		function MotherFrame:OnKeyCodePressed(key)
			if key == KEY_Q or key == KEY_ESCAPE or key == KEY_E then
				self:Close()
			end
		end

		function MotherFrame:OnClose()
			if not self.positiveClosed then
				surface.PlaySound("snds_jack_gmod/ez_gui/menu_close.wav")
			end
		end

		local W, H = MotherFrame:GetWide(), MotherFrame:GetTall()

		local TabPanel = vgui.Create("DPanel", MotherFrame)
		local TabPanelX, TabPanelW = 10, W - 20

		TabPanel:SetPos(TabPanelX, 30)
		TabPanel:SetSize(TabPanelW, H - 40)

		function TabPanel:Paint(w, h)
			surface.SetDrawColor(0, 0, 0, 50)
			surface.DrawRect(0, 0, w, h)
		end

		local W, H = TabPanel:GetWide(), TabPanel:GetTall()

		local Scroll = vgui.Create("DScrollPanel", TabPanel)
		Scroll:SetSize(W - 10, H - 100)
		Scroll:SetPos(10, 10)
		---
		local Y, AlphabetizedItemNames = 0, table.GetKeys(Contents)
		table.sort(AlphabetizedItemNames, function(a, b) return a < b end)

		for index, info in pairs(Contents) do
			local Butt = Scroll:Add("DButton")
			Butt:SetSize(W - 40, 42)
			Butt:SetPos(0, Y)
			Butt:SetText("")
			local itemName = info.Ent

			Butt.enabled = true
			Butt:SetMouseInputEnabled(true)
			Butt.hovered = false

			function Butt:Paint(w, h)
				local Hovr = self:IsHovered()

				if Hovr then
					if not self.hovered then
						self.hovered = true

						if self.enabled then
							surface.PlaySound("snds_jack_gmod/ez_gui/hover_ready.wav")
						end
					end
				else
					self.hovered = false
				end

				local Brite = (Hovr and 50) or 30

				if self.enabled then
					surface.SetDrawColor(Brite, Brite, Brite, 60)
				else
					surface.SetDrawColor(0, 0, 0, (Hovr and 50) or 20)
				end

				surface.DrawRect(0, 0, w, h)
				local ItemIcon = JMod.SelectionMenuIcons[itemName]

				if ItemIcon then
					surface.SetMaterial(ItemIcon)
					surface.SetDrawColor(255, 255, 255, (self.enabled and 255) or 40)
					surface.DrawTexturedRect(5, 5, 32, 32)
				end

				draw.SimpleText((language.GetPhrase(itemName) or itemName).." - Volume: "..tostring(info.Volume), "DermaDefault", (ItemIcon and 47) or 5, 15, Color(255, 255, 255, (self.enabled and 255) or 40), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			end

			function Butt:DoClick()
				if self.enabled then
					timer.Simple(.5, function()
						if IsValid(Container) then
							net.Start("ABoot_ContainerMenu")
								net.WriteEntity(Container)
								net.WriteString(index)
							net.SendToServer()
						end
					end)

					surface.PlaySound("snds_jack_gmod/ez_gui/click_big.wav")
					MotherFrame.positiveClosed = true
					MotherFrame:Close()
				else
					surface.PlaySound("snds_jack_gmod/ez_gui/miss.wav")
				end
			end

			Y = Y + 47
		end
	end)

	language.Add("ent_jack_gmod_ezcontainer", "EZ Shipping Container")
end
