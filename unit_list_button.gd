extends Button

var panel

var item

var type = "unit"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_item(newunit):
	item = newunit
	text = item.object_name()
	#else:
	#	button.text = unit.name()


		
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if item == null:
					panel.open_unitpicker()
			MOUSE_BUTTON_RIGHT:
				panel.remove_unit(item)
