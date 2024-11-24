extends Control

@onready var rules = get_node("/root/WorldVariables")

var tooltipscene = load("res://tooltip.tscn")

var root

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func make_tooltip(tipdata, nested = false):
	
	var mouserig = rules.interface.mouserig
	if mouserig.tooltip != null:
		mouserig.clear_tooltip()
		#remove_tooltip(mouserig.tooltip)
	var tooltip = tooltipscene.instantiate()
	add_child(tooltip)
	tooltip.open_tooltip(tipdata)
	mouserig.attach_tooltip(tooltip)
	if !nested:
		remove_tooltip(root)
		root = tooltip
	return tooltip
	
func remove_tooltip(tooltip):
	remove_child(tooltip)
	if tooltip == root:
		root = null
