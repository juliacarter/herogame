extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var label = get_node("Label")
@onready var prog = get_node("ProgressBar")

var tech

func load_tech(new):
	tech = new
	if tech != null:
		label.text = tech.techname
	else:
		label.text = "no tech"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_tech(null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tech != rules.player.science.current_tech:
		load_tech(rules.player.science.current_tech)
	calc_percent()

func calc_percent():
	if tech != null:
		var total_needed = 0
		for key in tech.cost:
			var needed = tech.cost[key]
			total_needed += needed
		var total_has = 0
		for key in tech.progress:
			var has = tech.progress[key]
			total_has += has
		prog.max_value = total_needed
		prog.value = total_has
	else:
		prog.max_value = 1
		prog.value = 0
