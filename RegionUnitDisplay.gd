extends HFlowContainer

var buttonscene = load("res://region_unit_button.tscn")

var region

var buttons = []

func clear_buttons():
	for i in range(buttons.size()-1,-1,-1):
		var button = buttons[i]
		remove_child(button)
		buttons.pop_at(i)
		
func load_region(new):
	region = new
	load_units()
	
		
func load_units():
	if region != null:
		clear_buttons()
		for key in region.units:
			var unit = region.units[key]
			var button = buttonscene.instantiate()
			buttons.append(button)
			add_child(button)
			button.load_unit(unit)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
