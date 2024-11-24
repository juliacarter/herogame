extends Spell
class_name ToggleSpell

var toggled = true

var applied_abilities = {}

func toggle(val):
	toggled = val

func _init(gamedata, spelldata, parent = null):
	super(gamedata, spelldata, parent)
	spend_on_cast = false
	if spelldata.has("toggled_abilities"):
		applied_abilities = spelldata.toggled_abilities.duplicate()

func make_power():
	var power = ActionPower.new({
		"name": key,
		"on_cast": "toggle_spell",
		"cast_args": [self, unit],
		"category": "unit",
		"instacast": true,
		"action": self
	})
	power.make_tool()
	return power
