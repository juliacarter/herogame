extends Control

@onready var idlabel = get_node("VBoxContainer/IDLabel")

var region

#units "parked" in the region"
var units = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_region(new):
	region = new
	idlabel.text = region.id
