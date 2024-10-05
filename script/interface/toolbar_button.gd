extends Button

var category = "blah"

var interface

# Called when the node enters the scene tree for the first time.
func _ready():
	text = category


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	interface.rules.stop_casting()
	interface.open_bar(category)
