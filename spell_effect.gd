extends BaseEffect
class_name SpellEffect

var spellname = ""

func _init(data):
	super(data)
	if data.has("spell"):
		spellname = data.spell
