extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var list = get_node("VBoxContainer")

var prospectscene = load("res://prospect_item.tscn")

var prospects = []

func clear_prospects():
	for i in range(prospects.size()-1,-1,-1):
		var prospect = prospects[i]
		list.remove_child(prospect)
		prospects.pop_at(i)

func load_prospects():
	clear_prospects()
	for prospectname in rules.player.possible_prospects:
		var prospect = prospectscene.instantiate()
		list.add_child(prospect)
		prospect.load_prospect(prospectname)
		prospects.append(prospect)
		
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
