function EFFECT:Init(data)
	local Pos = data:GetOrigin()
	local emitter = ParticleEmitter(Pos)

	local particle = emitter:Add("materials/particle/particle_smokegrenade", Pos)
		particle:SetVelocity(Vector(0,0,0))
		particle:SetAirResistance(400)
		particle:SetGravity(Vector(0, 0, 100))
		particle:SetDieTime(0.5)
		particle:SetStartAlpha(165)
		particle:SetEndAlpha(0)
		particle:SetStartSize(8)
		particle:SetEndSize(32)
		particle:SetRoll(math.Rand(-25, 25))
		particle:SetRollDelta(math.Rand(-0.05, 0.05))
		particle:SetColor(165, 165, 165)

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	return false
end