@tool
extends Object
class_name FurnitureData

var object_name = "Doohickey"
var size = {"x": 1, "y": 1}
var spots = {}
var angle = 0
var sprite_path
var model_path
var type
var category

var depot

var power = 0

var tags = []
var shelves = []

var jobdata = []

var teaches = []

var unlocked = false

var needs_build = true

var manual

var collision = true

var prison = false

var spyheat = 0

var trapdata = {}

var camdata = {}

var spotters = []

var datakey

func _init(data):
	sprite_path = data.spritepath
	var image = Image.load_from_file("res://art/" + sprite_path + ".png")
	if(image == null):
		sprite_path = "caution"
		
	if data.has("spyheat"):
		spyheat = data.spyheat
		
	if data.has("prison"):
		prison = data.prison
		
	if data.has("trap"):
		trapdata = data.trap
		
	if data.has("camera"):
		camdata = data.camera
		
	if data.has("needs_build"):
		needs_build = data.needs_build
		
	if data.has("spotters"):
		spotters = data.spotters
	
	if data.has("manual"):
		manual = data.manual
	else:
		manual = true
	if data.has("collision"):
		collision = data.collision
	
	if data.has("spots"):
		for key in data.spots:
			var spotcat = []
			for spot in data.spots[key]:
				var newspot = {}
				for val in spot.keys():
					newspot.merge({val: spot.get(val)})
				spotcat.append(newspot)
			spots.merge({
				key: spotcat
			})
	var inputshelf = Shelf.new({
		"name": "input"
	})
	
	shelves.append({"name": "input"})
	shelves.append({"name": "output"})
	if(data.has("shelves")):
		var newshelves = data.get("shelves")
		for shelf in newshelves:
			shelves.append(shelf)
	if data.has("teaches"):
		for key in data.teaches:
			teaches.append(key)
	size = data.size
	if data.has("power"):
		power = data["power"]
	else:
		power = 0
	depot = false
	if data.has("depot"):
		depot = data["depot"]
	object_name = data.object_name
	type = data.type
	category = data.category
