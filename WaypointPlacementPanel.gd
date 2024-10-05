extends Panel

@onready var rules = get_node("/root/WorldVariables")
var interface

@onready var option = get_node("OptionButton")

@onready var spin = get_node("SpinBox")

var routes = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interface = rules.interface
	load_options()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func clear_options():
	option.clear()
	routes = []

func load_options():
	clear_options()
	routes.append("new")
	option.add_item("new")
	for patrol in rules.current_map.patrols:
		add_option(patrol)
	if interface.selected is Waypoint:
		var i = routes.find(interface.selected.patrol)
		option.select(i)
	pass

func add_option(patrol):
	routes.append(patrol)
	option.add_item(patrol.id)

func get_selected_route():
	var i = option.selected
	var route = routes[i]
	if route is String:
		var patrol = Patrol.new()
		#patrol.priority = rules.current_map.patrols.size()
		patrol.id = rules.uuid(patrol)
		rules.current_map.add_patrol(patrol)
		add_option(patrol)
		load_options()
		option.select(option.item_count - 1)
		return patrol
	else:
		return route

func load_waypoint(new):
	pass


func _on_spin_box_value_changed(value: float) -> void:
	interface.selected.desired = value
