extends Panel

@onready var rules = get_node("/root/WorldVariables")
@onready var squadpicker = get_node("SquadPicker")

@onready var picker = get_node("Picker")

@onready var mincount = get_node("MinionCount")

@onready var unitlist = get_node("UnitList")

@onready var targetlabel = get_node("TargetLabel")
@onready var rewardlabel = get_node("RewardLabel")

var mission

#Squad options.
var squaptions = []

var squads = []

var selected_units = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	unitlist.panel = self
	mincount.text = String.num(selected_units.size()) + "/5 Selected"
	
func load_squads():
	visible = true
	
	#squadpicker.clear()
	#update_units()
	
	#for key in rules.squads:
		#var squad = rules.squads[key]
		#squadpicker.add_item(squad.id)
		#squaptions.append(squad)
		
func update_units():
	unitlist.panel = self
	unitlist.load_items(selected_units, "units", true)
	
func load_mission(newmission):
	load_squads()
	mission = newmission
	for key in mission.units:
		var unit = mission.units[key]
		selected_units.append(unit)
	load_targets()
	update_units()
	
func load_targets():
	targetlabel.text = "ENEMIES:"
	for key in mission.units:
		var unit = mission.units[key]
		targetlabel.text.insert(targetlabel.text.size(), " ")
		targetlabel.text.insert(targetlabel.text.size(), unit.object_name)
	
func load_reward():
	pass
	
func pick_item(item, slot):
	for unit in item:
		#if selected_units.size() < 5:
		selected_units.append(unit)
	update_units()
	
func remove_unit(unit):
	selected_units.pop_at(selected_units.find(unit))
	update_units()

func open_unitpicker():
	picker.load_options(self, "units", true)
	picker.visible = true

func _on_start_mission_pressed():
	#if squadpicker.selected != -1:
		#mission.squads.append(squaptions[squadpicker.selected])
	var tempsquad = rules.new_squad()
	for unit in selected_units:
		tempsquad.add_unit(unit)
	mission.add_squad(tempsquad)
	if mission is Encounter:
		rules.start_mission(mission)
	elif mission is MapJob:
		rules.start_map_job(mission)


func _on_close_button_pressed():
	visible = false


func _on_button_pressed() -> void:
	open_unitpicker()
