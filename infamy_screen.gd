extends Panel

@onready var rules = get_node("/root/WorldVariables")

@onready var label = get_node("Label")
@onready var bar = get_node("ProgressBar")

@onready var options = get_node("options")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bar.value = rules.player.notoriety

func load_infamy():
	bar.max_value = rules.player.notoriety_to_next

func _on_button_pressed() -> void:
	rules.player.earn_notoriety(10)
