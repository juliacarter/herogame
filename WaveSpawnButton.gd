extends Button

var panel
var wave

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_wave(new):
	wave = new
	text = wave.key


func _on_pressed() -> void:
	panel.spawn_wave(wave)
