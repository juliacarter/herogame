extends Panel

var unitscene = load("res://unit_holder.tscn")

@onready var grid = get_node("GridContainer")


var possible = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_options(options):
	visible = true
	possible = options.duplicate()
	for unit in possible:
		var newunit = unitscene.instantiate()
		newunit.load_unit(unit)
		grid.add_child(newunit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_pressed():
	visible = false
