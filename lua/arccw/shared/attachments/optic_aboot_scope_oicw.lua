att.PrintName = "OICW-Integrated Scope"
att.Icon = Material("entities/acwatt_optic_magnus.png")
att.Description = "built-in scope for OICW"
att.SortOrder = 4.5

att.Desc_Pros = {"+ Precision sight picture", "+ Zoom",}

att.Desc_Cons = {"- Visible scope glint",}

att.AutoStats = true
att.Slot = "oicw_optic"
att.Model = "models/weapons/arccw/atts/oicw_scope.mdl"

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
		--Contrast = 0.5, -- allows you to adjust the values for contrast and brightness when either NVScope or Thermal is enabled.
        --Brightness = 0.5,
		SpecialScopeFunction = function(tex) 
			--local asight = self:GetActiveSights()
			local ply = LocalPlayer()
			local orig = colormod:GetTexture("$fbtexture")

			if tex then
				colormod:SetTexture("$fbtexture", tex)
			end

			render.PushRenderTarget(tex)

			if ply:GetActiveWeapon() then
				JModHL2.EZ_NightVisionScreenSpaceEffect(nil)
				--if ply and not ply.EZflashbanged then
					--DrawMotionBlur(FrameTime() * 50, .8, .01)
				--end
			end
			cam.Start2D()
				local FOV = ((GetConVar("arccw_cheapscopes"):GetBool() and GetConVar("arccw_cheapscopesv2_ratio"):GetFloat()) or .5) * 20
				draw.DrawText("FUSE TIME: " .. tostring(math.Round(ply:GetActiveWeapon():GetNW2Float("EZfuseTime", 1), 2)), "JMod-Display-XS", (ScrW() * 0.52) - FOV, (ScrH() * 0.53) - FOV , TextColor, TEXT_ALIGN_LEFT)
				draw.DrawText("DIST: " .. tostring(math.Round(ply:GetEyeTrace().Fraction * 32768)), "JMod-Display-XS", (ScrW() * 0.52) - FOV, (ScrH() * 0.55) - FOV, TextColor, TEXT_ALIGN_LEFT)
			cam.End2D()
			
			render.PopRenderTarget(tex)

			if orig then
				colormod:SetTexture("$fbtexture", orig)
			end
		end
	}
}

att.ModelOffset = Vector(0, 0.15, -0.55)
--att.OffsetAng = Angle(0, 0, 0)

att.ScopeGlint = false -- lmao
att.Holosight = true
att.HolosightReticle = Material("holosights/dot_smol.png")
att.HolosightNoFlare = true
att.HolosightSize = 2
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/oicw_scope_hsp.mdl"
att.Colorable = false
att.HolosightColor = TextColor
att.HolosightMagnification = 1.5 -- this is the scope magnification
att.HolosightBlackbox = false
att.Mult_SightTime = 1.4
