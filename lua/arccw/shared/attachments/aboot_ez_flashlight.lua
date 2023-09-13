att.PrintName = "EZ Flashlight"
att.Icon = Material("entities/acwatt_tac_pointer.png")
att.Description = "A powerful precision flashlight for your weapon"

att.Flashlight = true
att.FlashlightFOV = 50
att.FlashlightHFOV = nil -- horizontal FOV
att.FlashlightVFOV = nil -- vertical FOV
-- basically, use HFOV + VFOV if you want it to be non square
att.FlashlightFarZ = 1024 -- how far it goes
att.FlashlightNearZ = 4 -- how far away it starts
att.FlashlightAttenuationType = ArcCW.FLASH_ATT_LINEAR -- LINEAR, CONSTANT, QUADRATIC are available
att.FlashlightColor = Color(255, 255, 255)
att.FlashlightTexture = "engine/lightsprite"
att.FlashlightBrightness = 1
att.FlashlightBone = "laser"

att.SortOrder = 100
att.AutoStats = true
att.Slot = "ez_tac"

att.Model = "models/weapons/arccw/atts/laser_pointer.mdl"

att.ToggleStats = {
	{
		PrintName = "Flashlight",
		AutoStatName = "On",
		NoAutoStat = false,
		Flashlight = true,
	},
	{
		PrintName = "Off",
		Flashlight = false,
	}
}