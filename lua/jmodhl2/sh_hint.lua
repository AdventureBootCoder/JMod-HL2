-- supported traits:
-- Text, LangKey, IconType, Time, Followup, RepeatCount
JMod.Hints = JMod.Hints or {}
JModHL2.Hints = {
	["ent_aboot_gmod_ezarmor_jumpmodule"] = {
		LangKey = "hint long jump"
	}
}

timer.Simple(0, function() 
	table.Merge(JMod.Hints, JModHL2.Hints)
end)