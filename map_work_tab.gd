extends Button
class_name MapWorkTab

@onready var rules = get_node("/root/WorldVariables")

@onready var transportbars = get_node("TransportBars")

@onready var prog = get_node("ProgressBar")

var transports = {}

var barscene = load("res://travel_meter.tscn")

var worksite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if worksite != null:
		prog.max_value = worksite.speed
		prog.value = worksite.time

func load_map(new):
	worksite = new
	worksite.tab = self
	text = "MAPTAB" + worksite.id
	
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
