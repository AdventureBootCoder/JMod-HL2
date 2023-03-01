local tag = "aboot_jumpmod"
local tag_counter = tag .. "_counter"

local shouldshow = CreateClientConVar(tag .. "_hud", "1")
local scrw, scrh = ScrW(), ScrH()
local w_offset, h_offset= 0.305, 0.975
local x_offset = CreateClientConVar(tag .. "_hud_x", scrw * w_offset)
local y_offset = CreateClientConVar(tag .. "_hud_y", scrh * h_offset)
local bar_width, bar_height, margin = 0.0075, 0.065, 0.002
local black, bar_col_full, bar_col_empty = Color(0, 0, 0, 80), Color(255, 236, 12, 240), Color(255, 0, 0, 105)

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

		draw.RoundedBox(10, x - 8, y - (scrh * 0.075), scrw * 0.035, scrh * 0.075, black)
		--outlines
		surface.SetDrawColor(bar_col_empty:Unpack())
		surface.DrawOutlinedRect(x, y - (scrh * bar_height), scrw * bar_width, scrh *  bar_height)
		surface.DrawOutlinedRect(x + scrw * (bar_width + margin), y - (scrh * bar_height), scrw * bar_width, scrh *  bar_height)
		surface.DrawOutlinedRect(x + scrw * (bar_width + margin) * 2, y - (scrh * bar_height), scrw * bar_width, scrh *  bar_height)
		--bar3
		surface.SetDrawColor(bar3 < 1 and bar_col_empty or bar_col_full)
		surface.DrawRect(x, y - (scrh * (bar3 * bar_height)), scrw * bar_width, scrh * (bar3 * bar_height))
		--bar2
		surface.SetDrawColor(bar2 < 1 and bar_col_empty or bar_col_full)
		surface.DrawRect(x + (scrw * (bar_width + margin)), y - (scrh * (bar2 * bar_height)), scrw * bar_width, scrh * (bar2 * bar_height))
		--bar1
		surface.SetDrawColor(bar1 < 1 and bar_col_empty or bar_col_full)
		surface.DrawRect(x + (scrw * (bar_width + margin) * 2), y - (scrh * (bar1 * bar_height)), scrw * bar_width, scrh * (bar1 * bar_height))
		if Ply:GetNW2Bool("EZjumpmod_canuse", false) and charge >= 1 then
			draw.DrawText("READY", "JMod-Stencil-MS", x + (scrw * (bar_width + margin) * 3), y - (scrh * bar_height) + 15, bar_col_full, TEXT_ALIGN_LEFT)
		else
			draw.DrawText("WAIT", "JMod-Stencil-MS", x + (scrw * (bar_width + margin) * 3), y - (scrh * bar_height) + 15, bar_col_empty, TEXT_ALIGN_LEFT)
		end
	end
end)