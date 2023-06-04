-- Jackarunda 2021
--,"particles/smokey","particle/particle_smokegrenade","sprites/mat_jack_smoke1","sprites/mat_jack_smoke2","sprites/mat_jack_smoke3"}
local Sprites = {"particle/smokestack"}

function EFFECT:Init(data)
	local Pos, Norm, Vel, Scl = data:GetOrigin(), data:GetNormal(), data:GetStart(), data:GetScale()
	local Ent = data:GetEntity()
	local R, G, B = 250, 250, 250
	local Emitter = ParticleEmitter(Pos)
	local Sprite = Sprites[math.random(1, #Sprites)]

	for i = 1, 10 * Scl do
		timer.Simple(i * .02, function()
			local RollParticle = Emitter:Add(Sprite, Ent:GetPos())

			if RollParticle then
				RollParticle:SetVelocity(Vel + Norm * 20)
				RollParticle:SetAirResistance(100)
				RollParticle:SetDieTime(math.Rand(2, 4))
				RollParticle:SetStartAlpha(math.random(120, 150))
				RollParticle:SetEndAlpha(0)
				local Size = math.Rand(10, 20)
				RollParticle:SetStartSize(Size)
				RollParticle:SetEndSize(Size * 2)
				RollParticle:SetRoll(math.Rand(-3, 3))
				RollParticle:SetRollDelta(math.Rand(-2, 2))
				local Vec = VectorRand() * 10 + JMod.Wind * 20
				RollParticle:SetGravity(Vec)
				RollParticle:SetLighting(false)
				local Brightness = math.Rand(.8, 1)
				RollParticle:SetColor(R * Brightness, G * Brightness, B * Brightness)
				RollParticle:SetCollide(true)
				RollParticle:SetBounce(1)
			end
		end)
	end

	timer.Simple(10 * Scl * .2, function()
		Emitter:Finish()
	end)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
-- no u
