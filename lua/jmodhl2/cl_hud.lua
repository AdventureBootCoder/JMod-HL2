local tag = "aboot_jumpmod"
local tag_counter = tag .. "_counter"

local shouldshow = CreateClientConVar(tag .. "_hud", "1")
local SCR_W, SCR_H = ScrW(), ScrH()
local x_offset = CreateClientConVar(tag .. "_hud_x_frac", 0.305, true)
local y_offset = CreateClientConVar(tag .. "_hud_y_frac", 0.975, true)
local x_info_offset = CreateClientConVar("aboot_machine_info_hud_x_frac", 0.02, true)
local y_info_offset = CreateClientConVar("aboot_machine_info_hud_y_frac", 0.8, true)
local BAR_WIDTH, BAR_HEIGHT, MARGIN = 0.0075, 0.065, 0.002
local BLACK, BAR_COL_FULL, BAR_COL_EMPTY = Color(0, 0, 0, 80), Color(255, 236, 12, 240), Color(255, 0, 0, 105)
local JET_COL_FULL, JET_COL_EMPTY = Color(0, 139, 173, 240), Color(200, 0, 0, 105)
local charge = 0
local MACHINE_MESSAGE = Color(206, 206, 206, 129)

hook.Add("HUDPaint", "JMOD_HL2_HUDPAINT", function()
	
	local Ply = LocalPlayer()
	if Ply:Alive() and Ply.EZarmor and Ply.EZarmor.effects then
		if Ply.EZarmor.effects.HEVsuit then
			local TrackedEnt = Ply:GetNW2Entity("EZmachineTracking", nil)
			if IsValid(TrackedEnt) then
				local InfoX = x_info_offset:GetFloat()
				local InfoY = y_info_offset:GetFloat()
				draw.DrawText("Machine Synced: "..TrackedEnt.PrintName, "HudDefault", SCR_W * InfoX, SCR_H * InfoY, MACHINE_MESSAGE, TEXT_ALIGN_LEFT)
			end
		end
	end

	if not shouldshow:GetBool() then return end
	--
	local x = x_offset:GetFloat() * SCR_W
	local y = y_offset:GetFloat() * SCR_H
	--
	local PlyCharge = Ply:GetNW2Float(tag_counter, 0)
	--
	if Ply:Alive() and Ply.EZarmor and Ply.EZarmor.effects then
		if Ply.EZarmor.effects.jumpmod then
			charge = Lerp(FrameTime() * 4.5, charge, PlyCharge + 0.01)
			if PlyCharge - charge < 0 then
				charge = PlyCharge
			end
			local bar1 = math.min(charge, 1)
			local bar2 = math.min(charge - bar1, 1)
			local bar3 = math.max(math.min(charge - bar1 * 2, 1), 0)

			draw.RoundedBox(10, x - 8, y - (SCR_H * 0.075), SCR_W * 0.09, SCR_H * 0.080, BLACK)
			--outlines
			surface.SetDrawColor(BAR_COL_EMPTY)
			surface.DrawOutlinedRect(x, y - (SCR_H * BAR_HEIGHT), SCR_W * BAR_WIDTH, SCR_H *  BAR_HEIGHT)
			surface.DrawOutlinedRect(x + SCR_W * (BAR_WIDTH + MARGIN), y - (SCR_H * BAR_HEIGHT), SCR_W * BAR_WIDTH, SCR_H *  BAR_HEIGHT)
			surface.DrawOutlinedRect(x + SCR_W * (BAR_WIDTH + MARGIN) * 2, y - (SCR_H * BAR_HEIGHT), SCR_W * BAR_WIDTH, SCR_H *  BAR_HEIGHT)
			-- Bar 3
			surface.SetDrawColor(bar3 < 1 and BAR_COL_EMPTY or BAR_COL_FULL)
			surface.DrawRect(x, y - (SCR_H * (bar3 * BAR_HEIGHT)), SCR_W * BAR_WIDTH, SCR_H * (bar3 * BAR_HEIGHT))
			-- Bar 2
			surface.SetDrawColor(bar2 < 1 and BAR_COL_EMPTY or BAR_COL_FULL)
			surface.DrawRect(x + (SCR_W * (BAR_WIDTH + MARGIN)), y - (SCR_H * (bar2 * BAR_HEIGHT)), SCR_W * BAR_WIDTH, SCR_H * (bar2 * BAR_HEIGHT))
			-- Bar 1
			surface.SetDrawColor(bar1 < 1 and BAR_COL_EMPTY or BAR_COL_FULL)
			surface.DrawRect(x + (SCR_W * (BAR_WIDTH + MARGIN) * 2), y - (SCR_H * (bar1 * BAR_HEIGHT)), SCR_W * BAR_WIDTH, SCR_H * (bar1 * BAR_HEIGHT))

			-- Extra stats
			local Tr = util.QuickTrace(Ply:GetPos(), Vector(0, 0, -9e9), Ply)
			local Dist = math.Round(Ply:GetPos():Distance(Tr.HitPos) / 10) * 10
			draw.DrawText("ALT: "..tostring(math.min(Dist, 9999)), "HudDefault", x + (SCR_W * (BAR_WIDTH + MARGIN) * 3.2), y - (SCR_H * BAR_HEIGHT), BAR_COL_FULL, TEXT_ALIGN_LEFT)
			local Ang = math.Round(Ply:EyeAngles().p)
			draw.DrawText("ANG: "..tostring(-Ang), "HudDefault", x + (SCR_W * (BAR_WIDTH + MARGIN) * 3.2), y - (SCR_H * BAR_HEIGHT) + 25, BAR_COL_FULL, TEXT_ALIGN_LEFT)
			if Ply:GetNW2Bool("EZjumpmod_canuse", false) and charge >= 1 then
				draw.DrawText("READY", "HudDefault", x + (SCR_W * (BAR_WIDTH + MARGIN) * 3.2), y - (SCR_H * BAR_HEIGHT) + 50, BAR_COL_FULL, TEXT_ALIGN_LEFT)
			else
				draw.DrawText("CHARGE", "HudDefault", x + (SCR_W * (BAR_WIDTH + MARGIN) * 3.2), y - (SCR_H * BAR_HEIGHT) + 50, BAR_COL_EMPTY, TEXT_ALIGN_LEFT)
			end
			-- There's a lot of work done here:
			--[[local Aim = Ply:GetAimVector():Angle() 
			for i = -90, 90 do
				local distance = math.abs(i - Aim.p)
				local alphaValue = math.max((distance*-100 + 200), 0)
				local DrawPosY = ((SCR_H / 2) + i * 18) + (SCR_H / 60) * -Aim.p
				local AHcolor = Color(255, 255, 255, alphaValue)
				surface.SetDrawColor(AHcolor)
				surface.DrawRect((SCR_W / 2) + 40, DrawPosY, 40, 2)
				surface.DrawRect((SCR_W / 2) - 80, DrawPosY, 40, 2)
				draw.DrawText(tostring(math.Round(-i)), "HudDefault", (SCR_W / 2) + 100, DrawPosY - 10, AHcolor, TEXT_ALIGN_LEFT)
			end]]--
			--draw.DrawText(tostring(math.Round(-Aim.p)), "HudDefault", (SCR_W / 2) + 100, (SCR_H / 2) - 10, AHcolor, TEXT_ALIGN_LEFT)
		elseif Ply.EZarmor.effects.jetmod then
			charge = Lerp(FrameTime() * 4.5, charge, PlyCharge + 0.01)
			if PlyCharge - charge < 0 then
				charge = PlyCharge
			end
			-- Container
			draw.RoundedBox(10, x - 8, y - (SCR_H * 0.075), SCR_W * 0.09, SCR_H * 0.080, BLACK)
			surface.SetDrawColor(charge < 1 and JET_COL_EMPTY or JET_COL_FULL)
			surface.DrawOutlinedRect(x, y - (SCR_H * BAR_HEIGHT), SCR_W * BAR_WIDTH * 3, SCR_H *  BAR_HEIGHT)
			-- Bars
			for i = 0, math.Round(charge * 2) do
				surface.SetDrawColor(charge < 1 and JET_COL_EMPTY or JET_COL_FULL)
				surface.DrawRect(x, y - (i * 10) - 10, SCR_W * BAR_WIDTH * 3, 8)
			end
			-- Extra stats
			local Tr = util.QuickTrace(Ply:GetPos(), Vector(0, 0, -9e9), Ply)
			local Dist = math.Round(Ply:GetPos():Distance(Tr.HitPos) / 10) * 10
			draw.DrawText("ALT: "..tostring(math.min(Dist, 9999)), "HudDefault", x + (SCR_W * (BAR_WIDTH + MARGIN) * 3.2), y - (SCR_H * BAR_HEIGHT), JET_COL_FULL, TEXT_ALIGN_LEFT)
			local Ang = math.Round(Ply:EyeAngles().p)
			draw.DrawText("ANG: "..tostring(-Ang), "HudDefault", x + (SCR_W * (BAR_WIDTH + MARGIN) * 3.2), y - (SCR_H * BAR_HEIGHT) + 25, JET_COL_FULL, TEXT_ALIGN_LEFT)
		end
	end
end)

local COLOR_HOSTILE = Color( 255, 0, 0)

hook.Add("PreDrawHalos", "JMod_HL2_HALOS", function()
	local Ply = LocalPlayer()
	if Ply:Alive() and Ply.EZarmor and Ply.EZarmor.effects then
		if Ply.EZarmor.effects.HEVsuit then
			local TrackedEnt = Ply:GetNW2Entity("EZturretTarget", nil)
			if IsValid(TrackedEnt) then
				halo.Add( {TrackedEnt}, COLOR_HOSTILE, 1, 1, 2, true, true, false)
			end
		end
	end
end)

local LastTable = {}
local OldPos, OldAng = Vector(0, 0, 0), Angle(0, 0, 0)
local angle_origin = Angle(0, 0, 0)
local ExtraHeight = Vector(0, 0, 5)

local function TablesEqual(tbl1, tbl2)
	local SamePositions = true
	for k, v in ipairs(tbl1) do
		if v.pos ~= tbl2[k].pos then SamePositions = false break end
	end
	if table.IsEmpty(tbl1) then SamePositions = false end
	return SamePositions
end

hook.Add("PostDrawTranslucentRenderables", "JMod_HL2_TRANSREND", function()
	local Ply = LocalPlayer()
	if Ply:Alive() and Ply.EZarmor and Ply.EZarmor.effects then
		if Ply.EZarmor.effects.HEVsuit then
			local TrackedEnt = Ply:GetNW2Entity("EZmachineTracking", nil)
			if IsValid(TrackedEnt) and TrackedEnt.ScanResults then
				if not(TablesEqual(LastTable, TrackedEnt.ScanResults)) then
					--print("These tables are not the same")
					LastTable = table.Copy(TrackedEnt.ScanResults)
					OldPos = TrackedEnt:GetPos()
					OldAng = TrackedEnt:GetAngles()
					OldAng:RotateAroundAxis(OldAng:Right(), -90)
					OldAng:RotateAroundAxis(OldAng:Up(), 90)
				end

				for k, v in ipairs(LastTable) do
					if (v.typ ~= "ANOMALY") and (v.typ ~= "DANGER") and (v.typ ~= "SMILEY") then
						local NewPos, NewAng = LocalToWorld(v.pos, angle_origin, OldPos, OldAng)
						JMod.HoloGraphicDisplay(nil, NewPos, Angle(0, 0, 0), 1, 30000, function()
							JMod.StandardResourceDisplay(v.typ, v.amt or v.rate, nil, 0, 0, v.siz * 2, true, nil, nil, v.rate)
						end)
					end
				end
			end
		end
	end
end)

hook.Add("RenderScreenspaceEffects", "JMODHL2_SCREENSPACE", function() 
	local Ply, FT, SelfPos, Time, W, H = LocalPlayer(), FrameTime(), EyePos(), CurTime(), ScrW(), ScrH()
	local AimVec, FirstPerson = Ply:GetAimVector(), not Ply:ShouldDrawLocalPlayer()
	local WeldingMask = not(Ply:ShouldDrawLocalPlayer()) and Ply.EZarmor and Ply.EZarmor.effects and Ply.EZarmor.effects.flashresistant
	if WeldingMask then 
		if Ply.EZautoDarken and Ply.EZautoDarken >= 0.1 then
			DrawColorModify({
				["$pp_colour_addr"] = 0,
				["$pp_colour_addg"] = 0 + Ply.EZautoDarken * .3,
				["$pp_colour_addb"] = 0 + Ply.EZautoDarken * .02,
				["$pp_colour_brightness"] = 0 - Ply.EZautoDarken * .4,
				["$pp_colour_contrast"] = 1,
				["$pp_colour_colour"] = 1,
				["$pp_colour_mulr"] = 0,
				["$pp_colour_mulg"] = 0,
				["$pp_colour_mulb"] = 0
			})
		end
		Ply.EZautoDarken = (Ply.EZautoDarken and math.Clamp(Ply.EZautoDarken - 2 * FT, 0.1, 1)) or 0.1
	else
		Ply.EZautoDarken = 0
	end
end)

JModHL2.EZ_NightVisionScreenSpaceEffect = function(ply)

	DrawColorModify({
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = .01,
		["$pp_colour_contrast"] = 7,
		["$pp_colour_colour"] = 0,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	})

	DrawColorModify({
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = .1,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0,
		["$pp_colour_contrast"] = 1,
		["$pp_colour_colour"] = 1,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	})

	if ply and not ply.EZflashbanged then
		DrawMotionBlur(FrameTime() * 50, .8, .01)
	end
end