extends Button
class_name EquipmentButton

var parent

var slotname

var base

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_toggled(toggled_on):
	#parent.select(self)


func _on_pressed():
	parent.open_equipmentpicker(slotname)
#	if !button_pressed:
#		parent.select(self)
#	else:
#		button_pressed = false
