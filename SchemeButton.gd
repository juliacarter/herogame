extends Button

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")

var scheme = ""
var schemedata = {}
var region

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_scheme(new):
	scheme = new
	schemedata = data.schemes[scheme]
	text = scheme


func _on_pressed() -> void:
	if region.scheme_cooldown == 0:
		if region.influence.has("player"):
			var available = region.influence.player
			if available >= schemedata.cost:
				region.remove_influence("player", schemedata.cost)
				region.scheme_cooldown = 5.0
				rules.start_scheme(scheme, region)
