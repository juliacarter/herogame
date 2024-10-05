extends Panel

@onready var rules = get_node("/root/WorldVariables")
@onready var namebox = get_node("NameBox")
@onready var idbox = get_node("IdBox")
@onready var sizebox = get_node("SizeLabel")
@onready var prog = get_node("ProgressBar")
@onready var resourcelist = get_node("Resources")

@onready var jobbutton = get_node("JobButton")

@onready var clearancewheel = get_node("Clearance")

var interface

var furniture

var resourcelabels = {}
var items
var neededitems

# Called when the node enters the scene tree for the first time.
func _ready():
	interface = rules.interface
	if(interface.selected != null):
		if(interface.selected.entity() == "FURNITURE"):
			furniture = interface.selected
			if interface.selected.door != null:
				clearancewheel.visible = true
				clearancewheel.value = interface.selected.door.layers[0]
			else:
				clearancewheel.visible = false
			$RepeatBox.button_pressed = interface.selected.repeating
			if(interface.selected.job != null):
				items = interface.selected.allitems()
				neededitems = interface.selected.job.neededitems
				for item in neededitems.keys():
					var label = Label.new()
					var has = 0
					var needs = neededitems.get(item)
					if(items.has(item)):
						has = rules.selected.count(item)
					label.text = item.itemname + ": " + String.num(has) + "/" + String.num(needs)
					resourcelabels.merge({item: label})
					resourcelist.add_child(label)
			
					


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	namebox.text = interface.selected.object_name
	idbox.text = interface.selected.id
	sizebox.text = "X: " + String.num(interface.selected.size.x) + " Y: " + String.num(interface.selected.size.y)
	if(interface.selected != null):
		jobbutton.visible = interface.selected.manual
		if(interface.selected.job != null):
			prog.max_value = interface.selected.job.speed
			prog.value = interface.selected.job.time
			for resource in resourcelabels.keys():
				if(items.has(resource)):
					var has = 0
					var needs = neededitems.get(resource)
					if(items.has(resource)):
						has = items.get(resource)
					var newlabel = resource + ": " + String.num(has) + "/" + String.num(needs)
					resourcelabels.get(resource).text = newlabel
					resourcelabels.merge({resource: newlabel})


func _on_job_button_pressed():
	if(interface.selected != null):
		if(interface.selected.entity() == "FURNITURE"):
			await interface.open_window("furniturejobs")
			interface.windows.furniturejobs.load_furniture(interface.selected)


func _on_right_button_pressed():
	if(interface.selected != null):
		if(interface.selected.entity() == "FURNITURE"):
			interface.selected.rotate(deg_to_rad(90))


func _on_left_button_pressed():
	if(interface.selected != null):
		if(interface.selected.entity() == "FURNITURE"):
			interface.selected.rotate(deg_to_rad(-90))


func _on_repeat_box_toggled(button_pressed):
	if(interface.selected != null):
		if(interface.selected.entity() == "FURNITURE"):
			interface.selected.repeating = button_pressed
			interface.selected.job.repeating = button_pressed


func _on_haul_button_pressed():
	if(interface.selected != null):
		if(interface.selected.entity() == "FURNITURE"):
			await interface.selected.fill_up()


func _on_button_2_pressed():
	if(interface.selected != null):
		if(interface.selected.entity() == "FURNITURE"):
			await interface.selected.sell_storage()


func _on_button_pressed():
	rules.interface.open_window("furninventory")
	rules.interface.windows.furninventory.current_tab.set_furniture(interface.selected)


func _on_clearance_value_changed(value: float) -> void:
	interface.selected.door.change_clearance(value)


func _on_delete_button_pressed() -> void:
	await furniture.map.remove_furniture(furniture.id)
