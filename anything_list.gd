extends GridContainer
class_name AnythingList


var lessonscene = load("res://lesson_button.tscn")
var abilityscene = load("res://ability_button.tscn")
var unitscene = load("res://unit_selector.tscn")

var type = ""

var panel

var inserter = false

var buttons = []
var unit
var items = []

signal modified

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func load_unit(newunit):
	#load_lessons(null)
	
func clear_items():
	for i in range(buttons.size()-1,-1,-1):
		var button = buttons[i]
		remove_child(button)
		buttons.pop_at(i)
	
func load_items(newlessons, newtype, insert = true):
	type = newtype
	var buttonscene
	if type == "lesson" || type == "augment":
		buttonscene = lessonscene
	elif type == "abilities":
		buttonscene = abilityscene
	elif type == "units":
		buttonscene = unitscene
	clear_items()
	if insert:
		inserter = true
		var addbutton = buttonscene.instantiate()
		addbutton.type = type
		addbutton.panel = panel
		await add_child(addbutton)
		buttons.append(addbutton)
	else:
		inserter = false
	for lesson in newlessons:
		var button = buttonscene.instantiate()
		button.type = type
		button.panel = panel
		await add_child(button)
		button.load_item(lesson)
		buttons.append(button)
	queue_redraw()
	queue_sort()
	modified.emit()
		
func return_items():
	var result = []
	for button in buttons:
		if button.item != null:
			result.append(button.item)
	return result


func _on_sort_children() -> void:
	modified.emit() # Replace with function body.
