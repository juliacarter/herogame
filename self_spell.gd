extends Spell
class_name SelfSpell

func make_power():
	var power = ActionPower.new({
		"name": key,
		"on_cast": "order_spellcast_at_self",
		"cast_args": [self, unit],
		"category": "unit",
		"instacast": true,
		"action": self
	}, rules)
	power.make_tool()
	return power
