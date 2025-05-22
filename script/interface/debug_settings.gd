extends Panel

var buttonscene = load("res://debugvarbutton.tscn")

@onready var data = get_node("/root/Data")

@onready var rules = get_node("/root/WorldVariables")

@onready var spawner = get_node("WaveSpawner")

@onready var box

@onready var varbox = get_node("DebugVars")

var varbuttons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	load_vars()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func clear_vars():
	for i in range(varbuttons.size()-1,-1,-1):
		var button = varbuttons.pop_at(i)
		varbox.remove_child(button)
		

func load_vars():
	clear_vars()
	for debugvar in rules.debugvars:
		var button = buttonscene.instantiate()
		varbuttons.append(button)
		varbox.add_child(button)
		button.load_var(debugvar)

func _on_check_box_toggled(button_pressed):
	rules.debugvars.instabuild = button_pressed
	print(rules.debugvars.instabuild)
	



func _on_check_box_2_toggled(toggled_on: bool) -> void:
	rules.debugvars.unlockall = toggled_on
	print(rules.debugvars.unlockall)


func _on_button_pressed() -> void:
	visible = false


func _on_button_2_pressed() -> void:
	spawner.visible = true
	spawner.load_objectives()
	spawner.load_factions()
	spawner.load_waves()


func _on_button_3_pressed() -> void:
	rules.draw_encounter()


func _on_cash_button_pressed() -> void:
	rules.add_intangible("cash", 100)


func _on_button_4_pressed() -> void:
	rules.initial_quests()


func _on_inf_button_pressed() -> void:
	rules.add_intangible("influence", 100)


func _on_button_5_pressed() -> void:
	rules.draw_mapjob()


func _on_add_asset_pressed() -> void:
	rules.debug_asset()
