extends Node2D

@onready var rules = get_node("/root/WorldVariables")

@onready var testregion = get_node("MapRegion")

var missions = []

var jobs = []

var mission_pins = []
var job_pins = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	testregion.region.think(delta)

func load_regions():
	var region = Region.new()
	region.id = rules.uuid(region)
	testregion.load_region(region)
