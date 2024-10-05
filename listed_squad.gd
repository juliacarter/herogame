extends Button

var squad

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = squad.id


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func load_squad(newsquad):
	squad = newsquad
