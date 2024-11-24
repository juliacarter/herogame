extends Node2D
class_name Ghost

var indicator

@onready var rules = get_node("/root/WorldVariables")

var radius = 0

var max_distance = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if indicator != null:
	#	indicator.update_position(global_position)
		
func update_position(pos):
	if indicator != null:
		indicator.update_position(pos)

func set_origin(pos):
	indicator.set_origin(pos)

func load_ghost(aoedata):
	if aoedata.has("shape"):
		var indicatorscene = rules.indicatorscenes[aoedata.shape]
		indicator = indicatorscene.instantiate()
		indicator.modulate = Color(1, 1, 1, 0.5)
		add_child(indicator)
		indicator.load_aoe(aoedata)
	if aoedata.has("radius"):
		radius = aoedata.radius
		indicator.set_radius(radius)
	if aoedata.has("range"):
		max_distance = aoedata.range
		indicator.update_range(max_distance)
