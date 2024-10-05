extends Button

@onready var rules = get_node("/root/WorldVariables")

var tech

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_tech(newtech):
	tech = newtech
	text = tech.techname


func _on_pressed():
	rules.player.science.start_research(tech)
