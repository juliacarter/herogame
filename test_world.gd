extends Node2D
class_name World

var global_queue: Multiqueue

@onready var data = get_node("/root/Data")

@onready var rules = get_node("/root/WorldVariables")
@onready var camera = get_node("Camera2D")
@onready var viewport = get_node("SubViewportContainer/SubViewport")
@onready var world = get_node("MainCanvas")
@onready var interface = get_node("Interface/InterfacePanel")

@onready var inputhandler = get_node("InputHandler")

@onready var map = get_node("WorldMap")

var grid

var units = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	rules.world = self
	rules.interface = interface
	
	map.load_regions()
	
	pass
	
func new_world():
	#rules.home = rules.make_map(30, 30)
	#rules.open_map(rules.home.id)
	#rules.make_map(10, 10)
#	global_queue = Multiqueue.new()
#	get_node("Unit").set_queue(global_queue)
#	get_node("Grid").set_queue(global_queue)
	#camera.set_custom_viewport(viewport)
	#camera.make_current()
	#print(camera.is_current())
	rules.open_world_map()
	call_deferred("camera_setup")
	#minibase()
	#scaryrunning()
	#default_room()
	#fight_club()
	#emptybase()
	
func load_map(map):
	add_child(map)
	
func remove_map(map):
	remove_child(map)
	
func fight_club():
	for i in 20:
		rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[3][2].position)
		rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[8][2].position)
	
	
	
func default_room():
	rules.current_map.spawn_item(data.items["ore"], rules.current_map.blocks[4][1].position)
	rules.current_map.spawn_item(data.items["pistol"], rules.current_map.blocks[4][2].position)
	await rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[4][2].position)
	await rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[4][3].position)
	await rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[4][4].position)
	await rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[4][5].position)
	await rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[4][6].position)
	await rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[4][7].position)
	await rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[4][8].position)
	await rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[4][9].position)
	await rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[4][10].position)
	await rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[4][11].position)
	await rules.current_map.spawn_unit(data.units.master, rules.current_map.blocks[5][13].position)
	await rules.current_map.spawn_unit(data.units.machinegunner, rules.current_map.blocks[4][12].position)
	rules.current_map.place_furniture(0, data.furniture.smelter, 6, 1, false, false)
	rules.current_map.place_furniture(0, data.furniture.smelter, 7, 1, false, false)
	rules.current_map.place_furniture(0, data.furniture.crate, 8, 6, false, false)
	rules.current_map.place_furniture(0, data.furniture.freegenerator, 6, 6, false, false)
	rules.current_map.place_furniture(0, data.furniture.bed, 8, 8, false, false)
	rules.current_map.place_furniture(0, data.furniture.bed, 8, 9, false, false)
	rules.current_map.place_furniture(2, data.furniture.bed, 7, 8, false, false)
	rules.current_map.place_furniture(2, data.furniture.bed, 7, 9, false, false)
	rules.current_map.place_furniture(1, data.furniture.mine, 10, 4, false, false)
	rules.current_map.place_furniture(1, data.furniture.mine, 10, 5, false, false)
	rules.current_map.place_furniture(1, data.furniture.mine, 10, 6, false, false)
	rules.current_map.place_furniture(1, data.furniture.mine, 10, 7, false, false)
	rules.current_map.place_furniture(1, data.furniture.mine, 10, 8, false, false)
	rules.current_map.place_furniture(1, data.furniture.scanpanel, 2, 4, false, false)
	#rules.current_map.place_furniture(0, data.furniture.depot, 15, 15)
	
	rules.current_map.flip_tile(12, 1)
	rules.current_map.flip_tile(12, 2)
	rules.current_map.flip_tile(12, 3)
	rules.current_map.flip_tile(12, 4)
	rules.current_map.flip_tile(12, 5)
	rules.current_map.flip_tile(12, 6)
	rules.current_map.flip_tile(12, 7)
	rules.current_map.flip_tile(12, 8)
	rules.current_map.flip_tile(12, 9)
	rules.current_map.flip_tile(12, 10)
	
func emptybase():
	rules.current_map.place_furniture(0, data.furniture.smelter, 4, 1)
	rules.current_map.place_furniture(0, data.furniture.smelter, 5, 1)
	rules.current_map.place_furniture(0, data.furniture.crate, 6, 6)
	rules.current_map.place_furniture(0, data.furniture.oilgenerator, 4, 6)
	rules.current_map.place_furniture(0, data.furniture.bed, 6, 8)
	rules.current_map.place_furniture(0, data.furniture.bed, 6, 9)
	rules.current_map.place_furniture(2, data.furniture.bed, 5, 8)
	rules.current_map.place_furniture(2, data.furniture.bed, 5, 9)
	rules.current_map.place_furniture(1, data.furniture.mine, 8, 4)
	rules.current_map.place_furniture(1, data.furniture.mine, 8, 5)
	rules.current_map.place_furniture(1, data.furniture.mine, 8, 6)
	rules.current_map.place_furniture(1, data.furniture.mine, 8, 7)
	rules.current_map.place_furniture(1, data.furniture.mine, 8, 8)
	
func scaryrunning():
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[3][9].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[3][8].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[3][7].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[3][6].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[3][5].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[3][4].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[3][3].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[3][2].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[3][1].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[7][9].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[7][8].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[7][7].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[7][6].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[7][5].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[7][4].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[7][3].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[7][2].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[7][1].position)
	
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][9].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][8].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][7].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][6].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][5].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][4].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][3].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][2].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][1].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][9].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][8].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][7].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][6].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][5].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][4].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][3].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][2].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][1].position)
	
func minibase():
	rules.current_map.spawn_item("thang", rules.current_map.blocks[15][4].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[18][4].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[18][5].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[18][6].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[18][7].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[18][7].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[18][8].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[18][10].position)
	rules.current_map.spawn_unit(data.units.minion, rules.current_map.blocks[18][11].position)
	rules.current_map.place_furniture(0, data.furniture.smelter, 19, 4)
	rules.current_map.place_furniture(0, data.furniture.smelter, 20, 4)
	rules.current_map.place_furniture(0, data.furniture.crate, 19, 6)
	rules.current_map.place_furniture(0, data.furniture.bed, 21, 10)
	rules.current_map.place_furniture(0, data.furniture.bed, 21, 11)
	rules.current_map.place_furniture(2, data.furniture.bed, 20, 10)
	rules.current_map.place_furniture(2, data.furniture.bed, 20, 11)
	rules.current_map.place_furniture(1, data.furniture.mine, 21, 4)
	rules.current_map.place_furniture(1, data.furniture.mine, 21, 5)
	rules.current_map.place_furniture(1, data.furniture.mine, 21, 6)
	rules.current_map.place_furniture(1, data.furniture.mine, 21, 7)
	rules.current_map.place_furniture(1, data.furniture.mine, 21, 8)
	
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[3][9].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[3][8].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[3][7].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[3][6].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[3][5].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[3][4].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[3][3].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[3][2].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[3][1].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[7][9].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[7][8].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[7][7].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[7][6].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[7][5].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[7][4].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[7][3].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[7][2].position)
	rules.current_map.spawn_unit(data.units.guard, rules.current_map.blocks[7][1].position)
	
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][9].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][8].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][7].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][6].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][5].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][4].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][3].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][2].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[5][1].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][9].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][8].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][7].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][6].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][5].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][4].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][3].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][2].position)
	rules.current_map.spawn_unit(data.units.agent, rules.current_map.blocks[9][1].position)

func add_unit(unit):
	units.merge({
		unit.id: unit
	})
	add_child(unit)

func camera_setup():
	camera.make_current()
	
func update_select():
	interface.update_selection()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_navigate(pos):
	pass # Replace with function body.



func _on_queue_button_pressed():
	pass # Replace with function body.
