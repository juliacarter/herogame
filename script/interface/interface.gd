extends Control

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")
@onready var selection = get_node("Panel2/HBoxContainer/Selection")

@onready var map = get_node("WorldMap")

@onready var window = get_node("WindowContainer")

@onready var buttons = {"debug": get_node("%Debug")}
@onready var squadtabs = get_node("SquadTabs")

@onready var squadpanel = get_node("SquadPanel")

@onready var maptabs = get_node("MapTabs")

@onready var questlist = get_node("QuestList")

@onready var toastbar = get_node("Toastbar")

var minimscene = preload("res://minimizable_list.tscn")

@onready var palette = get_node("HBoxContainer2/PowerPalette")

@onready var loader = get_node("Loader")
@onready var saver = get_node("Saver")

@onready var console = get_node("Console")

@onready var testwindow = get_node("DraggableWindow")

@onready var windowholder = get_node("Windows")

@onready var infoholder = get_node("HBoxContainer2/InfoHolder")

@onready var bigwindow = get_node("OuterWindow")

var squadscene = load("res://squad_panel.tscn")

var windows = {}


var buildpanelscene = preload("res://build_panel.tscn")

var toolbarscene = preload("res://scene/interface/toolbar.tscn")
var missionscene = preload("res://mission_screen.tscn")
var furnjobscene = preload("res://furniture_controller.tscn")

var debugscene = preload("res://scene/interface/debug_settings.tscn")
var inventscene = preload("res://furniture_inventory.tscn")
var unitinvscene = preload("res://unit_inventory.tscn")
var unitscene = preload("res://minion_manager.tscn")
var techscene = preload("res://tech_screen.tscn")
var workscene = preload("res://work_screen.tscn")

var lessonbuttonscene = preload("res://lesson_button.tscn")

@onready var minimlist = get_node("MinimizableList")

@onready var arcpreview = get_node("VBoxContainer/ArcPreview")

@onready var placementbutton = get_node("FinishPlacementButton")

var panelscenes = {
	"unit": preload("res://scene/interface/unit_panel.tscn"),
	"furniture": preload("res://scene/furniture/furniture_panel.tscn"),
	"multi": preload("res://multi_select_panel.tscn"),
	"placement": preload("res://placement_panel.tscn"),
	"waypoint": preload("res://waypoint_panel.tscn"),
	"waypointplacement": preload("res://waypoint_placement_panel.tscn"),
	"item": preload("res://item_panel.tscn"),
	
}

var tabscenes = {
	"debug": preload("res://scene/interface/debug_settings.tscn"),
	"furninventory": preload("res://furniture_inventory.tscn"),
	"region": preload("res://region_view.tscn"),
	"shop": preload("res://shop_screen.tscn"),
	"unitinventory": preload("res://unit_inventory.tscn"),
	"singleunit": preload("res://unit_screen.tscn"),
	"classes": preload("res://class_editor.tscn"),
	"squads": preload("res://squad_screen.tscn"),
	"units": preload("res://unit_list.tscn"),
	"missions": preload("res://mission_screen.tscn"),
	"tech":  preload("res://tech_screen.tscn"),
	"work": preload("res://work_screen.tscn"),
	"freeagent": preload("res://free_agent_block.tscn"),
	"prospects": preload("res://prospect_block.tscn"),
	"infamy": preload("res://infamy_screen.tscn"),
	"schemes": preload("res://scheme_buyer.tscn"),
	"unittable": preload("res://unit_table.tscn"),
	"charactersheetoverview": preload("res://character_sheet_overview.tscn"),
	"charactersheetabilities": preload("res://character_sheet_abilities.tscn"),
	"quests": preload("res://quest_view.tscn"),
	"gamemenu": preload("res://game_menu.tscn"),
	"options": preload("res://options_window.tscn"),
	"encounters": preload("res://encounter_list.tscn"),
	"factions": preload("res://faction_view.tscn")
}
var windowscene = preload("res://draggable_window.tscn")

var shopscene = preload("res://shop_screen.tscn")

var evilpediascene = preload("res://evil_pedia.tscn")

var singleunitscene = preload("res://unit_screen.tscn")

var selectpanel
var windowpanel

var selected

var tooltipscene = load("res://tooltip.tscn")

@onready var testlist = get_node("TestList")

@onready var mouserig = get_node("MouseRig")

@onready var tips = get_node("TooltipStack")

#make a new tooltip, then anchor it to the mouserig
func make_tooltip(tipdata, nested = false):
	return tips.make_tooltip(tipdata, nested)
	
func remove_tooltip(tooltip):
	return tips.remove_tooltip(tooltip)

# Called when the node enters the scene tree for the first time.
func _ready():
	rules.interface = self
	
	#map.load_regions()
	
	#testwindow.create_tab(workwindow)
	#testwindow.create_tab(shopwindow)
	
	#squadtabs.load_squads(rules.squads)
	maptabs.interface = self
	maptabs.load_maps()
	

func select(object):
	pass
	

#func _input(event):
#	if event is InputEventKey:
#		if event.pressed and event.keycode == KEY_ESCAPE:
#			rules.interface.open_console()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouserig.global_position = get_viewport().get_mouse_position()
	
func _input(event):
	if event is InputEventKey:
		if event.pressed && event.keycode == 96:
			toggle_console()

func toggle_console():
	console.activate(!console.active)

func update_selection():
	if rules.placing_formation:
		if selectpanel != null:
			infoholder.remove_child(selectpanel)
		selectpanel = panelscenes.placement.instantiate()
		
		infoholder.add_child(selectpanel)
		selectpanel.load_units(rules.formation_units)
		return
	if rules.selected.size() == 0:
		bigwindow.visible = false
		if(selectpanel != null):
			infoholder.remove_child(selectpanel)
		if rules.power != null:
			if rules.power is Power && rules.power.panel != "":
				palette.load_palette(
					[]
				)
				selectpanel = panelscenes[rules.power.panel].instantiate()
				
				infoholder.add_child(selectpanel)
	elif rules.selected.size() == 1:
		bigwindow.visible = true
		for key in rules.selected:
			selected = rules.selected[key]
		if(selected.entity() == "FURNITURE"):
			if(selectpanel != null):
				infoholder.remove_child(selectpanel)
			palette.load_palette(
				[]
			)
			selectpanel = panelscenes.furniture.instantiate()
			infoholder.add_child(selectpanel)
		elif(selected.entity() == "FLOORSTACK"):
			if(selectpanel != null):
				infoholder.remove_child(selectpanel)
			palette.load_palette(
				[]
			)
			selectpanel = panelscenes.item.instantiate()
			infoholder.add_child(selectpanel)
		elif(selected.entity() == "WAYPOINT"):
			if(selectpanel != null):
				infoholder.remove_child(selectpanel)
			palette.load_palette(
				[]
			)
			selectpanel = panelscenes.waypoint.instantiate()
			infoholder.add_child(selectpanel)
		elif(selected.entity() == "UNIT"):
			if(selectpanel != null):
				infoholder.remove_child(selectpanel)
			selectpanel = panelscenes.unit.instantiate()
			
			palette.load_palette(
				selected.action_palette()
			)
			infoholder.add_child(selectpanel)
			selectpanel.load_unit(selected)
		elif selected.entity() == "CATEGORY":
			if(selectpanel != null):
				infoholder.remove_child(selectpanel)
			selectpanel = buildpanelscene.instantiate()
			infoholder.add_child(selectpanel)
			selectpanel.load_palette(selected.tools)
	else:
		bigwindow.visible = true
		if(selectpanel != null):
			infoholder.remove_child(selectpanel)
		palette.load_palette(
				[]
			)
		selectpanel = panelscenes.multi.instantiate()
		infoholder.add_child(selectpanel)
	if rules.selected_squad != null:
		squadpanel.load_squad(rules.selected_squad)
		squadpanel.visible = true
	else:
		squadpanel.visible = false

func open_character_sheet(unit):
	var window = open_window("charactersheetoverview")
	if window != null:
		window.current_tab.load_unit(unit)
		var abilitiestab = tabscenes.charactersheetabilities.instantiate()
		window.create_tab(abilitiestab)
		abilitiestab.load_unit(unit)

func close_window(windowname):
	if windows.has(windowname):
		var window = windows[windowname]
		windowholder.remove_child(window)
		windows.erase(windowname)

func open_window(windowname):
	if !windows.has(windowname):
		var window = windowscene.instantiate()
		window.windowname = windowname
		windowholder.add_child(window)
		
		if tabscenes.has(windowname):
			var tab = tabscenes[windowname].instantiate()
			window.create_tab(tab)
		window_to_center(window)
		
		window.z = windows.size() + 1
		window.z_index = window.z
		windows.merge({
			windowname: window
		})
		return window
	else:
		windows[windowname].to_top()
		window_to_center(windows[windowname])
		

func window_to_top(window):
	var z = window.z
	for key in windows:
		var newwindow = windows[key]
		if newwindow.z > z:
			newwindow.z -= 1
			newwindow.z_index = newwindow.z
	window.z = windows.size()
	window.z_index = window.z
	windowholder.move_child(window, windowholder.get_child_count()-1)
	
func window_to_center(window):
	window.global_position = (get_viewport_rect().size - window.size)/2
	
func view_article(item):
	var window = open_window("evilpedia")
	window.current_tab.open_article(item)


	

func open_region(new):
	var window = open_window("region")
	window.current_tab.load_region(new)

func _on_mouse_entered():
	rules.on_interface = true

func _on_mouse_exited():
	rules.on_interface = false


func _on_bar_opened():
	pass

func _on_debug_pressed():
	var window = open_window("debug")
	
func _on_units_pressed():
	var window = open_window("unittable")
	
func _on_research_pressed():
	var window = open_window("tech")
	

func _on_production_pressed() -> void:
	var window = open_window("work")
	if window != null:
		window.current_tab.load_jobs(rules.home.jobs)

func _on_missions_pressed():
	var window = open_window("missions")

func _on_shop_pressed() -> void:
	var window = open_window("shop")
	if window != null:
		window.current_tab.depot = rules.home.active_depot
		window.current_tab.map = rules.home
		window.current_tab.get_buy()

func _on_area_2d_mouse_entered():
	rules.on_interface = true


func _on_area_2d_mouse_exited():
	rules.on_interface = false


func _on_quit_button_pressed() -> void:
	rules.save_game_prompt()


func _on_save_map_pressed() -> void:
	rules.save_map_prompt()





func _on_finish_placement_button_pressed() -> void:
	rules.check_placement_finished()


func _on_free_agents_pressed() -> void:
		
	var window = open_window("freeagent")
	window.current_tab.load_free_agents()


func _on_prospects_pressed() -> void:
	var window = open_window("prospects")
	window.current_tab.load_prospects()


func _on_infamy_pressed() -> void:
	var window = open_window("infamy")


func _on_world_pressed() -> void:
	rules.open_world_map()


func _on_button_pressed() -> void:
	#var window = open_window("quests")
	open_missions()

func open_quest(new):
	var window = open_window("quests")
	window.current_tab.open_quest(new)

func open_missions():
	var window = open_window("quests")
	var tab = tabscenes.encounters.instantiate()
	window.create_tab(tab)

func open_encounter(new):
	var window = open_window("encounters")
	window.current_tab.load_encounter(new)

func open_pin(pin):
	if pin.pindata is QuestPinData:
		open_quest(pin.pindata.quest)
	if pin.pindata is EncounterPinData:
		open_encounter(pin.pindata.encounter)

func _on_build_pressed() -> void:
	palette.load_build()


func _on_power_pressed() -> void:
	palette.load_powers()


func _on_encounters_pressed() -> void:
	var window = open_window("encounters")


func _on_button_2_pressed() -> void:
	var window = open_window("factions")
