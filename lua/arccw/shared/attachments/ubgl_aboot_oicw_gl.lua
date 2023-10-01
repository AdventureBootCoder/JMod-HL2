att.PrintName = "Grenade Launcher (HE)"
att.Icon = Material("entities/acwatt_ubgl_m203.png")
att.Description = "Selectable Grenade Launcher equipped to the MP5. Double tap +ZOOM to equip/dequip."
att.Desc_Pros = {
    "+ Selectable grenade launcher",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "ez_oicw_gl"

att.SortOrder = 100

att.LHIK = false
att.LHIK_Animation = false

att.ModelOffset = Vector(0, 0, 0)

att.MountPositionOverride = 0

att.UBGL = true

att.UBGL_PrintName = "XM-29"
att.UBGL_Automatic = true
att.UBGL_MuzzleEffect = "muzzleflash_m79"
att.UBGL_ClipSize = 4
att.UBGL_Ammo = "25mm Grenade"
att.UBGL_RPM = 85
att.UBGL_Recoil = 2
att.UBGL_Capacity = 4

local function Ammo(wep)
    return wep.Owner:GetAmmoCount("25mm Grenade")
end

att.UBGL_Fire = function(wep, ubgl)
    if wep:Clip2() <= 0 then
        return wep:EmitSound("weapons/arccw/dryfire.wav", 100)
    end

    wep:PlayAnimation("gl_fire")
	wep:EmitSound("Weapon_OICW.Fire_Alt")
    wep:FireRocket("arccw_aboot_riflegrenade", 10000)

    wep:SetClip2(wep:Clip2() - 1)


    wep:DoEffects()
end

att.Hook_PostFireRocket = function(wep, rocket)
	if IsValid(wep) then
		rocket.EZfuseTime = wep:GetNW2Float("EZfuseTime", 1) 
		rocket.EZfragment = true
	end
end

att.UBGL_Reload = function(wep, ubgl)
    if wep:Clip2() >= 4 then return end

    if Ammo(wep) <= 0 then return end

    wep:SetNextSecondaryFire(CurTime() + 1.55)
	wep:PlayAnimation("altreload", 0.7)
    local reserve = Ammo(wep)

    reserve = reserve + wep:Clip2()

    local clip = 4

    local load = math.Clamp(clip, 0, reserve)

    wep.Owner:SetAmmo(reserve - load, "25mm Grenade")

    wep:SetClip2(load)
end