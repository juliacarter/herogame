extends Node2D
class_name MovementArea

@onready var rules = get_node("/root/WorldVariables")

var layers = {
	"0": true,
}

var x
var y

var id

var adjacent = {
	"n": null,
	"ne": null,
	"e": null,
	"se": null,
	"s": null,
	"sw": null,
	"w": null,
	"nw": null,
}

var links = {
	"c": null,
	"n": null,
	"ne": null,
	"e": null,
	"se": null,
	"s": null,
	"sw": null,
	"w": null,
	"nw": null,
}

var units = {}

#Units that have this cell as their final position
var final_pos = {}

var squares = []

func valid():
	var result = false
	for square in squares:
		if square.valid():
			result = true
	return result

func get_movement(checked = {}):
	if final_pos.size() == 0:
		if valid():
			return self
	if checked != null:
		checked.merge({
			id: self
		})
	else:
		checked = {
			id: self
		}
	for key in adjacent:
			var cell = adjacent[key]
			var link = links[key]
			if cell != null:
				if !checked.has(cell.id):
					if cell.final_pos.size() == 0:
						if link.square.valid():
							return cell
	for key in adjacent:
			var cell = adjacent[key]
			var link = links[key]
			if cell != null:
				if !checked.has(cell.id):
					if link.square.valid():
						var move = cell.get_movement(null)
						if move != null:
							return move
	return null

func layer_insert(layer, astar):
	astar.add_point(id, position)
	layers.merge({
		layer: astar
	}, true)
	
func layer_remove(layer):
	layers[layer].remove_point(id)
	layers.erase(layer)

func neighbors():
	var result = {}
	for key in adjacent:
		if adjacent[key] != null:
			result.merge({
				key: adjacent[key]
			})
	return result
	
func can_navigate(unit):
	var can = 0
	for square in squares:
		var result = square.can_navigate(unit)
		if result > can:
			can = result
	return can

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	id = rules.assign_id(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
