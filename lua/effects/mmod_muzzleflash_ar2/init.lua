local ang

EFFECT.ParticleName = "hl2mmod_muzzleflash_ar2"
EFFECT.ParticleName2 = "hl2mmod_muzzleflash_ar2_punch"

function EFFECT:Init(data)
	self.WeaponEnt = data:GetEntity()
	if not IsValid(self.WeaponEnt) then return end
	self.Attachment = data:GetAttachment()
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	
	local own = self.WeaponEnt.Owner:GetViewModel()
	local att2 = own:LookupAttachment( "punch" )
	self.Position2 = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, att2 )

	if IsValid(self.WeaponEnt.Owner) then
		if self.WeaponEnt.Owner == LocalPlayer() then
			if not self.WeaponEnt:IsFirstPerson() then
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

	self.Forward = self.Forward or data:GetNormal()
	self.Angle = self.Forward:Angle()
	local dlight = DynamicLight(self.WeaponEnt:EntIndex())

	if (dlight) then
		dlight.pos = self.Position + self.Angle:Up() * 3 + self.Angle:Right() * -2
		dlight.r = 255
		dlight.g = 192
		dlight.b = 64
		dlight.brightness = 5
		dlight.Size = math.Rand(32, 64)
		dlight.Decay = math.Rand(32, 64) / 0.05
		dlight.DieTime = CurTime() + 0.05
	end

	local pcf = CreateParticleSystem(self.WeaponEnt, self.ParticleName, PATTACH_POINT_FOLLOW, self.Attachment)
	if IsValid(pcf) then
		pcf:StartEmission()
	end
	
	local pcf2 = CreateParticleSystem(self.WeaponEnt, self.ParticleName2, PATTACH_POINT_FOLLOW, att2)
	if IsValid(pcf2) then
		pcf2:StartEmission()
	end
	
	timer.Simple(3.0, function()
		if IsValid(pcf) then
			pcf:StopEmissionAndDestroyImmediately()
		end
		if IsValid(pcf2) then
			pcf2:StopEmissionAndDestroyImmediately()
		end
	end)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end