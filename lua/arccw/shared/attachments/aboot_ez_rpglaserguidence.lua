att.PrintName = "Laser Guidence System"
att.Icon = Material("entities/acwatt_tac_pointer.png")
att.Description = "A powerful precision laser that allows for guiding your missiles."
att.Desc_Pros = {
	"Rocket follows your aim",
	"Increases overall accuracy"
}
att.Desc_Cons = {
	"Travels slower",
	"Visible laser"
}

att.Laser = false
att.LaserStrength = 1
att.LaserBone = "laser"
att.LaserColor = Color(255, 0, 0)

att.SortOrder = 100
att.AutoStats = true
att.Slot = "missile_guidence"
att.Free = true

att.Model = "models/weapons/arccw/atts/laser_pointer.mdl"

att.Hook_PostFireRocket = function(wep, rocket)
	rocket.Guided = true
	att.EZRocket = rocket
end

att.Hook_PreReload = function(wep)
	if IsValid(att.EZRocket) then return true end
end

att.Mult_MuzzleVelocity = 0.3
att.Mult_HipDispersion = 0