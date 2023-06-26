att.PrintName = "Grenade Launcher (HE)"
att.Icon = Material("entities/acwatt_ubgl_m203.png")
att.Description = "Selectable Grenade Launcher equipped to the MP5. Double tap +ZOOM to equip/dequip."
att.Desc_Pros = {
    "+ Selectable grenade launcher",
    "+ No GL reloads",
}
att.Desc_Cons = {
}

att.AutoStats = true
att.Slot = "hl2_gl"
att.SortOrder = 100

att.LHIK = false
att.LHIK_Animation = false

att.ModelOffset = Vector(8, 0, 0)
att.OffsetAng = Angle(8, 0, 0)

att.ActivePos = Vector(0, 0, 0)

att.MountPositionOverride = 2
att.UBGL_BaseAnims = true

att.UBGL = true

att.UBGL_PrintName = "M203"
att.UBGL_Automatic = true
att.UBGL_MuzzleEffect = "muzzleflash_m79"
att.UBGL_ClipSize = 1
att.UBGL_Ammo = "smg1_grenade"
att.UBGL_RPM = 60
att.UBGL_Recoil = 1
att.UBGL_Capacity = 1

local function Ammo(wep)
    return wep.Owner:GetAmmoCount("smg1_grenade")
end

att.UBGL_Fire = function(wep, ubgl)
    if wep:Clip2() <= 0 then
	
        return wep:EmitSound("weapons/arccw/dryfire.wav", 100)
    end
	
    wep.Owner:RemoveAmmo(1, "smg1_grenade")
	
    wep:PlayAnimation("gl_fire")
	wep:EmitSound("TFA_MMOD.SMG1.2")
    wep:FireRocket("arccw_hl2_riflegrenade", 2000)
	--wep:FireRocket("smg_grenade", 2000)

    wep:SetClip2(wep:Clip2() - 1)

    wep:DoEffects()
	
    if wep:Clip2() >= 1 then return end

    if Ammo(wep) <= 0 then return end

    wep:SetNextSecondaryFire(CurTime() + 2)
    local reserve = Ammo(wep)

    reserve = reserve + wep:Clip2()

    local clip = 1

    local load = math.Clamp(clip, 0, reserve)

    wep.Owner:SetAmmo(reserve - load, "20mm Grenade")
	
    wep:SetClip2(load)

end

att.UBGL_Reload = function(wep, ubgl)
    if wep:Clip2() >= 1 then return end

    if Ammo(wep) <= 0 then return end

    wep:SetNextSecondaryFire(CurTime() + 0.2)
	wep:EmitSound("weapons/arccw/dryfire.wav", 100)
	wep:PlayAnimation("gl_fire", 0.1)
    local reserve = Ammo(wep)

    reserve = reserve + wep:Clip2()

    local clip = 1

    local load = math.Clamp(clip, 0, reserve)

    wep.Owner:SetAmmo(reserve - load, "20mm Grenade")
	
    wep:SetClip2(load)
end