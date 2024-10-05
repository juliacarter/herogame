extends Panel

@onready var rules = get_node("/root/WorldVariables")
var interface

@onready var namebox = get_node("NameBox")
@onready var idbox = get_node("IdBox")

@onready var option = get_node("OptionButton")

@onready var spin = get_node("SpinBox")

@onready var priobox = get_node("PrioBox")

var routes = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interface = rules.interface
	spin.value = interface.selected.patrol.desired
	priobox.value = interface.selected.patrol.priority
	load_options()

func load_options():
	for patrol in rules.current_map.patrols:
		routes.append(patrol)
		option.add_item(patrol.id)
	if interface.selected is Waypoint:
		var i = routes.find(interface.selected.patrol)
		option.select(i)
	pass

func get_selected_route():
	var i = option.selected
	var route = routes[i]
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	namebox.text = "waypoint"
	#idbox.text = interface.selected.id

func load_waypoint(new):
	pass


func _on_spin_box_value_changed(value: float) -> void:
	interface.selected.patrol.desired = value


func _on_prio_box_value_changed(value: float) -> void:
	interface.selected.patrol.change_priority(value)


func _on_class_button_pressed() -> void:
	pass # Replace with function body.
