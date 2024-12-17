att.PrintName = "APISR Scope"
att.Icon = Material("entities/acwatt_optic_magnus.png")
att.Description = "A precision manufactured scope for the APISR."
att.SortOrder = 4.5

att.Desc_Pros = {"+ Precision sight picture", "+ Zoom",}

att.Desc_Cons = {"- Visible scope glint",}

att.AutoStats = true
att.Slot = "reb_optic"
att.Model = "models/weapons/arccw/atts/apisr_scope.mdl"

att.AdditionalSights = {
	{
		Pos = Vector(0.12, 12, -1.49),
		Ang = Angle(0, 90, 0),
		ViewModelFOV = 30,
		Magnification = 2, -- this is how much your eyes zoom into the scope, not scope magnification
		ScrollFunc = ArcCW.SCROLL_NONE,
		IgnoreExtra = true,
		SwitchToSound = "snds_jack_gmod/ez_weapons/handling/aim1.ogg",
		SwitchFromSound = "snds_jack_gmod/ez_weapons/handling/aim_out.ogg",
	}
}

att.ModelOffset = Vector(-.11, 4, 1.5)
att.OffsetAng = Angle(0, -90, 0)

att.ScopeGlint = false -- lmao
att.Holosight = true
att.HolosightReticle = Material("hud/scopes/mildot.png")
att.HolosightNoFlare = true
att.HolosightSize = 17
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/apisr_scope_hsp.mdl"
att.Colorable = true
att.HolosightMagnification = 3 -- this is the scope magnification
att.HolosightBlackbox = true
att.Mult_SightTime = 1.3
att.Mult_SightsDispersion = 0.5