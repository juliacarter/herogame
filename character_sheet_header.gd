extends Control

@onready var namelabel = get_node("HBoxContainer/VBoxContainer/HBoxContainer/NameLabel")
@onready var levellabel = get_node("HBoxContainer/VBoxContainer/HBoxContainer/LevelLabel")

@onready var ratings = get_node("RatingDisplay")

@onready var exp = get_node("ExperienceBar")

var unit

func load_unit(new):
	unit = new
	var ratingarray = []
	for key in unit.ratings:
		var rating = unit.ratings[key]
		ratingarray.append(rating)
	ratings.load_ratings(ratingarray)
	exp.load_unit(unit)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if unit != null:
		namelabel.text = unit.object_name()
		levellabel.text = "lv." + String.num(unit.level)
