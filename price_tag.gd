extends HBoxContainer

@onready var valuelabel = get_node("ValueLabel")
@onready var typelabel = get_node("TypeLabel")

func load_tag(type, amount):
	typelabel.text = type[0]
	valuelabel.text = String.num(amount)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
