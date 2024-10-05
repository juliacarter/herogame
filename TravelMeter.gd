extends ProgressBar

var transport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if transport != null:
		max_value = transport.distance
		value = transport.timer
		
func load_transport(new):
	transport = new
