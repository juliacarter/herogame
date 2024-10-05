extends Control

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")

@onready var list = get_node("SchemeList")

@onready var prog = get_node("ProgressBar")

var schemebutton = load("res://scheme_button.tscn")

#region to buy schemes for
var region

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if region != null:
		prog.max_value = 5.0
		prog.value = region.scheme_cooldown

func load_region(new):
	region = new
	load_schemes()
	
func load_schemes():
	for key in data.schemes:
		var button = schemebutton.instantiate()
		button.region = region
		
		list.add_child(button)
		button.load_scheme(key)
