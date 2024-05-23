att.PrintName = "CO-SR-Integrated Scope"
att.Icon = Material("entities/acwatt_optic_magnus.png")
att.Description = "built-in scope for CO-SR"
att.SortOrder = 4.5

att.Desc_Pros = {"+ Precision sight picture", "+ Zoom",}

att.Desc_Cons = {"- Visible scope glint",}

att.AutoStats = true
att.Slot = "ez_optic_combine"
att.Model = "models/weapons/arccw/atts/combsr_scope.mdl"

local colormod = Material("pp/colour")
local TextColor = Color(0, 238, 255)
local ColorModTbl = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 5,
	["$pp_colour_brightness"] = .1,
	["$pp_colour_contrast"] = 1.2,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 1.01,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 1.5
}

local visionMat = Material( 'vgui/black' )
local maxDist = 2500

local scanAnim = 1
local scanAnimMove = -1

local mat_viewBeam	= Material( "effects/lamp_beam" )
local mat_viewGlow	= Material( "sprites/light_ignorez" )

local function ShouldDraw(ent)
	if not IsValid(ent) then return false end
	local ply = LocalPlayer()

	if not IsValid(ply) then return false end
	if ent == ply then return false end
	if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() or ent.EZscannerDanger then
		if ent.Health and (ent:Health() <= 0) then return false end
		
		return true
	end
end

local function TextFunc(tex)
	local ply = LocalPlayer()
	local orig = colormod:GetTexture("$fbtexture")
	local ActiveWep = ply:GetActiveWeapon()

	if tex then
		colormod:SetTexture("$fbtexture", tex)
	end

	render.PushRenderTarget(tex)
	
	cam.Start2D()
		local FOV = ((GetConVar("arccw_cheapscopes"):GetBool() and GetConVar("arccw_cheapscopesv2_ratio"):GetFloat()) or .5) * 20
		--draw.DrawText("DET TIME: " .. tostring(math.Round(ActiveWep:GetNW2Float("EZfuseTime", 1), 2)), "JMod-Display-XS", (ScrW() * 0.55) - FOV, (ScrH() * 0.42) - FOV , TextColor, TEXT_ALIGN_LEFT)
		draw.DrawText("DIST: " .. tostring(math.Round((ply:GetEyeTrace().Fraction * 32768) * 0.0254, 1)), "JMod-Display-XS", (ScrW() * 0.55) - FOV, (ScrH() * 0.43) - FOV, TextColor, TEXT_ALIGN_LEFT)
	cam.End2D()

	render.PopRenderTarget(tex)

	if orig then
		colormod:SetTexture("$fbtexture", orig)
	end
end

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
		for _, ent in ipairs(ents.FindInSphere(EyePos(), maxDist)) do
			local AimVec = ply:GetAimVector()
			if ShouldDraw(ent) and ((ent:GetPos() - EyePos()):GetNormalized():Dot(AimVec) > 0) then
				render.ClearStencil()
				--
				render.SetStencilTestMask( 255 )
				render.SetStencilWriteMask( 255 )
				render.SetStencilReferenceValue( 1 )
				--
				render.SetStencilFailOperation( STENCILOPERATION_KEEP )
				render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
				render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
				--
				render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
				--
				local dist = ent:GetPos():Distance( EyePos() )
				local frac = 1 - math.Clamp( ( dist - 300 ) / maxDist, 0, 1 )
				render.SetBlend( math.min( frac, 0.5 ) )
				ent:DrawModel()
				if ( ent:IsNPC() or ent:IsPlayer() ) and IsValid( ent:GetActiveWeapon() ) then
					ent:GetActiveWeapon():DrawModel()
				end
				--
				render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
				render.SetStencilPassOperation( STENCILOPERATION_KEEP )
				--START 
				cam.Start2D()
					surface.SetDrawColor( 196, 167, 167, 250 * frac * scanAnim )
					surface.DrawRect( 0, 0, ScrW(), ScrH() )
				cam.End2D()
				--END
				if ent:IsNPC() or ent:IsPlayer() then
					render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
					local head = ent:LookupBone( 'ValveBiped.Bip01_Spine2' )
					if head then
						local p, a = ent:GetBonePosition( head )
						p = p + a:Forward() * 4 + a:Right() * -3
						local nrm = a:Right() + Vector( 0, 0, 0.15 )
						local view_nrm = ( p - EyePos() ):GetNormalized()
						local view_dot = 1 - math.abs( view_nrm:Dot( nrm ) )								
						local spr_size_w, spr_size_h = 32, 32
						render.SetMaterial( mat_viewGlow )
						render.DrawSprite( p + nrm, spr_size_w, spr_size_h, Color( 255, 255, 255, 255 * frac * scanAnim ) )
					end
				end--]]
			end
		end
		render.SetStencilEnable( false )
		cam.IgnoreZ( false )

		colormod:SetTexture("$fbtexture", render.GetScreenEffectTexture())
	cam.End3D()
	-- STENCIL OPERATION END

	cam.Start2D()
		local FOV = ((GetConVar("arccw_cheapscopes"):GetBool() and GetConVar("arccw_cheapscopesv2_ratio"):GetFloat()) or .5) * 20
		--draw.DrawText("DET TIME: " .. tostring(math.Round(ActiveWep:GetNW2Float("EZfuseTime", 1), 2)), "JMod-Display-XS", (ScrW() * 0.55) - FOV, (ScrH() * 0.42) - FOV , TextColor, TEXT_ALIGN_LEFT)
		draw.DrawText("DIST: " .. tostring(math.Round((ply:GetEyeTrace().Fraction * 32768) * 0.0254, 1)), "JMod-Display-XS", (ScrW() * 0.55) - FOV, (ScrH() * 0.43) - FOV, TextColor, TEXT_ALIGN_LEFT)
	cam.End2D()
	DrawColorModify(ColorModTbl)
	--if ply and not ply.EZflashbanged then
	--	DrawMotionBlur(FrameTime() * 50, .8, .01)
	--end

	render.PopRenderTarget()
end

att.AdditionalSights = {
	{
		Pos = Vector(0, 7, -0.85),
		Ang = Angle(0, 0, 0),
		ViewModelFOV = 30,
		Magnification = 1, -- this is how much your eyes zoom into the scope, not scope magnification
		ScrollFunc = ArcCW.SCROLL_NONE,
		IgnoreExtra = true,
		SwitchToSound = "snds_jack_gmod/ez_weapons/handling/aim1.ogg",
		SwitchFromSound = "snds_jack_gmod/ez_weapons/handling/aim_out.ogg",
		SpecialScopeFunction = XrayScopeFunction--TrackingScopeFunction
	}
}

att.ToggleStats = {
	{
		PrintName = "SCANNING",
		AutoStatName = "On",
		NoAutoStat = false,
		AdditionalSights = {
			{
				Pos = Vector(0, 7, -0.85),
				Ang = Angle(0, 0, 0),
				ViewModelFOV = 30,
				Magnification = 1, -- this is how much your eyes zoom into the scope, not scope magnification
				ScrollFunc = ArcCW.SCROLL_NONE,
				IgnoreExtra = true,
				SwitchToSound = "snds_jack_gmod/ez_weapons/handling/aim1.ogg",
				SwitchFromSound = "snds_jack_gmod/ez_weapons/handling/aim_out.ogg",
				SpecialScopeFunction = XrayScopeFunction
			}
		}
	},
	{
		PrintName = "OFF",
		AutoStatName = "Off",
		AdditionalSights = {
			{
				Pos = Vector(0, 7, -0.85),
				Ang = Angle(0, 0, 0),
				ViewModelFOV = 30,
				Magnification = 1, -- this is how much your eyes zoom into the scope, not scope magnification
				ScrollFunc = ArcCW.SCROLL_NONE,
				IgnoreExtra = true,
				SwitchToSound = "snds_jack_gmod/ez_weapons/handling/aim1.ogg",
				SwitchFromSound = "snds_jack_gmod/ez_weapons/handling/aim_out.ogg",
				SpecialScopeFunction = TextFunc
			}
		}
	}
}--]]

att.ModelOffset = Vector(0, 0, 0.85)

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
att.Mult_SightsDispersion = 0.01
