extends Button
class_name EquipmentButton

signal equipment_pressed(item)

var parent

var unit

var slotname

var item

func load_item(new):
	item = new
	text = item.base.key

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_toggled(toggled_on):
	#parent.select(self)


func _on_pressed():
	equipment_pressed.emit(item)
	if unit != null:
		unit.unequip_and_drop(item)
#	if !button_pressed:
#		parent.select(self)
#	else:
#		button_pressed = false
