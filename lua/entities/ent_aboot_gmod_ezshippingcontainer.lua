﻿-- AdventureBoots 2023
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
ENT.DamageThreshold = 1500
---
ENT.IsJackyEZcrate = true
---
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Resource")
end

function ENT:GetEZsupplies(typ)
	local Supplies = self.Contents
	if typ then
		if Supplies[typ] and Supplies[typ] then
			return Supplies[typ]
		else
			return nil
		end
	else
		return Supplies
	end
end

function ENT:SetEZsupplies(typ, amt, setter)
	self.Contents[typ] = amt
	self:SetResource(math.Clamp(amt, 0, self.MaxResource))
	if SERVER then
		net.Start("ABoot_ContainerMenu")
			net.WriteBool(false)
			net.WriteEntity(self)
			net.WriteString(typ)
			net.WriteInt(amt, 32)
		net.Broadcast()
		self:CalcWeight()
	end
end
---

if SERVER then
	function ENT:SpawnFunction(ply, tr)
		local SpawnPos = tr.HitPos + tr.HitNormal * 40
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
		self:SetModel("models/props_wasteland/cargo_container01.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(SIMPLE_USE)
		self:SetSkin(math.random(0, 2))
		---
		self:SetResource(0)
		
		self.MaxResource = 100 * 400 -- MAGA size
		self.EZconsumes = {}

		for k, v in pairs(JMod.EZ_RESOURCE_TYPES) do
			table.insert(self.EZconsumes, v)
		end

		self.Contents = {}

		for k, v in pairs(JMod.EZ_RESOURCE_TYPES) do
			self.Contents[v] = 0
		end

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
				self:EmitSound("Metal_Box.ImpactSoft")
				self:EmitSound("Metal_Box.ImpactHard")
			end
		end
	end

	function ENT:CalcWeight()
		local Frac = self:GetResource() / self.MaxResource
		self:GetPhysicsObject():SetMass(4000 + Frac * 300)
		self:GetPhysicsObject():Wake()
		self:SetResource(0)
		for k, v in pairs(self.Contents) do
			if v > 0 then
				self:SetResource(self:GetResource() + v)
			end
		end
	end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)

		if dmginfo:GetDamage() > self.DamageThreshold then
			local Pos = self:GetPos()
			sound.Play("Metal_Box.Break", Pos)
			sound.Play("Metal_Box.Break", Pos)

			if self:GetResource() > 0 then
				for k, v in pairs(self.Contents) do
					for i = 1, math.floor(v / 100) do
						local Box = ents.Create(JMod.EZ_RESOURCE_ENTITIES[k])
						Box:SetPos(Pos + self:GetUp() * 20)
						Box:SetAngles(self:GetAngles())
						Box:Spawn()
						Box:Activate()
					end
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
			if v > 0 then
				TrimmedTable[k] = v
			end
		end
		if table.IsEmpty(TrimmedTable) then return end
		net.Start("ABoot_ContainerMenu")
			net.WriteBool(true)
			net.WriteEntity(self)
			net.WriteTable(TrimmedTable)
		net.Send(activator)

		self:EmitSound("Ammo_Crate.Open")
	end

	function ENT:DropContents(ply, resTyp, amt)
		local AmountLeft = self.Contents[resTyp]
		if AmountLeft <= 0 then return end
		local Needed = math.min(amt, AmountLeft)
		for i = 1, math.ceil(Needed / 100) do
			timer.Simple(0.3 * i, function()
				if not IsValid(self) then return end
				local Box, Given = ents.Create(JMod.EZ_RESOURCE_ENTITIES[resTyp]), math.min(Needed, 100)
				Box:SetPos(self:GetPos() + self:GetRight() * -210 + self:GetUp() * 20)
				Box:SetAngles(self:GetAngles())
				Box:Spawn()
				Box:Activate()
				Box:SetEZsupplies(Box.EZsupplies, Given, self)
				Box.NextLoad = CurTime() + 2
				Needed = Needed - Given
				self:CalcWeight()
			end)
		end
		self.Contents[resTyp] = self.Contents[resTyp] - Needed
		self.NextUse = CurTime() + 1
	end

	net.Receive("ABoot_ContainerMenu", function(len, ply) 
		local Container = net.ReadEntity()
		local ResourceType = net.ReadString()
		local Amount = net.ReadUInt(17)

		if IsValid(Container) and Container.DropContents then 
			Container:DropContents(ply, ResourceType, Amount)
		end
	end)

	function ENT:Think()
	end

	--pfahahaha
	function ENT:OnRemove()
	end

	function ENT:TryLoadResource(typ, amt, overrideTimer)
		local Time = CurTime()
		if (self.NextLoad > Time) and not(overrideTimer) then self.NextLoad = math.min(self.NextLoad, Time + .1) return 0 end
		if amt < 1 then return 0 end

		-- Consider the loaded type
		local Resource = self:GetResource()
		local Missing = self.MaxResource - Resource
		if Missing <= 0 then return 0 end
		local Accepted = math.min(Missing, amt)

		self.Contents[typ] = self.Contents[typ] + Accepted

		self:CalcWeight()
		self.NextLoad = Time + .5

		net.Start("ABoot_ContainerMenu")
			net.WriteBool(false)
			net.WriteEntity(self)
			net.WriteString(typ)
			net.WriteInt(self.Contents[typ], 32)
		net.Broadcast()

		return Accepted
	end

	function ENT:PostEntityPaste(ply, ent, createdEntities)
		self:CalcWeight()
		local Time = CurTime()
		self.NextLoad = Time
		self.NextUse = Time
	end

elseif CLIENT then
	--include("jmod/cl_gui.lua")
	local TxtCol = Color(5, 5, 5, 220)

	function ENT:Initialize()
		self.MaxResource = 100 * 400
		self.Contents = {}

		for k, v in pairs(JMod.EZ_RESOURCE_TYPES) do
			self.Contents[v] = 0
		end
	end

	function ENT:Draw()
		local Ang, Pos = self:GetAngles(), self:GetPos()
		local Closeness = LocalPlayer():GetFOV() * EyePos():Distance(Pos)
		local DetailDraw = Closeness < 75000 -- cutoff point is 500 units when the fov is 90 degrees
		self:DrawModel()

		if DetailDraw then
			local Up, Right, Forward, Resource = Ang:Up(), Ang:Right(), Ang:Forward(), tostring(self:GetResource())
			Ang:RotateAroundAxis(Ang:Right(), 90)
			Ang:RotateAroundAxis(Ang:Up(), -90)
			cam.Start3D2D(Pos + Up * 40 - Forward * 65 + Right * 0, Ang, .4)
			draw.SimpleText("Adv Battle Ops & Operatives Tech", "JMod-Stencil", 0, 0, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(Resource .. "/" .. tostring(self.MaxResource), "JMod-Stencil", 0, 85, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			cam.End3D2D()
			---
			Ang:RotateAroundAxis(Ang:Right(), 180)
			cam.Start3D2D(Pos + Up * 40 + Forward * 65 - Right * 0, Ang, .4)
			draw.SimpleText("Adv Battle Ops & Operatives Tech", "JMod-Stencil", 0, 0, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(Resource .. "/" .. tostring(self.MaxResource), "JMod-Stencil", 0, 85, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			cam.End3D2D()
		end
	end

	net.Receive("ABoot_ContainerMenu", function() 
		local Menu = net.ReadBool()
		local Container = net.ReadEntity()

		if not(Menu) then
			local Typ = net.ReadString()
			local Amount = net.ReadInt(32)
			Container:SetEZsupplies(Typ, Amount)
			
			return 
		end
		local Contents = net.ReadTable()
		Container.Contents = Contents

		JMod.SelectionMenuIcons = JMod.SelectionMenuIcons or {}
		-- first, populate icons
		for name, info in pairs(Contents) do
			if not JMod.SelectionMenuIcons[name] then
				local IsResource = false

				for k, v in pairs(JMod.EZ_RESOURCE_ENTITIES) do
					if v == JMod.EZ_RESOURCE_ENTITIES[name] then
						IsResource = true
						JMod.SelectionMenuIcons[name] = JMod.EZ_RESOURCE_TYPE_ICONS_SMOL[k]
					end
				end
			end
		end
		
		local MotherFrame = vgui.Create("DFrame")
		MotherFrame.positiveClosed = false
		MotherFrame.storted = false
		MotherFrame:SetSize(500, 700)
		MotherFrame:SetVisible(true)
		MotherFrame:SetDraggable(true)
		MotherFrame:ShowCloseButton(true)
		MotherFrame:SetTitle(Container.PrintName or "EZ Resource Container")

		function MotherFrame:Paint()
			if not self.storted then
				self.storted = true
				surface.PlaySound("snds_jack_gmod/ez_gui/menu_open.ogg")
			end
	
			EZBlurBackground(self)
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
				surface.PlaySound("snds_jack_gmod/ez_gui/menu_close.ogg")
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

		local RequestedAmount = 100
		local AmountSlider = vgui.Create( "DNumSlider", TabPanel )
		AmountSlider:SetPos(10, 575) -- Set the position
		AmountSlider:SetSize(250, 100) -- Set the size
		AmountSlider:SetText("Requested Amount") -- Set the text above the slider
		AmountSlider:SetMin(0) -- Set the minimum number you can slide to
		AmountSlider:SetMax(Container.MaxResource) -- Set the maximum number you can slide to
		AmountSlider:SetDecimals(0) -- Decimal places - zero for whole number
		AmountSlider:SetValue(RequestedAmount)

		function AmountSlider:OnValueChanged(num)
			RequestedAmount = AmountSlider:GetValue()
		end

		local Scroll = vgui.Create("DScrollPanel", TabPanel)
		Scroll:SetSize(W - 10, H - 100)
		Scroll:SetPos(10, 10)
		---
		local Y, AlphabetizedItemNames = 0, table.GetKeys(Contents)
		table.sort(AlphabetizedItemNames, function(a, b) return a < b end)

		for k, itemName in pairs(AlphabetizedItemNames) do
			local Butt = Scroll:Add("DButton")
			Butt:SetSize(W - 40, 42)
			Butt:SetPos(0, Y)
			Butt:SetText("")
			local itemInfo = Contents[itemName]

			Butt.enabled = true
			Butt:SetMouseInputEnabled(true)
			Butt.hovered = false

			function Butt:Paint(w, h)
				local Hovr = self:IsHovered()

				if Hovr then
					if not self.hovered then
						self.hovered = true

						if self.enabled then
							surface.PlaySound("snds_jack_gmod/ez_gui/hover_ready.ogg")
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

				draw.SimpleText(string.upper(itemName).." x"..tostring(itemInfo), "DermaDefault", (ItemIcon and 47) or 5, 15, Color(255, 255, 255, (self.enabled and 255) or 40), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			end

			function Butt:DoClick()
				if self.enabled then
					timer.Simple(.5, function()
						if IsValid(Container) then
							net.Start("ABoot_ContainerMenu")
								net.WriteEntity(Container)
								net.WriteString(itemName)
								net.WriteUInt(RequestedAmount, 17)
							net.SendToServer()
							local AmountLeft = Container.Contents[itemName]
							if AmountLeft >= 0 then
								local Needed = math.min(RequestedAmount, AmountLeft)
								Container.Contents[itemName] = Container.Contents[itemName] - Needed
							end
						end
					end)

					surface.PlaySound("snds_jack_gmod/ez_gui/click_big.ogg")
					MotherFrame.positiveClosed = true
					MotherFrame:Close()
				else
					surface.PlaySound("snds_jack_gmod/ez_gui/miss.ogg")
				end
			end

			Y = Y + 47
		end
	end)

	language.Add("ent_jack_gmod_ezcontainer", "EZ Shipping Container")
end
