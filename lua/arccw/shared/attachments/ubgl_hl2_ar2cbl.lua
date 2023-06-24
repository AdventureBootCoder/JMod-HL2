att.PrintName = "CB Launcher"
att.Icon = Material("entities/acwatt_ubgl_m203.png")
att.Description = "Selectable Combine Ball launcher equipped to the AR."
att.Desc_Pros = {
    "+ Selectable grenade launcher",
    "+ No GL reloads",
}
att.Desc_Cons = {
}

att.AutoStats = true
att.Slot = "hl2_cbl"
att.SortOrder = 100

att.LHIK = false
att.LHIK_Animation = false

att.ModelOffset = Vector(8, 0, 0)
att.OffsetAng = Angle(8, 0, 0)

att.ActivePos = Vector(0, 0, 0)

att.MountPositionOverride = 2
att.UBGL_BaseAnims = true

att.UBGL = true

att.UBGL_PrintName = "CB Launcher"
att.UBGL_Automatic = true
att.UBGL_MuzzleEffect = nil--"muzzleflash_m79"
att.UBGL_ClipSize = 1
att.UBGL_Ammo = "AR2AltFire"
att.UBGL_RPM = 30
att.UBGL_Recoil = 1
att.UBGL_Capacity = 1
--att.ActivateElements = {"reducedmag"}

local function Ammo(wep)
    return wep.Owner:GetAmmoCount("AR2AltFire")
end

local FireCombineBall = function(ply, num)
	if not SERVER then return end
	local cballspawner = ents.Create("point_combine_ball_launcher")
	cballspawner:SetAngles(ply:GetAimVector():Angle())
	cballspawner:SetPos(ply:GetShootPos() + ply:GetAimVector() * 20)
	cballspawner:SetKeyValue("minspeed", 1000)
	cballspawner:SetKeyValue("maxspeed", 1000 )
	cballspawner:SetKeyValue("ballradius", "1")
	cballspawner:SetKeyValue("ballcount", tostring(num))
	cballspawner:SetKeyValue("maxballbounces", "10")
	cballspawner:SetKeyValue("launchconenoise", 0)
	cballspawner:Spawn()
	cballspawner:Activate()
	cballspawner:Fire("LaunchBall")
	cballspawner:Fire("kill","",0)
end

att.UBGL_Fire = function(wep, ubgl)
    if wep:Clip2() <= 0 then
	
        return wep:EmitSound("weapons/arccw/dryfire.wav", 100)
    end
	
    wep.Owner:RemoveAmmo(1, "AR2AltFire")
	
    wep:PlayAnimation("charge")
	wep:EmitSound("Project_MMOD_AR2.Charge")
	timer.Simple(1, function()
		if IsValid(wep) and IsValid(wep.Owner) and wep.Owner:Alive() then
			FireCombineBall(wep.Owner, 1)
			wep:EmitSound("Project_MMOD_AR2.SecondaryFire")
			wep:PlayAnimation("alt_fire")
		end
	end)

    wep:SetClip2(wep:Clip2() - 1)

    wep:DoEffects()
    if wep:Clip2() >= 1 then return end

    if Ammo(wep) <= 0 then return end

    wep:SetNextSecondaryFire(CurTime() + 2)
    local reserve = Ammo(wep)

    reserve = reserve + wep:Clip2()

    local clip = 1

    local load = math.Clamp(clip, 0, reserve)

    wep.Owner:SetAmmo(reserve - load, "AR2AltFire")
	
    wep:SetClip2(load)

end

att.UBGL_Reload = function(wep, ubgl)
    if wep:Clip2() >= 1 then return end

    if Ammo(wep) <= 0 then return end

    wep:SetNextSecondaryFire(CurTime() + 0.2)
	wep:EmitSound("weapons/arccw/dryfire.wav", 100)
	wep:PlayAnimation("reload_ubgl", 0.5)
    local reserve = Ammo(wep)

    reserve = reserve + wep:Clip2()

    local clip = 1

    local load = math.Clamp(clip, 0, reserve)

    wep.Owner:SetAmmo(reserve - load, "AR2AltFire")
	
    wep:SetClip2(load)
end