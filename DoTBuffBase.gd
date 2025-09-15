extends BuffBase
class_name DoTBuffBase

var tick_damage = 10

func _init(data):
	super(data)
	if data.has("tick_damage"):
		tick_damage = data.tick_damage

func tick(delta, unit):
	#unit.damage("health", tick_damage * delta)
	pass
