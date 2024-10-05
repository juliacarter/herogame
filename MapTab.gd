extends Button

@onready var rules = get_node("/root/WorldVariables")

@onready var transportbars = get_node("TransportBars")

var transports = {}

var barscene = load("res://travel_meter.tscn")

var map

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_map(newmap):
	map = newmap
	map.tab = self
	text = "MAPTAB" + map.id

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_transport(new):
	if !transports.has(new.id):
		var transport = barscene.instantiate()
		transportbars.add_child(transport)
		transport.load_transport(new)
		transports.merge({
			new.id: transport
		})
		
	pass
	
func remove_transport(old):
	if transports.has(old.id):
		var bar = transports[old.id]
		transportbars.remove_child(bar)
		transports.erase(old.id)

func _on_pressed():
	rules.open_map(map.id)
