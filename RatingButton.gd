extends Control

var rating

@onready var namelabel = get_node("Button/HBoxContainer/Name")
@onready var numlabel = get_node("Button/HBoxContainer/Value")

func load_rating(new):
	rating = new
	namelabel.text = rating.key
	numlabel.text = String.num(rating.value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
