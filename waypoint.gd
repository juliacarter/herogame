extends Area2D
class_name Waypoint

@onready var rules = get_node("/root/WorldVariables")

@onready var viewer = get_node("PatrolViewer")

var id = ""

var datakey
var pos = {"x": 0, "y": 0}

var index

var map: Grid
var patrol: Patrol
var type
var pointname

func save():
	var save_dict = {
		"id": id,
		"datakey": datakey,
		"pos": pos,
		"map": map.id,
		"type": type,
		"pointname": pointname,
	}
	if patrol != null:
		save_dict.merge({
			"patrol": patrol.id
		})

func get_square():
	return map.blocks[pos.x][pos.y]


func load_waypoint(pointdata):
	type = pointdata.type
	pointname = pointdata.name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewer.waypoint = self

func path_to(waypoint):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if patrol != null:
		if viewer.visible:
			if index < patrol.nodes.size()-1:
				var node = patrol.nodes[index+1]
				viewer.draw_path(node.global_position - global_position)
			else:
				var node = patrol.nodes[0]
				viewer.draw_path(node.global_position - global_position)

func set_patrol():
	if type == "patrol":
		if map.patrols.size() >= 1:
			patrol = map.patrols[0]
			index = map.patrols.size()
			patrol.nodes.append(self)
		else:
			map.patrols.append(Patrol.new())
			index = 0
			patrol = map.patrols[0]
			patrol.nodes.append(self)

func entity():
	return "WAYPOINT"

func _on_mouse_entered() -> void:
	await rules.hover_waypoint(self)

func _on_mouse_exited() -> void:
	if rules.hovered_waypoint == self:
		await rules.hover_waypoint(null)

func _on_spin_box_value_changed(value: float) -> void:
	rules.interface.selected.patrol.desired = value
