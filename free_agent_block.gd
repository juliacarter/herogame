extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var list = get_node("List")

var rowscene = load("res://free_agent_block_item.tscn")

var rows = []
var units = []


func clear_rows():
	for i in range(rows.size()-1,-1,-1):
		var row = rows[i]
		list.remove_child(row)
		rows.pop_at(i)
		units.pop_at(i)

func load_free_agents():
	clear_rows()
	for agent in rules.free_agents:
		new_row(agent)
	
func new_row(agent):
	var row = rowscene.instantiate()
	row.block = self
	list.add_child(row)
	row.load_unit(agent)
	rows.append(row)
	units.append(agent)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
