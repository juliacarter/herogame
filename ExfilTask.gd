extends MoveTask
class_name ExfilTask

func position_reached():
	actor.die(false)
	pass

func _init(square, final):
	super(square, final)
