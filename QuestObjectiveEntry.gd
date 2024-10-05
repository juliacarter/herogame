extends Control
class_name QuestObjectiveEntry

@onready var label = get_node("Label")

signal modified

var objective

func set_objective(new):
	objective = new

func load_objective(new):
	objective = new
	label.text = objective.get_log_text()
	modified.emit()
	
func update_text():
	label.text = objective.get_log_text()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if objective != null:
		load_objective(objective)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_text()


func _on_fire_button_pressed() -> void:
	if objective.can_fire():
		objective.fire()
