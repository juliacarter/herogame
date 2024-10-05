extends Panel

@onready var rules = get_node("/root/WorldVariables")

@onready var critpanel = get_node("CriteriaPanel")
@onready var orderpanel = get_node("OrderPanel")

@onready var orderbox = get_node("Panel/ScrollContainer/CriteriaBox")

@onready var squadoptions = get_node("SelectSquad")

@onready var picker = get_node("Picker")

@onready var prioritybox = get_node("PriorityBox")

var syntaxscene = load("res://syntax_holder.tscn")

var squads = []

var selected_squad

var available_units = []
var selected_units = []

var squad_leader

var criteria = []

var mainscene

# Called when the node enters the scene tree for the first time.
func _ready():
	critpanel.screen = self
	critpanel.slot = "criteria"
	orderpanel.screen = self
	orderpanel.slot = "order"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func load_squad(squad):
	clear_squad()
	selected_squad = squad
	critpanel.owned_by = squad
	orderpanel.owned_by = squad
	for crit in selected_squad.criteria:
		var holder = critpanel.add_syntax(crit)
		holder.saved = true
	for order in selected_squad.orders:
		var holder = orderpanel.add_syntax(order)
		holder.saved = true
	pass

func add_squad(squad):
	squadoptions.add_item(squad.id)
	squads.append(squad)

func clear_squad():
	critpanel.clear_syntax()
	orderpanel.clear_syntax()

func clear_options():
	#squadoptions.clear()
	squads = []

func get_options():
	clear_options()
	for key in rules.squads:
		var squad = rules.squads[key]
		add_squad(squad)
	if squads.size() != 0:
		load_squad(squads[0])

func open_picker(button, slot, multi = false):
	picker.visible = true
	picker.load_options(button, slot, multi)

func _on_select_squad_item_selected(index: int) -> void:
	var item = squads[index]
	load_squad(item)
	


func _on_commit_pressed() -> void:
	selected_squad.remove_orders()
	critpanel.save_syntax()
	orderpanel.save_syntax()
	selected_squad.apply_orders()
	selected_squad.update_priority(prioritybox.value)

func pick_item(value, slot):
	if slot == "criteria":
		critpanel.add_syntax(value)
	if slot == "order":
		orderpanel.add_syntax(value)




func _on_new_pressed() -> void:
	rules.new_squad()
