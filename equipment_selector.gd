extends Panel

@onready var data = get_node("/root/Data")
@onready var grid = get_node("GridContainer")

var buttonscene = load("res://equipment_button.tscn")

var parent

var buttons = []

var selected

var slot

var group = ButtonGroup.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func load_options(newslot):
	visible = true
	slot = newslot
	for base in data.items:
		if data.items[base].type == "equipment":
			if newslot == data.items[base].slot:
				var newitem = buttonscene.instantiate()
				newitem.button_group = group
				newitem.parent = self
				newitem.base = data.items[base]
				newitem.text = newitem.base.itemname
				grid.add_child(newitem)
				buttons.append(newitem)



func _on_confirm_pressed():
	selected = group.get_pressed_button()
	pass
	parent.request_equipment(selected.base, slot)


func _on_close_pressed():
	visible = false
