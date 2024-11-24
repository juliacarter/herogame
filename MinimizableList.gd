extends Control
class_name MinimizableList

@onready var button = get_node("OpenClose")
@onready var label = get_node("Name")
@onready var content = get_node("Content")

var items = []

var opened = false

var parent

signal modified

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func load_items(newitems):
	close()
	items = []
	for item in newitems:
		items.append(item)
		#item.modified.connect(calc_size)
		if parent != null:
			item.parent = parent
	open()
		
func open():
	opened = true
	button.text = "-"
	for item in items:
		content.add_child(item)
	calc_size()
	#content.queue_sort()
	
func close():
	opened = false
	button.text = "+"
	for item in items:
		content.remove_child(item)
	calc_size()
	#content.queue_sort()

func load_text(newtext):
	label.text = newtext
	
func calc_size():
	var newsize = Vector2(200, 100)
	if opened:
		for item in items:
			newsize += Vector2(0, item.size.y)
	#set_custom_minimum_size(newsize)
	modified.emit()
	
func _on_open_close_pressed() -> void:
	if opened:
		close()
	else:
		open()
