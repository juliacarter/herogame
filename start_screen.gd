extends Panel

@onready var holder = get_node("Holder")

var mastertabscene = load("res://master_maker.tscn")

var tabs = {
	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mastertab = mastertabscene.instantiate()
	tabs.merge({
		"master": mastertab
	})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
