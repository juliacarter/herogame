extends HBoxContainer

@onready var namelabel = get_node("Content/HBoxContainer/VBoxContainer/HBoxContainer/Name")
@onready var typelabel = get_node("Type")

@onready var description = get_node("Description")
@onready var cooldown = get_node("Cooldown")
@onready var cost = get_node("Cost")

var parent

var action

func load_action(new):
	action = new
	namelabel.text = action.key

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_up_pressed() -> void:
	#action.priority += 1
	parent.move_item(self, -1)


func _on_down_pressed() -> void:
	#action.priority -= 1
	parent.move_item(self, 1)
