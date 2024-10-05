extends Panel

@onready var rules = get_node("/root/WorldVariables")

@onready var namelabel = get_node("Name")
@onready var leaderlabel = get_node("Leader")
@onready var transbutton = get_node("TransButton")
@onready var mapselect = get_node("MapSelect")


var squad

var maps = []

# Called when the node enters the scene tree for the first time.
func _ready():
	load_maps()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if squad != null:
		if squad.id != null:
			namelabel.text = "ID:" + squad.id
		else:
			namelabel.text = "NO ID"
		if squad.leader != null:
			leaderlabel.text = "LEADER:" + squad.leader.firstname + " " + squad.leader.lastname
		else:
			leaderlabel.text = "NO LEADER"

func load_squad(newsquad):
	squad = newsquad
	load_maps()

func load_maps():
	mapselect.clear()
	maps = []
	for key in rules.maps:
		var map = rules.maps[key]
		mapselect.add_item(map.id)
		maps.append(map)
		
func _on_rally_button_pressed():
	squad.rally()


func _on_trans_button_pressed():
	var map = maps[mapselect.selected]
	squad.transport_order(map)
