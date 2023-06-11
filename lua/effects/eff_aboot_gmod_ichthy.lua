function EFFECT:Init(data)
	self.LifeTime = 2
	self.DieTime = CurTime() + self.LifeTime
	self.Ichy = ClientsideModel("models/ichthyosaur.mdl", RENDERGROUP_TRANSLUCENT)
	--self.Ichy:SetNoDraw(true)
	self.Ang = data:GetAngles()
	self.Pos = data:GetOrigin()
	self.Ply = data:GetEntity()
	self.Ichy:SetPos(self.Pos)
	self.Ichy.FirstFrame = true
	self.Ichy.ColorAlpha = Color(255, 255, 255, 50)
	self.Ichy:SetColor(self.Ichy.ColorAlpha)
	self.Ichy:SetRenderMode(RENDERMODE_TRANSCOLOR)
end

function EFFECT:Think()
	local TimeLeft = self.DieTime - CurTime()
	if TimeLeft > 0 then return true end
	self.Ichy.FirstFrame = true
	if IsValid(self.Ichy) then
		self.Ichy:Remove()
	end
	return false
end

function EFFECT:Render()
	self.Ichy:SetRenderOrigin(self.Pos)
	self.Ichy:SetRenderAngles(self.Ang)
	if self.Ichy.FirstFrame then
		self.Ichy.FirstFrame = false
		self.Ichy:ResetSequence("playerattack")
		self.Ichy:ResetSequenceInfo()
	else
		self.Ichy:FrameAdvance()
		self.Ichy.ColorAlpha.a = math.Clamp(self.Ichy.ColorAlpha.a + 200 * FrameTime(), 0, 255)
	end
	self.Ichy:SetColor(self.Ichy.ColorAlpha)
	self.Ichy:DrawModel(RENDERGROUP_TRANSLUCENT)
end