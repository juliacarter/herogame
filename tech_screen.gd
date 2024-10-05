extends Panel

@onready var rules = get_node("/root/WorldVariables")
@onready var grid = get_node("AvailableTechs")

@onready var techname = get_node("Label")
@onready var bar = get_node("ProgressBar")

var techs = []

var buttonscene = load("res://tech_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_techs()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rules.player.science.current_tech != null:
		techname.text = rules.player.science.current_tech.techname
		#bar.max_value = rules.player.science.current_tech.cost
		#bar.value = rules.player.science.current_tech.progress

func clear_techs():
	for i in range(techs.size()-1, -1, -1):
		var tech = techs.pop_at(i)
		grid.remove_child(tech)

func load_techs():
	clear_techs()
	for key in rules.player.science.researchable:
		var tech = rules.player.science.researchable[key]
		var button = buttonscene.instantiate()
		button.load_tech(tech)
		techs.append(button)
		grid.add_child(button)
