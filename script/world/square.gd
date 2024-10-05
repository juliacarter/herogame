@tool
extends NavigationRegion2D
class_name Square

@onready var selection = get_node("Selection")

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")

@onready var nav

var wallscene = preload("res://scene/world/wall.tscn")
var blockscene = preload("res://scene/world/block.tscn")
var edgescene = preload("res://edge.tscn")
var floorscene = preload("res://scene/world/floor.tscn")
var printscene = preload("res://scene/furniture/footprint.tscn")

@onready var selector = get_node("Selector")

#@onready var nav = get_node("NavRegion")
@onready var diggable = get_node("Diggable")
@onready var digshape = get_node("Diggable/Shape")
@onready var inside = get_node("Inside")

var can_interact = {}

var can_take = {}

@onready var cells = {
	"center": get_node("Cells/Center"),
	"north": get_node("Cells/North"),
	"northwest": get_node("Cells/NorthWest"),
	"west": get_node("Cells/West"),
	"southwest": null,
	"south": null,
	"southeast": null,
	"east": null,
	"northeast": null,
}

signal highlight(x, y)
signal unhighlight(x, y)

var footprint: Footprint
var containing = false

var units = {}

var highlighted = false

var zones = {}
var zonerects = {}

var x = -1
var y = -1

var map

#Offset of the "center" cell for nav purposes
var navx = -1
var navy = -1

var n
var ne
var e
var se
var s
var sw
var w
var nw

var weight = 1

var occupied = false
var reserved = false

var t = Transform2D()

var content: Block

var id

var rect


var door: Door

func make_zonevis():
	if rect != null:
		remove_child(rect)
	rect = ColorRect.new()
	rect.mouse_filter = 1
	rect.color = Color(0, 0, 0, 0.5)
	rect.size = Vector2(64, 64)
	rect.position = Vector2(-32, -32)
	add_child(rect)

func random_cell():
	var random = cells[cells.keys()[randi() % cells.size()]]
	if random == null:
		return cells.center
	return random

func assign_cells():
	
	var centerlink = Link.new([cells.center], self)
	var westlink = Link.new([cells.west], self)
	var northwestlink = Link.new([cells.northwest], self)
	var northlink = Link.new([cells.north], self)
	
	cells.center.links.c = centerlink
	cells.west.links.c = westlink
	cells.northwest.links.c = northwestlink
	cells.north.links.c = northlink
	
	var centernlink = Link.new([cells.center, cells.north], self)
	cells.center.adjacent.n = cells.north
	cells.north.adjacent.s = cells.center
	cells.center.links.n = centernlink
	cells.north.links.s = centernlink
	var centernwlink = Link.new([cells.center, cells.north], self, true)
	cells.center.adjacent.nw = cells.northwest
	cells.northwest.adjacent.se = cells.center
	cells.center.links.nw = centernwlink
	cells.northwest.links.se = centernwlink
	var centerwlink = Link.new([cells.center, cells.west], self)
	cells.center.adjacent.w = cells.west
	cells.west.adjacent.e = cells.center
	cells.center.links.w = centernwlink
	cells.west.links.e = centernwlink
	
	cells.center.squares.append(self)
	
	#~~
	
	w.cells.east = cells.west
	
	var westwlink = Link.new([cells.west, w.cells.center], w)
	cells.west.adjacent.w = w.cells.center
	w.cells.center.adjacent.e = cells.west
	cells.west.links.w = westwlink
	w.cells.center.links.e = westwlink
	
	var westnwlink = Link.new([cells.west, w.cells.north], w, true)
	cells.west.adjacent.nw = w.cells.north
	w.cells.north.adjacent.se = cells.west
	cells.west.links.nw = westnwlink
	w.cells.north.links.se = westnwlink
	
	var westnelink = Link.new([cells.west, cells.north], self, true)
	cells.west.adjacent.ne = cells.north
	cells.north.adjacent.sw = cells.west
	cells.west.links.ne = westnelink
	cells.north.links.sw = westnelink
	
	
	var westnlink = Link.new([cells.west, cells.northwest], self)
	cells.west.adjacent.n = cells.northwest
	cells.northwest.adjacent.s = cells.west
	cells.west.links.n = westnlink
	cells.northwest.links.s = westnlink
	
	var westswlink = Link.new([cells.west, sw.cells.north], sw, true)
	cells.west.adjacent.sw = sw.cells.north
	sw.cells.north.adjacent.ne = cells.west
	cells.west.links.sw = westswlink
	sw.cells.north.links.ne = westswlink
	
	cells.west.squares.append(self)
	cells.west.squares.append(w)
	
	#~~
	
	n.cells.southwest = cells.northwest
	w.cells.northeast = cells.northwest
	nw.cells.southeast = cells.northwest
	
	
	var northwestnelink = Link.new([cells.northwest, n.cells.center], n, true)
	n.cells.center.adjacent.sw = cells.northwest
	cells.northwest.adjacent.ne = n.cells.center
	cells.northwest.links.ne = northwestnelink
	n.cells.center.links.sw = northwestnelink
	
	
	var northwestnlink = Link.new([cells.northwest, n.cells.west], n)
	n.cells.west.adjacent.s = cells.northwest
	cells.northwest.adjacent.n = n.cells.west
	n.cells.west.links.s = northwestnlink
	cells.northwest.links.n = northwestnlink
	
	var northwestnwlink = Link.new([cells.northwest, nw.cells.center], nw, true)
	nw.cells.center.adjacent.se = cells.northwest
	cells.northwest.adjacent.nw = nw.cells.center
	nw.cells.center.links.se = northwestnwlink
	cells.northwest.links.nw = northwestnwlink
	
	var northwestswlink = Link.new([cells.northwest, w.cells.center], w, true)
	w.cells.center.adjacent.ne = cells.northwest
	cells.northwest.adjacent.sw = w.cells.center
	cells.northwest.links.sw = northwestswlink
	w.cells.center.links.ne = northwestswlink
	
	
	var northwestwlink = Link.new([cells.northwest, w.cells.north], w)
	w.cells.north.adjacent.e = cells.northwest
	cells.northwest.adjacent.w = w.cells.north
	w.cells.north.links.e = northwestwlink
	cells.northwest.links.w = northwestwlink
	
	var northwestelink = Link.new([cells.northwest, cells.north], self)
	cells.northwest.adjacent.e = cells.north
	cells.north.adjacent.w = cells.northwest
	cells.northwest.links.e = northwestelink
	cells.north.links.w = northwestelink
	
	cells.northwest.squares.append(self)
	cells.northwest.squares.append(n)
	cells.northwest.squares.append(w)
	cells.northwest.squares.append(nw)
	
	#~
	
	n.cells.south = cells.north
	
	var northnlink = Link.new([cells.north, n.cells.center], n)
	n.cells.center.adjacent.s = cells.north
	cells.north.adjacent.n = n.cells.center
	n.cells.center.links.s = northnlink
	cells.north.links.n = northnlink
	
	var northnwlink = Link.new([cells.north, n.cells.west], n, true)
	n.cells.west.adjacent.se = cells.north
	cells.north.adjacent.nw = n.cells.west
	n.cells.west.links.se = northnwlink
	cells.north.links.nw = northnwlink
	
	var northnelink = Link.new([cells.north, ne.cells.west], ne, true)
	cells.north.adjacent.ne = ne.cells.west
	ne.cells.west.adjacent.sw = cells.north
	cells.north.links.ne = northnelink
	ne.cells.west.links.sw = northnelink
	
	
	cells.north.squares.append(self)
	cells.north.squares.append(n)

func neighbors():
	return [n, ne, e, se, s, sw, w, nw]

func save():
	var save_dict = {
		"id": id,
		"x": x,
		"y": y,
		"content": content.save(),
	}
	if content == null:
		pass
	if save_dict.content == null:
		pass
	return save_dict

func load_save(savedata):
	id = savedata.id
	rules.assign_id(self)
	x = savedata.x
	y = savedata.y
	if data.blocks_to_load.has(savedata.content.datakey):
		var block = data.blocks_to_load[savedata.content.datakey]
		set_content(block)
	#load_content(savedata.content)
		
	
func load_content(savecontent):
	if savecontent.type == "floor":
		to_floor()
	elif savecontent.type == "wall":
		to_wall()
	elif savecontent.type == "edge":
		to_edge()

func make_block(blockdata):
	var newblock = blockscene.instantiate()
	newblock.load_data(blockdata)
	remove_child(content)
	content = newblock
	add_child(newblock)

func set_zone(zonename, zone):
	#if zones.has(zonename):
		#zones[zonename].remove_square(id)
	zones.merge({
		zonename: zone
	})
	

	#for key in squares:
		#var square = squares[key]
		#rect.size += square.inside.get_node("CollisionShape2D").shape.size

#0 = Tile is open
#1 = Tile has a door, is passable
#2 = Tile has a door the actor will destroy
#3 = Tile is impassable
#4 = Tile requires a task before passing
func can_navigate(unit):
	var clearances = unit.clearances
	if content.type() == "floor":
		var result: int = 3
		if footprint != null:
			if !footprint.content.built || footprint.content.dead:# || !footprint.content.collision:
				return 0
		if door != null:
			if !door.furniture.built || door.furniture.dead:
				return 0
			for layer in door.layers:
				if door.layers != []:
					for clearance in clearances:
						if door.layers.find(clearance) != -1:
							result = 1
				else:
					result = 1
			if result == 3:
				result = 2
		elif footprint != null:
			result = 3
		else:
			result = 0
		return result
	else:
		return 3
	
func _init():
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_parent()
	cells.center.x = x*2+1
	cells.center.y = y*2+1
	cells.west.x = x*2
	cells.west.y = y*2+1
	cells.north.x = x*2+1
	cells.north.y = y*2
	cells.northwest.x = x*2
	cells.northwest.y = y*2
	id = rules.assign_id(self)
	clear_nav()
	if content.type() == "floor":
		enabled = true
		await clear_nav()
	else:
		enabled = false
		await clear_nav()
	
func valid():
	var result = false
	for key in cells:
		var cell = cells[key]
		if cell != null:
			if cell.final_pos.size() == 0:
				result = true
	return result
	
func get_cell():
	return cells.center.get_movement(null)
	
func get_movement(checked = {}, checking = null):
	if checked == null:
		checked = {id: self}
	else:
		checked.merge({
			id: self
		})
	if content.type() == "floor" && footprint == null:
		if valid():
			return self
		else:
			var closest = null
			var closestweight = 999999999999999999
			if !checked.has(n.id):
				var nhas = n.get_movement(checked)
				if nhas != null:
					closest = nhas
					closestweight = global_position.distance_squared_to(nhas.global_position)
			if !checked.has(e.id):
				var ehas = e.get_movement(checked)
				if ehas != null:
					var distance = global_position.distance_squared_to(ehas.global_position)
					if distance < closestweight:
						closest = ehas
						closestweight = distance
			if !checked.has(s.id):
				var shas = s.get_movement(checked)
				if shas != null:
					var distance = global_position.distance_squared_to(shas.global_position)
					if distance < closestweight:
						closest = shas
						closestweight = distance
			if !checked.has(w.id):
				var whas = w.get_movement(checked)
				if whas != null:
					var distance = global_position.distance_squared_to(whas.global_position)
					if distance < closestweight:
						closest = whas
						closestweight = distance
			return closest
		return null
	else:
		return null
	
func type():
	return content.type()
	
func get_content():
	return content
	
func get_print():
	return footprint

func to_wall():
	var wall = wallscene.instantiate()
	remove_child(content)
	content = wall
	add_child(wall)
	if is_node_ready():
		enabled = false
	#selector.set_collision_mask_value(5, true)
	#selector.set_collision_layer_value(5, true)
	#selector.set_collision_mask_value(6, true)
	#selector.set_collision_layer_value(6, true)
	bake_navigation_polygon()
	
func to_edge():
	var edge = edgescene.instantiate()
	remove_child(content)
	content = edge
	add_child(edge)
	if is_node_ready():
		enabled = false
	#selector.set_collision_mask_value(5, true)
	#selector.set_collision_layer_value(5, true)
	#selector.set_collision_mask_value(6, true)
	#selector.set_collision_layer_value(6, true)
	bake_navigation_polygon()

func to_floor():
	var floor = floorscene.instantiate()
	remove_child(content)
	content = floor
	add_child(floor)
	remove_furniture()
	if is_node_ready():
		enabled = true
		await clear_nav()
	#selector.set_collision_mask_value(5, false)
	#selector.set_collision_layer_value(5, false)
	#selector.set_collision_mask_value(6, false)
	#selector.set_collision_layer_value(6, false)
	bake_navigation_polygon()
	
func to_furniture(furniture, collision):
	var newfootprint = printscene.instantiate()
	remove_child(footprint)
	newfootprint.assign_furniture(furniture)
	footprint = newfootprint
	#content = footprint
	add_child(footprint)
	containing = true
	if is_node_ready():
		enabled = false
		#clear_nav()
	selector.set_collision_mask_value(5, true)
	selector.set_collision_layer_value(5, true)
	selector.set_collision_mask_value(6, false)
	selector.set_collision_layer_value(6, false)
	bake_navigation_polygon()

func clear_nav():
	set_navigation_layer_value(1, true)
	for i in range(2, 33):
		set_navigation_layer_value(i, false)
	if door == null:
		set_navigation_layer_value(2, true)
	bake_navigation_polygon()

func add_door(newdoor):
	door = newdoor
	door.add_square(self)
	open_door()
	
func open_door():
	if door != null:
		await clear_nav()
		for layer in door.layers:
			set_navigation_layer_value(layer, false)
		set_navigation_layer_value(1, true)
		bake_navigation_polygon()
	
func close_door():
	if door != null:
		await clear_nav()
		for layer in door.layers:
			set_navigation_layer_value(layer, true)
		bake_navigation_polygon()

func remove_furniture():
	print(footprint)
	remove_child(footprint)
	footprint = null
	containing = false
	if is_node_ready():
		enabled = true
	bake_navigation_polygon()
	
func set_content(block):
	remove_child(content)
	content = blockscene.instantiate()
	content.load_data(block)
	add_child(content)


	
func set_pos(n, m):
	x = n
	y = m
	
func flip_tile():
	if(containing):
		remove_furniture()
		return
	if(content.type() == "wall" || footprint != null):
		to_floor()
	elif(content.type() == "floor"):
		to_wall()
	print("Tile Flipped at " + str(x) + ", " + str(y))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func entity():
	return "SQUARE"

func _on_diggable_area_entered(area):
	pass
	if(area.entity() == "UNIT"):
		can_interact.merge({area.id: area})
	#print("Can Dig after Enter: ")
	#print(can_dig)


func _on_diggable_area_exited(area):
	if(area.entity() == "UNIT"):
		if(can_interact.has(area.id)):
			can_interact.erase(area.id)
	#print("Can Dig after Exit")
	#print(can_dig)


func _on_inside_body_entered(body):
	body.current_square = self
	#if(body.entity() == "UNIT"):
		#units.merge({body.id: body})
		#body.current_square = self
		



func _on_inside_body_exited(body):
	pass
	#if body.entity() == "UNIT":
		#units.erase(body.id)


func _on_inside_area_entered(area: Area2D) -> void:
	area.current_square = self


func _on_inside_mouse_entered() -> void:
	var parent: Grid
	parent = get_parent()
	if(parent != null):
		parent.highlight_square(x, y)


func _on_inside_mouse_exited() -> void:
	var parent: Grid
	parent = get_parent()
	if(parent != null && parent.highlighted.x == x && parent.highlighted.y == y):
		parent.unhighlight()
