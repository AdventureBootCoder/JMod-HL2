att.PrintName = "EZ HoloGraphic Sight"
att.Icon = Material("entities/acwatt_optic_aimpoint.png")
att.Description = "wew lad"
att.SortOrder = 0
att.ModelOffset = Vector(-0.05, 1, -0.15)
att.OffsetAng = Angle(0, -90, 0)

att.Desc_Pros = {"+ Precision sight picture",}

att.Desc_Cons = {}
att.AutoStats = true
att.Slot = "smg2_optic"
att.Model = "models/weapons/arccw/atts/smg2_optic.mdl"

att.AdditionalSights = {
	{
		Pos = Vector(0, 15, -1.5),
		Ang = Angle(0, 90, 0),
		Magnification = 1.25,
		ScrollFunc = ArcCW.SCROLL_NONE,
		SwitchToSound = "snds_jack_gmod/ez_weapons/handling/aim1.wav",
		SwitchFromSound = "snds_jack_gmod/ez_weapons/handling/aim_out.wav"
	}
}

att.Holosight = false
att.HolosightReticle = Material("holosights/dot_big.png")
att.HolosightSize = 0.4
att.HolosightBone = "holosight"
att.Mult_SightTime = .95
att.Mult_SightedSpeedMult = 1.2
att.Colorable = true
