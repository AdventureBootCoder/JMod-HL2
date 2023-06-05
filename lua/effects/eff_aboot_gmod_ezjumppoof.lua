-- Jackarunda 2021
--,"particles/smokey","particle/particle_smokegrenade","sprites/mat_jack_smoke1","sprites/mat_jack_smoke2","sprites/mat_jack_smoke3"}
local Sprites = {"particle/smokestack"}

function EFFECT:Init(data)
	local Pos, Norm, Vel, Scl = data:GetOrigin(), data:GetNormal(), data:GetStart(), data:GetScale()
	local Ent = data:GetEntity()
	local R, G, B = 250, 250, 250
	local Emitter = ParticleEmitter(Pos)
	local Sprite = Sprites[math.random(1, #Sprites)]
	local GoodTrace = false

	for i = 1, 20 * Scl do
		timer.Simple(i * .005, function()
			local RollParticle = Emitter:Add(Sprite, Pos)
			if RollParticle then
				RollParticle:SetVelocity(Vel + Norm * math.random(100, 7000))
				RollParticle:SetAirResistance(1000)
				RollParticle:SetDieTime(math.Rand(.1, 1))
				RollParticle:SetStartAlpha(math.random(50, 150))
				RollParticle:SetEndAlpha(0)
				local Size = math.Rand(3, 30)
				RollParticle:SetStartSize(Size)
				RollParticle:SetEndSize(Size * 3)
				RollParticle:SetRoll(math.Rand(-3, 3))
				RollParticle:SetRollDelta(math.Rand(-2, 2))
				local Vec = VectorRand() * 10 + JMod.Wind * 1000
				RollParticle:SetGravity(Vec)
				RollParticle:SetLighting(false)
				local Brightness = math.Rand(.8, 1)
				RollParticle:SetColor(R * Brightness, G * Brightness, B * Brightness)
				RollParticle:SetCollide(false)
				//RollParticle:SetBounce(0)
			end
			if (i == 20 * Scl) then Emitter:Finish() end
		end)
	end

	local Tr = util.QuickTrace(Pos, Vector(0, 0, -400), Ent)
	if (Tr.Hit) then
		local PoofEmitter = ParticleEmitter(Tr.HitPos)
		for i = 1, 60 * Scl do
			timer.Simple(i * .001, function()
				local RollParticle = PoofEmitter:Add(Sprite, Tr.HitPos)
				if RollParticle then
					local Dir = VectorRand()
					Dir.z = 0
					Dir:Normalize()
					RollParticle:SetVelocity(Dir * math.random(1000, 1500))
					RollParticle:SetAirResistance(500)
					RollParticle:SetDieTime(math.Rand(.1, 1))
					RollParticle:SetStartAlpha(math.random(50, 150))
					RollParticle:SetEndAlpha(0)
					local Size = math.Rand(4, 40)
					RollParticle:SetStartSize(Size)
					RollParticle:SetEndSize(Size * 3)
					RollParticle:SetRoll(math.Rand(-3, 3))
					RollParticle:SetRollDelta(math.Rand(-2, 2))
					local Vec = VectorRand() * 10 + JMod.Wind * 1000
					RollParticle:SetGravity(Vec)
					RollParticle:SetLighting(false)
					local Brightness = math.Rand(.8, 1)
					RollParticle:SetColor(R * Brightness, G * Brightness, B * Brightness)
					RollParticle:SetCollide(false)
					RollParticle:SetBounce(0)
				end
			end)
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
-- no u
