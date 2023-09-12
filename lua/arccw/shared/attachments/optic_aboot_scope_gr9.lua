att.PrintName = "GR9-Integrated Scope"
att.Icon = Material("entities/acwatt_optic_magnus.png")
att.Description = "built-in scope for the GR9"
att.SortOrder = 4.5

att.Desc_Pros = {"+ Precision sight picture", "+ Zoom",}

att.Desc_Cons = {"- Visible scope glint",}

att.AutoStats = true
att.Slot = "gr9_optic"
att.Model = "models/weapons/arccw/atts/gr9_scope.mdl"

local colormod = Material("pp/colour")
local TextColor = Color(16, 136, 0)

att.AdditionalSights = {
	{
		Pos = Vector(0, 17, -1.489),
		Ang = Angle(0, 0, -1),
		ViewModelFOV = 30,
		Magnification = 1.5, -- this is how much your eyes zoom into the scope, not scope magnification
		ScrollFunc = ArcCW.SCROLL_NONE,
		IgnoreExtra = true,
		--NVScope = true, -- enables night vision effects for scope
        --NVScopeColor = Color(0, 235, 60),
		--NVFullColor = false,
		SwitchToSound = "snds_jack_gmod/ez_weapons/handling/aim1.wav",
		SwitchFromSound = "snds_jack_gmod/ez_weapons/handling/aim_out.wav",
	}
}

--att.ModelOffset = Vector(-0.1, 0.37, -0.56)
--att.OffsetAng = Angle(0, 0, 0)

att.ScopeGlint = true -- lmao
att.Holosight = true
att.HolosightReticle = Material("holosights/dot_smol.png")
att.HolosightNoFlare = true
att.HolosightSize = 2
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/gr9_scope_hsp.mdl"
att.Colorable = false
att.HolosightColor = TextColor
att.HolosightMagnification = 1.5 -- this is the scope magnification
att.HolosightBlackbox = false
att.Mult_SightTime = 1.2
