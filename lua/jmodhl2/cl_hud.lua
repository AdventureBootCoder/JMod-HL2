local tag = "aboot_jumpmod"
local tag_counter = tag .. "_counter"

local shouldshow = CreateClientConVar(tag .. "_hud", "1")
local SCR_W, SCR_H = ScrW(), ScrH()
local OFFSET_W, OFFSET_H= 0.305, 0.975
local x_offset = CreateClientConVar(tag .. "_hud_x", SCR_W * OFFSET_W)
local y_offset = CreateClientConVar(tag .. "_hud_y", SCR_H * OFFSET_H)
local BAR_WIDTH, BAR_HEIGHT, MARGIN = 0.0075, 0.065, 0.002
local BLACK, BAR_COL_FULL, BAR_COL_EMPTY = Color(0, 0, 0, 80), Color(255, 236, 12, 240), Color(255, 0, 0, 105)

hook.Remove("HUDPaint", "JMOD_HL2_HUDPAINT")
hook.Add("HUDPaint", "JMOD_HL2_HUDPAINT", function()
	if not shouldshow:GetBool() then return end
	local Ply = LocalPlayer()
	if Ply.EZarmor and Ply.EZarmor.effects and Ply.EZarmor.effects.jumpmod then

		local x = x_offset:GetInt()
		local y = y_offset:GetInt()

		local charge = Ply:GetNW2Float(tag_counter, 0)
		local bar1 = math.min(charge, 1)
		local bar2 = math.min(charge - bar1, 1)
		local bar3 = math.max(math.min(charge - bar1 * 2, 1), 0)

		draw.RoundedBox(10, x - 8, y - (SCR_H * 0.075), SCR_W * 0.035, SCR_H * 0.075, BLACK)
		--outlines
		surface.SetDrawColor(BAR_COL_EMPTY:Unpack())
		surface.DrawOutlinedRect(x, y - (SCR_H * BAR_HEIGHT), SCR_W * BAR_WIDTH, SCR_H *  BAR_HEIGHT)
		surface.DrawOutlinedRect(x + SCR_W * (BAR_WIDTH + MARGIN), y - (SCR_H * BAR_HEIGHT), SCR_W * BAR_WIDTH, SCR_H *  BAR_HEIGHT)
		surface.DrawOutlinedRect(x + SCR_W * (BAR_WIDTH + MARGIN) * 2, y - (SCR_H * BAR_HEIGHT), SCR_W * BAR_WIDTH, SCR_H *  BAR_HEIGHT)
		--bar3
		surface.SetDrawColor(bar3 < 1 and BAR_COL_EMPTY or BAR_COL_FULL)
		surface.DrawRect(x, y - (SCR_H * (bar3 * BAR_HEIGHT)), SCR_W * BAR_WIDTH, SCR_H * (bar3 * BAR_HEIGHT))
		--bar2
		surface.SetDrawColor(bar2 < 1 and BAR_COL_EMPTY or BAR_COL_FULL)
		surface.DrawRect(x + (SCR_W * (BAR_WIDTH + MARGIN)), y - (SCR_H * (bar2 * BAR_HEIGHT)), SCR_W * BAR_WIDTH, SCR_H * (bar2 * BAR_HEIGHT))
		--bar1
		surface.SetDrawColor(bar1 < 1 and BAR_COL_EMPTY or BAR_COL_FULL)
		surface.DrawRect(x + (SCR_W * (BAR_WIDTH + MARGIN) * 2), y - (SCR_H * (bar1 * BAR_HEIGHT)), SCR_W * BAR_WIDTH, SCR_H * (bar1 * BAR_HEIGHT))
		if Ply:GetNW2Bool("EZjumpmod_canuse", false) and charge >= 1 then
			draw.DrawText("READY", "HudDefault", x + (SCR_W * (BAR_WIDTH + MARGIN) * 3), y - (SCR_H * BAR_HEIGHT) + 50, BAR_COL_FULL, TEXT_ALIGN_LEFT)
		else
			draw.DrawText("WAIT", "HudDefault", x + (SCR_W * (BAR_WIDTH + MARGIN) * 3), y - (SCR_H * BAR_HEIGHT) + 50, BAR_COL_EMPTY, TEXT_ALIGN_LEFT)
		end
	end
end)