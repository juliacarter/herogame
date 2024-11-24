extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var testregion = get_node("MapRegion")

@onready var pinholder = get_node("GridContainer")

var pinscene = load("res://map_pin.tscn")

var missions = []

var jobs = []

var pins = []

var mission_pins = []
var job_pins = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	testregion.region.think(delta)

func load_regions():
	var region = Region.new(rules, {})
	region.id = rules.assign_id(region)
	testregion.load_region(region)
	
func add_location(loc):
	var pin = add_pin(loc.pindata)
	loc.pin = pin
	pin.map = self
	
func add_pin(pindata):
	var pin = pinscene.instantiate()
	pins.append(pin)
	pinholder.add_child(pin)
	pin.load_data(pindata)
	return pin
	
func remove_pin(pin):
	var i = pins.find(pin)
	if i != -1:
		pins.pop_at(i)
		pinholder.remove_child(pin)
	
