extends BaseEffect
class_name OvertimeEffect

var damage = {}

var value = 10

func _init(data):
	if data.has("damage"):
		damage = data.damage.duplicate()
	type = "overtime"
	ticking = true

func tick(delta, on, stacks):
	on.damage("health", value * stacks * delta)
