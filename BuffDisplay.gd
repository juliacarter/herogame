extends HBoxContainer



var buffscene = load("res://buff_button.tscn")

var buttons = {
	
}

var unit

func load_unit(new):
	unit = new
	unit.buff_update.connect(refresh_buffs)
	refresh_buffs()
	
func refresh_buffs():
	if unit != null:
		load_buffs(unit.buffs)

func clear_buffs():
	var to_remove = []
	for key in buttons:
		var new = buttons[key]
		for button in new:
			remove_child(button)
		to_remove.append(key)
	for key in to_remove:
		buttons.erase(key)

func load_buffs(new):
	clear_buffs()
	for buff in new:
		var button = buffscene.instantiate()
		buttons.merge({
			buff.base.name: []
		})
		buttons[buff.base.name].append(button)
		add_child(button)
		button.load_buff(buff)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
