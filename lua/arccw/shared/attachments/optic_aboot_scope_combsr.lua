att.PrintName = "CO-SR-Integrated Scope"
att.Icon = Material("entities/acwatt_optic_magnus.png")
att.Description = "built-in scope for CO-SR"
att.SortOrder = 4.5

att.Desc_Pros = {"+ Precision sight picture", "+ Zoom",}

att.Desc_Cons = {"- Visible scope glint",}

att.AutoStats = true
att.Slot = "optic_combsr"
att.Model = "models/weapons/arccw/atts/combsr_scope.mdl"

--att.EZNVscope = true

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
local TextColor = Color(0, 238, 255)

local TrackingScopeFunction = function(tex)
	--local asight = self:GetActiveSights()
	local ply = LocalPlayer()
	local orig = colormod:GetTexture("$fbtexture")
	local ActiveWep = ply:GetActiveWeapon()

	if tex then
		colormod:SetTexture("$fbtexture", tex)
	end

	render.PushRenderTarget(tex)

	--[[if IsValid(ActiveWep) then
		JModHL2.EZ_NightVisionScreenSpaceEffect(nil)
		DrawColorModify({
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_contrast"] = 1.2,
			["$pp_colour_colour"] = 0,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		})
		--if ply and not ply.EZflashbanged then
			--DrawMotionBlur(FrameTime() * 50, .8, .01)
		--end
	end--]]
	ActiveWep.PixVis = ActiveWep.PixVis or {}
	ActiveWep.LeadVelocity = ActiveWep.LeadVelocity or {}

	cam.Start2D()
		for _, target in pairs(ents.GetAll()) do
			if not IsValid(target) or not (target:IsNPC() or target:IsPlayer()) then
				continue
			end

			if target == ply or target:Health() <= 0 then
				continue
			end

			local tpos = target:WorldSpaceCenter()

			ActiveWep.PixVis[target] = ActiveWep.PixVis[target] or util.GetPixelVisibleHandle()

			local vis = util.PixelVisible(tpos, target:GetModelRadius(), ActiveWep.PixVis[target])

			if vis == 0 then
				continue
			end

			local time = 1--ActiveWep:GetTimeToTarget(tpos)

			ActiveWep.LeadVelocity[target] = LerpVector(FrameTime(), ActiveWep.LeadVelocity[target] or Vector(), target:GetVelocity())

			local lead = (tpos + (target:GetVelocity() * time)):ToScreen()
			local tpos2 = tpos:ToScreen()

			local w = 5
			local color = Vector(0, 0, 1)

			surface.SetDrawColor(color.x * 255, color.y * 255, color.z * 255)

			surface.DrawLine(tpos2.x, tpos2.y, lead.x, lead.y)

			surface.DrawLine(lead.x - w, lead.y, lead.x, lead.y - w)
			surface.DrawLine(lead.x, lead.y - w, lead.x + w, lead.y)
			surface.DrawLine(lead.x - w, lead.y, lead.x, lead.y + w)
			surface.DrawLine(lead.x, lead.y + w, lead.x + w, lead.y)
		end
	cam.End2D()
	
	render.PopRenderTarget(tex)

	if orig then
		colormod:SetTexture("$fbtexture", orig)
	end
end

att.AdditionalSights = {
	{
		Pos = Vector(0, 7, -0.85),
		Ang = Angle(0, 180, 0),
		ViewModelFOV = 30,
		Magnification = 1, -- this is how much your eyes zoom into the scope, not scope magnification
		ScrollFunc = ArcCW.SCROLL_NONE,
		IgnoreExtra = true,
		SwitchToSound = "snds_jack_gmod/ez_weapons/handling/aim1.wav",
		SwitchFromSound = "snds_jack_gmod/ez_weapons/handling/aim_out.wav",
		SpecialScopeFunction = TrackingScopeFunction
	}
}

--[[att.ToggleStats = {
	{
		PrintName = "Tracking",
		AutoStatName = "On",
		NoAutoStat = false,
		AdditionalSights = {
			{
				Pos = Vector(0, 0, -1.489),
				Ang = Angle(0, 0, -1),
				ViewModelFOV = 30,
				Magnification = 2, -- this is how much your eyes zoom into the scope, not scope magnification
				ScrollFunc = ArcCW.SCROLL_NONE,
				IgnoreExtra = true,
				SwitchToSound = "snds_jack_gmod/ez_weapons/handling/aim1.wav",
				SwitchFromSound = "snds_jack_gmod/ez_weapons/handling/aim_out.wav",
				SpecialScopeFunction = TrackingScopeFunction
			}
		}
	},
	{
		PrintName = "Off",
		AutoStatName = "Off",
		AdditionalSights = {
			{
				Pos = Vector(0, 0, -1.489),
				Ang = Angle(0, 0, -1),
				ViewModelFOV = 30,
				Magnification = 2, -- this is how much your eyes zoom into the scope, not scope magnification
				ScrollFunc = ArcCW.SCROLL_NONE,
				IgnoreExtra = true,
				SwitchToSound = "snds_jack_gmod/ez_weapons/handling/aim1.wav",
				SwitchFromSound = "snds_jack_gmod/ez_weapons/handling/aim_out.wav"
			}
		}
	}
}--]]

att.ModelOffset = Vector(0, 0, 0.85)
att.OffsetAng = Angle(180, 0, 0)

att.ScopeGlint = false -- lmao
att.Holosight = true
att.HolosightReticle = Material("holosights/sniper_scope_ret.png")
att.HolosightNoFlare = true
att.HolosightSize = 10
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/combsr_scope_hsp.mdl"
att.HolosightConstDist = false
att.Colorable = false
--att.HolosightColor = Color(0, 255, 255)--TextColor
att.HolosightMagnification = 3 -- this is the scope magnification
att.HolosightBlackbox = false
att.Mult_SightTime = 1.2
