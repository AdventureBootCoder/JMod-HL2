local tag = "aboot_jumpmod"
local tag_counter = tag .. "_counter"

local shouldshow = CreateClientConVar(tag .. "_hud", "1")
local SCR_W, SCR_H = ScrW(), ScrH()
local OFFSET_W, OFFSET_H= 0.305, 0.975
local x_offset = CreateClientConVar(tag .. "_hud_x", SCR_W * OFFSET_W)
local y_offset = CreateClientConVar(tag .. "_hud_y", SCR_H * OFFSET_H)
local BAR_WIDTH, BAR_HEIGHT, MARGIN = 0.0075, 0.065, 0.002
local BLACK, BAR_COL_FULL, BAR_COL_EMPTY = Color(0, 0, 0, 80), Color(255, 236, 12, 240), Color(255, 0, 0, 105)

hook.Add("HUDPaint", "JMOD_HL2_HUDPAINT", function()
	if not shouldshow:GetBool() then return end
	local Ply = LocalPlayer()
	if Ply:Alive() and Ply.EZarmor and Ply.EZarmor.effects and Ply.EZarmor.effects.jumpmod then

		local x = x_offset:GetInt()
		local y = y_offset:GetInt()

		local charge = Ply:GetNW2Float(tag_counter, 0)
		local bar1 = math.min(charge, 1)
		local bar2 = math.min(charge - bar1, 1)
		local bar3 = math.max(math.min(charge - bar1 * 2, 1), 0)

		draw.RoundedBox(10, x - 8, y - (SCR_H * 0.075), SCR_W * 0.09, SCR_H * 0.080, BLACK)
		--outlines
		surface.SetDrawColor(BAR_COL_EMPTY:Unpack())
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
		draw.DrawText("ANG: "..tostring(Ang), "HudDefault", x + (SCR_W * (BAR_WIDTH + MARGIN) * 3.2), y - (SCR_H * BAR_HEIGHT) + 25, BAR_COL_FULL, TEXT_ALIGN_LEFT)
		if Ply:GetNW2Bool("EZjumpmod_canuse", false) and charge >= 1 then
			draw.DrawText("READY", "HudDefault", x + (SCR_W * (BAR_WIDTH + MARGIN) * 3.2), y - (SCR_H * BAR_HEIGHT) + 50, BAR_COL_FULL, TEXT_ALIGN_LEFT)
		else
			draw.DrawText("WAIT", "HudDefault", x + (SCR_W * (BAR_WIDTH + MARGIN) * 3.2), y - (SCR_H * BAR_HEIGHT) + 50, BAR_COL_EMPTY, TEXT_ALIGN_LEFT)
		end
		-- There's a lot of work done here:
		--[[for i = -90, 90 do
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
	end
end)