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

--[[local TrackingScopeFunction = function(tex)
	--local asight = self:GetActiveSights()
	local ply = LocalPlayer()
	local orig = colormod:GetTexture("$fbtexture")
	local ActiveWep = ply:GetActiveWeapon()

	if tex then
		colormod:SetTexture("$fbtexture", tex)
	end

	render.PushRenderTarget(tex)

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

			local tpos = target:LocalToWorld(target:OBBCenter())

			ActiveWep.PixVis[target] = ActiveWep.PixVis[target] or util.GetPixelVisibleHandle()

			local vis = util.PixelVisible(tpos, target:GetModelRadius(), ActiveWep.PixVis[target])

			if vis == 0 then
				--continue
			end

			local time = 0--ActiveWep:GetTimeToTarget(tpos)

			ActiveWep.LeadVelocity[target] = LerpVector(FrameTime(), ActiveWep.LeadVelocity[target] or Vector(), target:GetVelocity())

			local lead = (tpos + (target:GetVelocity() * time)):ToScreen()
			local tpos2 = tpos:ToScreen()

			local w = 10
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
end--]]

local visionMat = Material( 'vgui/black' )
local maxDist = 3000

local scanAnim = 1
local scanAnimMove = -1

local mat_viewBeam	= Material( "effects/lamp_beam" )
local mat_viewGlow	= Material( "sprites/light_ignorez" )

local function XrayScopeFunction(tex)
	local ply = LocalPlayer()
	local orig = colormod:GetTexture("$fbtexture")
	local ActiveWep = ply:GetActiveWeapon()

	render.PushRenderTarget(tex)

	-- STENCIL OPERATION START
	cam.Start3D()
		if tex then
			colormod:SetTexture("$fbtexture", tex)
		else
			colormod:SetTexture("$fbtexture", render.GetScreenEffectTexture())
		end

		cam.IgnoreZ( true )
		render.SetStencilEnable( true )
			render.SetStencilWriteMask( 1 )
			render.SetStencilTestMask( 1 )
			render.SetStencilReferenceValue( 1 )
			render.SetStencilFailOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )
			for _, ent in pairs(ents.GetAll()) do
				render.ClearStencil()
				if not IsValid( ent ) || ent == LocalPlayer() || ( not ent:IsNPC() && not ent:IsPlayer() && ent:GetClass() ~= 'prop_physics' && ent.Base ~= 'base_nextbot' ) then continue end
				if ent.Health && ent:Health() <= 0 then continue end
				local dist = ent:GetPos():Distance( EyePos() )
				local frac = 1 - math.Clamp( ( dist - 300 ) / maxDist, 0, 1 )
				render.SetBlend( math.min( frac, 0.99 ) )
				render.SetStencilCompareFunction( STENCIL_ALWAYS )
				render.SetStencilPassOperation( STENCIL_REPLACE )
				ent:DrawModel()
				if ( ent:IsNPC() || ent:IsPlayer() ) && IsValid( ent:GetActiveWeapon() ) then
					ent:GetActiveWeapon():DrawModel()
				end
				render.SetStencilCompareFunction( STENCIL_EQUAL )
				render.SetStencilPassOperation( STENCIL_KEEP )
				--START 
				cam.Start2D()
					if ent:IsNPC() || ent.Base == 'base_nextbot' || ent:IsPlayer() then
						surface.SetDrawColor( 195, 195, 195, 250 * frac * scanAnim )
					end
					surface.DrawRect( 0, 0, ScrW(), ScrH() )
				cam.End2D()
				--END
				if ent:IsNPC() || ent:IsPlayer() then
					render.SetStencilCompareFunction( STENCIL_ALWAYS )
					local head = ent:LookupBone( 'ValveBiped.Bip01_Head1' )
					if head then
						local p, a = ent:GetBonePosition( head )
						p = p + Vector( 0, 0, 5 )
						local nrm = a:Right() + Vector( 0, 0, 0.15 )
						local view_nrm = ( p - EyePos() ):GetNormalized()
						local view_dot = 1 - math.abs( view_nrm:Dot( nrm ) )								
						local spr_size_w, spr_size_h = 256, 128
						render.SetMaterial( mat_viewGlow )
					end
				end
			end
		render.SetStencilEnable( false )
		cam.IgnoreZ( false )

		colormod:SetTexture("$fbtexture", render.GetScreenEffectTexture())
	cam.End3D()
	-- STENCIL OPERATION END

	render.PopRenderTarget()
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
		SpecialScopeFunction = XrayScopeFunction--TrackingScopeFunction
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
att.HolosightSize = 8
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/combsr_scope_hsp.mdl"
att.HolosightConstDist = false
att.Colorable = false
--att.HolosightColor = Color(0, 255, 255)--TextColor
att.HolosightMagnification = 3 -- this is the scope magnification
att.HolosightBlackbox = false
att.Mult_SightTime = 1.2
