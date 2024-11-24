extends Control

@onready var holder = get_node("ScrollContainer/Holder")

var buttonscene = load("res://rating_button.tscn")

var ratings = []
var buttons = []

func clear_ratings():
	for i in range(ratings.size()-1,-1,-1):
		var button = buttons[i]
		holder.remove_child(button)
		buttons.pop_at(i)
		ratings.pop_at(i)

func load_ratings(new):
	clear_ratings()
	new.sort_custom(sort_rating)
	for rating in new:
		var button = buttonscene.instantiate()
		buttons.append(button)
		ratings.append(rating)
		holder.add_child(button)
		button.load_rating(rating)
	
func sort_rating(a, b):
	if a.value > b.value:
		return true
	return false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
