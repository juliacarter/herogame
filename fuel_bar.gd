extends ProgressBar

@onready var label = get_node("Label")

var stat: Stat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if stat != null:
		label.text = stat.title
		min_value = 0
		max_value = stat.max
		value = stat.value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func load_stat(newstat):
	stat = newstat
	if is_node_ready():
		label.text = stat.title
		min_value = 0
		max_value = stat.max
		value = stat.value
