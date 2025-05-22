extends Control

@onready var namelabel = get_node("HBoxContainer/Name")
@onready var count = get_node("HBoxContainer/Count")

var resourcecounter

func load_counter(new):
	resourcecounter = new

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if resourcecounter != null:
		namelabel.text = resourcecounter.resource
		var num = resourcecounter.count()
		count.text = String.num(num)
		pass
