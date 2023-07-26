AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Base Rifle Grenade"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false

ENT.Ticks = 0
ENT.CollisionGroup = COLLISION_GROUP_PROJECTILE


-- Intentionally not ENT.Damage since ArcCW base overwrites it with weapon damage (for some reason)
ENT.GrenadeDamage = 120
ENT.GrenadeRadius = 300
ENT.DragCoefficient = 1
ENT.DetonateOnImpact = true

ENT.Model = "models/weapons/shell.mdl"
ENT.ExplosionEffect = true
ENT.Scorch = "Scorch"
ENT.SmokeTrail = true

local path = "weapons/"
local path1 = "ambient/levels/streetwar/"
ENT.ExplosionSounds = {path .. "explode3.wav", path .. "explode4.wav", path .. "explode5.wav"}
ENT.DebrisSounds = {path1 .. "building_rubble1.wav", path1 .. "building_rubble2.wav", path1 .. "building_rubble3.wav", path1 .. "building_rubble4.wav", path1 .. "building_rubble5.wav"}


if SERVER then
    function ENT:Initialize()
        local pb_vert = 1
        local pb_hor = 1
        self:SetModel(self.Model)
        self:PhysicsInitBox(Vector(-pb_vert, -pb_hor, -pb_hor), Vector(pb_vert, pb_hor, pb_hor))
        local phys = self:GetPhysicsObject()

        if phys:IsValid() then
            phys:Wake()
            phys:SetDragCoefficient(self.DragCoefficient)
            phys:SetBuoyancyRatio(0.1)
        end

        self.SpawnTime = CurTime()
		self.EZfuseTime = 1
		--[[timer.Simple(0.1, function()
			jprint(self.EZlauncher)
			if IsValid(self) and IsValid(self.EZlauncher) and self.EZlauncher.EZfuseTime then
				self.EZfuseTime = self.EZlauncher.EZfuseTime
			end
		end)]]--
    end

    function ENT:Think()
        if SERVER and CurTime() - self.SpawnTime >= self.EZfuseTime then
            self:Detonate()
        end
    end
else
    function ENT:Think()
        if self.SmokeTrail then
            if self.Ticks % 5 == 0 then
                local emitter = ParticleEmitter(self:GetPos())
                if not self:IsValid() or self:WaterLevel() > 2 then return end
                if not IsValid(emitter) then return end
                local smoke = emitter:Add("particle/particle_smokegrenade", self:GetPos())
                smoke:SetVelocity(VectorRand() * 25)
                smoke:SetGravity(Vector(math.Rand(-5, 5), math.Rand(-5, 5), math.Rand(-20, -25)))
                smoke:SetDieTime(math.Rand(1.5, 2.0))
                smoke:SetStartAlpha(255)
                smoke:SetEndAlpha(0)
                smoke:SetStartSize(0)
                smoke:SetEndSize(100)
                smoke:SetRoll(math.Rand(-180, 180))
                smoke:SetRollDelta(math.Rand(-0.2, 0.2))
                smoke:SetColor(50, 50, 50)
                smoke:SetAirResistance(5)
                smoke:SetPos(self:GetPos())
                smoke:SetLighting(false)
                emitter:Finish()
            end
            self.Ticks = self.Ticks + 1
        end
    end
end

-- overwrite to do special explosion things
function ENT:DoDetonation()
    local attacker = IsValid(self:GetOwner()) and self:GetOwner() or self
    util.BlastDamage(self, attacker, self:GetPos(), self.GrenadeRadius, self.GrenadeDamage or self.Damage or 0)
end

function ENT:DoImpact(ent)
    local attacker = IsValid(self:GetOwner()) and self:GetOwner() or self
    local dmg = DamageInfo()
    dmg:SetAttacker(attacker)
    dmg:SetInflictor(self)
    dmg:SetDamage(100)
    dmg:SetDamageType(DMG_CRUSH)
    dmg:SetDamageForce(self.GrenadeDir * 5000)
    dmg:SetDamagePosition(self:GetPos())
    ent:TakeDamageInfo(dmg)
end

function ENT:Detonate()
    if not self:IsValid() or self.BOOM then return end
    self.BOOM = true

    if self.ExplosionEffect then
        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())

        if self:WaterLevel() >= 1 then
            util.Effect("WaterSurfaceExplosion", effectdata)
            self:EmitSound("WaterExplosionEffect.Sound")
        else
            -- util.Effect("Explosion", effectdata)

            -- explosion_HE_m79_fas2
            -- explosion_he_grenade_fas2
            -- explosion_HE_claymore_fas2
            -- explosion_grenade_fas2

            self:EmitSound("BaseExplosionEffect.Sound")
            ParticleEffect("hl2mmod_explosion_grenade", self:GetPos(), Angle(-90, 0, 0))
        end

        util.ScreenShake(self:GetPos(), 25, 4, 0.75, self.GrenadeRadius * 4)

        if self.GrenadePos == nil then
            self.GrenadePos = self:GetPos()
        end
        if self.GrenadeDir == nil then
            self.GrenadeDir = self:GetVelocity():GetNormalized()
        end

        local trace = util.TraceLine({
            start = self.GrenadePos,
            endpos = self.GrenadePos + self.GrenadeDir * 4,
            mask = MASK_SOLID_BRUSHONLY
        })
        if trace.Hit then
            self:EmitSound(self.DebrisSounds[math.random(1,#self.DebrisSounds)], 90, 100, 1, CHAN_AUTO)
        end
    end

    self:DoDetonation()

    if self.Scorch then
        util.Decal(self.Scorch, self.GrenadePos, self.GrenadePos + self.GrenadeDir * 4, self)
    end

    self:Remove()
end

function ENT:PhysicsCollide(colData, collider)
    self.GrenadeDir = colData.OurOldVelocity:GetNormalized()
    self.GrenadePos = colData.HitPos

    self:DoImpact(colData.HitEntity)

    if self.DetonateOnImpact then
        self:Detonate()
    else
        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())
        effectdata:SetMagnitude(2)
        effectdata:SetScale(1)
        effectdata:SetRadius(2)
        effectdata:SetNormal(self.GrenadeDir)
        util.Effect("Sparks", effectdata)
        self:EmitSound("weapons/rpg/shotdown.wav", 100, 150)
        self:Remove()
    end
end


function ENT:Draw()
    self:DrawModel()
end