extends Button

@onready var rules = get_node("/root/WorldVariables")

var encounter

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func load_encounter(newencounter):
	encounter = newencounter
	text = encounter.id


func _on_pressed():
	rules.interface.windows.missions.current_tab.open_mission(encounter)
