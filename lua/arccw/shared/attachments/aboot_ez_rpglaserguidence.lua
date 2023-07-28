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

att.Laser = true
att.LaserStrength = 1
att.LaserBone = "laser"
att.LaserColor = Color(255, 0, 0)

att.SortOrder = 100
att.AutoStats = true
att.Slot = "missile_guidence"
att.Free = true

att.Model = "models/weapons/arccw/atts/laser_pointer.mdl"

--att.Mult_MuzzleVelocity = 0.3
--att.Mult_HipDispersion = 0

att.ToggleStats = {
	{
	    PrintName = "Laser Guidence System",
	    AutoStatName = "On",
	    NoAutoStat = false,
	    Laser = true,
	    LaserColor = Color(255, 0, 0),
	    Mult_HipDispersion = 0,
	},
	{
	    PrintName = "Off",
	    Laser = false,
	    Mult_HipDispersion = 1,
	}
}

att.Hook_PostFireRocket = function(wep, rocket)
	--if att.Laser then
		rocket.Guided = true
		wep.EZrocket = rocket
	--end
end

att.Hook_PreReload = function(wep)
	if IsValid(wep.EZrocket) then

		return true
	end
end