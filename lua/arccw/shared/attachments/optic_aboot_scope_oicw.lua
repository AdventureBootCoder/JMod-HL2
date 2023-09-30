att.PrintName = "OICW-Integrated Scope"
att.Icon = Material("entities/acwatt_optic_magnus.png")
att.Description = "built-in scope for OICW"
att.SortOrder = 4.5

att.Desc_Pros = {"+ Precision sight picture", "+ Zoom",}

att.Desc_Cons = {"- Visible scope glint",}

att.AutoStats = true
att.Slot = "oicw_optic"
att.Model = "models/weapons/arccw/atts/oicw_scope.mdl"

att.EZNVscope = true

--[[local thermalmodify = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = .2,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}--]]

local colormod = Material("pp/colour")
local TextColor = Color(148, 6, 6)

local TextFunc = function(tex)
	--local asight = self:GetActiveSights()
	local ply = LocalPlayer()
	local orig = colormod:GetTexture("$fbtexture")
	local ActiveWep = ply:GetActiveWeapon()

	if tex then
		colormod:SetTexture("$fbtexture", tex)
	end

	render.PushRenderTarget(tex)
	
	cam.Start2D()
		local FOV = ((GetConVar("arccw_cheapscopes"):GetBool() and GetConVar("arccw_cheapscopesv2_ratio"):GetFloat()) or .5) * 20
		draw.DrawText("DET TIME: " .. tostring(math.Round(ActiveWep:GetNW2Float("EZfuseTime", 1), 2)), "JMod-Display-XS", (ScrW() * 0.55) - FOV, (ScrH() * 0.42) - FOV , TextColor, TEXT_ALIGN_LEFT)
		draw.DrawText("DIST: " .. tostring(math.Round(ply:GetEyeTrace().Fraction * 32768)), "JMod-Display-XS", (ScrW() * 0.55) - FOV, (ScrH() * 0.43) - FOV, TextColor, TEXT_ALIGN_LEFT)
	cam.End2D()
	
	render.PopRenderTarget(tex)

	if orig then
		colormod:SetTexture("$fbtexture", orig)
	end
end

local ThermalScopeFunction = function(tex)
	--local asight = self:GetActiveSights()
	local ply = LocalPlayer()
	local orig = colormod:GetTexture("$fbtexture")
	local ActiveWep = ply:GetActiveWeapon()

	if tex then
		colormod:SetTexture("$fbtexture", tex)
	end

	render.PushRenderTarget(tex)

	if IsValid(ActiveWep) then
		JModHL2.EZ_NightVisionScreenSpaceEffect(nil)
		--[[DrawColorModify({
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_contrast"] = 1.2,
			["$pp_colour_colour"] = 0,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		})--]]
		--if ply and not ply.EZflashbanged then
			--DrawMotionBlur(FrameTime() * 50, .8, .01)
		--end
	end

	cam.Start2D()
		local FOV = ((GetConVar("arccw_cheapscopes"):GetBool() and GetConVar("arccw_cheapscopesv2_ratio"):GetFloat()) or .5) * 20
		draw.DrawText("DET TIME: " .. tostring(math.Round(ActiveWep:GetNW2Float("EZfuseTime", 1), 2)), "JMod-Display-XS", (ScrW() * 0.55) - FOV, (ScrH() * 0.42) - FOV , TextColor, TEXT_ALIGN_LEFT)
		draw.DrawText("DIST: " .. tostring(math.Round(ply:GetEyeTrace().Fraction * 32768)), "JMod-Display-XS", (ScrW() * 0.55) - FOV, (ScrH() * 0.43) - FOV, TextColor, TEXT_ALIGN_LEFT)
	cam.End2D()
	
	render.PopRenderTarget(tex)

	if orig then
		colormod:SetTexture("$fbtexture", orig)
	end
end

att.AdditionalSights = {
	{
		Pos = Vector(0, 10, -1.489),
		Ang = Angle(0, 0, -1),
		ViewModelFOV = 30,
		Magnification = 1.5, -- this is how much your eyes zoom into the scope, not scope magnification
		ScrollFunc = ArcCW.SCROLL_NONE,
		IgnoreExtra = true,
		SwitchToSound = "snds_jack_gmod/ez_weapons/handling/aim1.wav",
		SwitchFromSound = "snds_jack_gmod/ez_weapons/handling/aim_out.wav",
		SpecialScopeFunction = ThermalScopeFunction
	}
}

att.ToggleStats = {
	{
		PrintName = "Nightvision",
		AutoStatName = "On",
		NoAutoStat = false,
		AdditionalSights = {
			{
				Pos = Vector(0, 10, -1.489),
				Ang = Angle(0, 0, -1),
				ViewModelFOV = 30,
				Magnification = 1.5, -- this is how much your eyes zoom into the scope, not scope magnification
				ScrollFunc = ArcCW.SCROLL_NONE,
				IgnoreExtra = true,
				SwitchToSound = "snds_jack_gmod/ez_weapons/handling/aim1.wav",
				SwitchFromSound = "snds_jack_gmod/ez_weapons/handling/aim_out.wav",
				SpecialScopeFunction = ThermalScopeFunction
			}
		}
	},
	{
		PrintName = "Thermal",
		AutoStatName = "On",
		AdditionalSights = {
			{
				Pos = Vector(0, 10, -1.489),
				Ang = Angle(0, 0, -1),
				ViewModelFOV = 30,
				Magnification = 1.5, -- this is how much your eyes zoom into the scope, not scope magnification
				ScrollFunc = ArcCW.SCROLL_NONE,
				IgnoreExtra = true,
				SwitchToSound = "snds_jack_gmod/ez_weapons/handling/aim1.wav",
				SwitchFromSound = "snds_jack_gmod/ez_weapons/handling/aim_out.wav",
				SpecialScopeFunction = TextFunc,
				Thermal = true,
				ThermalScopeColor = Color(255, 255, 255),
				ThermalHighlightColor = Color(255, 255, 255),
				ThermalFullColor = false,
				ThermalScopeSimple = false,
				ThermalNoCC = false,
				ThermalBHOT = false, -- invert bright/dark
			}
		}
	},
	{
		PrintName = "Off",
		AutoStatName = "Off",
		AdditionalSights = {
			{
				Pos = Vector(0, 10, -1.489),
				Ang = Angle(0, 0, -1),
				ViewModelFOV = 30,
				Magnification = 1.5, -- this is how much your eyes zoom into the scope, not scope magnification
				ScrollFunc = ArcCW.SCROLL_NONE,
				IgnoreExtra = true,
				SwitchToSound = "snds_jack_gmod/ez_weapons/handling/aim1.wav",
				SwitchFromSound = "snds_jack_gmod/ez_weapons/handling/aim_out.wav",
				SpecialScopeFunction = TextFunc
			}
		}
	}
}

att.ModelOffset = Vector(-0.1, 0.37, -0.56)
--att.OffsetAng = Angle(0, 0, 0)

att.ScopeGlint = false -- lmao
att.Holosight = true
att.HolosightReticle = Material("holosights/dot_smol.png")
att.HolosightNoFlare = true
att.HolosightSize = 2
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/oicw_scope_hsp.mdl"
att.HolosightConstDist = false
att.Colorable = false
att.HolosightColor = TextColor
att.HolosightMagnification = 1.5 -- this is the scope magnification
att.HolosightBlackbox = false
att.Mult_SightTime = 1.2
