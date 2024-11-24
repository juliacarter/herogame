extends Control


@onready var objholder = get_node("ObjectiveHolder")

var objscene = load("res://quest_objective_entry.tscn")

var objectives = []

signal modified

var step

func set_step(new):
	step = new

func load_step(new):
	step = new
	var objectives = []
	for obj in step.objectives:
		var instance = objscene.instantiate()
		instance.set_objective(obj)
		objholder.add_child(instance)
		objectives.append(instance)
	#list.load_items(objectives)
	modified.emit()
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if step != null:
		load_step(step)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
