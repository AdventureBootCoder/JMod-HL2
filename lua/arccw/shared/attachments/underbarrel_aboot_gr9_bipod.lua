att.PrintName = "GR9 Bipod"
att.Icon = Material("entities/acwatt_bipod.png")
att.Description = "Stabilize that gun"
att.SortOrder = 10

att.Desc_Pros = {"+ Bipod",}

att.Desc_Cons = {}
att.AutoStats = true
att.Slot = "gr9_bipod"
--att.LHIK = true
--att.LHIK_Animation = true
att.MountPositionOverride = 1
att.Model = "models/weapons/arccw/atts/gr9_bipod.mdl"
att.ModelBodygroups = "010000"
att.Bipod = true
att.Mult_BipodRecoil = 0.2
att.Mult_BipodDispersion = 0.5
att.Mult_SightTime = 1.1
att.Mult_HipDispersion = 1
att.Mult_SpeedMult = 0.95

--[[att.Hook_LHIK_TranslateAnimation = function(wep, anim)
	if anim == "idle" or anim == "in" or anim == "out" then
		if wep:InBipod() then
			return "idle_bipod"
		else
			return "idle"
		end
	end
end--]]

att.Hook_Compatible = function(wep)
	if wep.Bipod_Integral then return false end
end
