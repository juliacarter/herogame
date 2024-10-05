extends Control

@onready var list = get_node("MinimizableList")

var objscene = load("res://quest_objective_entry.tscn")

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
		objectives.append(instance)
	list.load_items(objectives)
	modified.emit()
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if step != null:
		load_step(step)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
