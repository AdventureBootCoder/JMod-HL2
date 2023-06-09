JMod.Locales = JMod.Locales or {}
JModHL2.Locales = JModHL2.Locales or {}

JModHL2.Locales["en"] = {
	["hint long jump"] = "The long jump module will drain from aux power or it's inernal battery to recharge."
}

timer.Simple(0, function() 
	table.Merge(JModHL2.Locales["en"], JMod.Locales["en"])
end)