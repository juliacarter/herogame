extends SelfSpell
class_name SelfAreaSpell

var aoedata

func _init(gamedata, spelldata, parent = null):
	super(gamedata, spelldata, parent)
	targeted = false
	if spelldata.has("aoedata"):
		aoedata = spelldata.aoedata
	fire_action = "aoe_on_unit"
	fire_args = [aoedata, unit]

