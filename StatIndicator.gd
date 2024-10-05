extends Label

var stat: Stat


func _ready() -> void:
	if stat != null:
		text = stat.title + " " + String.num(stat.value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func load_stat(newstat):
	stat = newstat
	if is_node_ready():
		text = stat.title + " " + String.num(stat.value)
