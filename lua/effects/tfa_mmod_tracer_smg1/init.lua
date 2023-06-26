EFFECT.InValid = false
EFFECT.ParticleName = "hl2mmod_generic_tracer"

function EFFECT:Init(data)
	self.WeaponEnt = data:GetEntity()
	--print(self.ParticleName)
	if not IsValid(self.WeaponEnt) then return end
	
	if (self.WeaponEnt.Akimbo) then
		self.Attachment = 1 + (game.SinglePlayer() and self.WeaponEnt:GetNW2Int("AnimCycle") or self.WeaponEnt.AnimCycle)
	else
		self.Attachment = data:GetAttachment()
	end
	
	self.Position = self:GetTracerShootPos(data:GetStart(), self.WeaponEnt, self.Attachment)

	if IsValid(self.WeaponEnt.Owner) then
		if self.WeaponEnt.Owner == LocalPlayer() then
			if not self.WeaponEnt.Owner:GetViewEntity() then
				ang = self.WeaponEnt.Owner:EyeAngles()
				ang:Normalize()
				--ang.p = math.max(math.min(ang.p,55),-55)
				self.Forward = ang:Forward()
			else
				self.WeaponEnt = self.WeaponEnt.Owner:GetViewModel()
			end
			--ang.p = math.max(math.min(ang.p,55),-55)
		else
			ang = self.WeaponEnt.Owner:EyeAngles()
			ang:Normalize()
			self.Forward = ang:Forward()
		end
	end

	self.EndPos = data:GetOrigin()
	--util.ParticleTracerEx(self.ParticleName, self.StartPos, self.EndPos, false, self:EntIndex(), self.Attachment)
	local pcf = CreateParticleSystem(self.WeaponEnt, self.ParticleName, PATTACH_POINT, self.Attachment)
	if IsValid(pcf) then
		pcf:SetControlPoint(0,self.Position)
		pcf:SetControlPoint(1,self.EndPos)
		pcf:StartEmission()
	end
	timer.Simple(3.0, function()
		if IsValid(pcf) then
			pcf:StopEmissionAndDestroyImmediately()
		end
	end)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	if self.InValid then return false end
end