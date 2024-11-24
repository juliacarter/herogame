extends PlacedAreaSpell
class_name LinePlacedAreaSpell

func _init(gamedata, spelldata, parent = null):
	shape = "AreaEffectLine"
	super(gamedata, spelldata, parent)
	if spelldata.has("max_distance"):
		max_distance = spelldata.max_distance
	move_to = false
