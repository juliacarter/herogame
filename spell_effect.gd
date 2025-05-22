extends BaseEffect
class_name SpellEffect

var spellname = ""

func _init(data):
	super(data)
	if data.has("spell"):
		spellname = data.spell

func apply_effect(unit, count):
	for i in count:
		unit.add_spell_by_name(spellname, count)
	
func remove_effect(unit, count):
	for i in count:
		unit.remove_spell_by_name(spellname, count)
