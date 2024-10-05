extends HBoxContainer

@onready var rules = get_node("/root/WorldVariables")

var maptabscene = load("res://map_tab.tscn")
var jobtabscene = load("res://map_work_tab.tscn")

var maps = []
var tabs = {}

var interface

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func clear_tabs():
	for i in range(tabs.size() - 1, -1, -1):
		remove_child(tabs[i])
		tabs.pop_at(i)
	
func close_tab(map):
	if tabs.has(map.id):
		var tab = tabs[map.id]
		remove_child(tab)
		tabs.erase(map.id)
	
func open_tab(map):
	if !tabs.has(map.id):
		var tab
		if map is Grid:
			tab = maptabscene.instantiate()
		elif map is MapJob:
			tab = jobtabscene.instantiate()
		tab.load_map(map)
		tabs.merge({map.id: tab})
		add_child(tab)
	
func load_maps():
	#clear_tabs()
	for key in rules.maps:
		var map = rules.maps[key]
		open_tab(map)
	for key in rules.worksites:
		var site = rules.worksites[key]
		open_tab(site)
	pass
