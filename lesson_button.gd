extends VFlowContainer
class_name LessonButton

@onready var rules = get_node("/root/WorldVariables")
@onready var button = get_node("Button")
@onready var bar = get_node("ProgressBar")

var panel

var item
var unit

var type = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if item != null:
		if item is Lesson:
			bar.value = item.time_left

func load_item(newlesson):
	item = newlesson
	if newlesson is Lesson:
		button.text = item.base.name()
		bar.max_value = item.base.time
		bar.visible = true
	else:
		button.text = item.name()


func _on_button_pressed() -> void:
	if item == null:
		panel.open_upgradepicker(type)
	elif item is Lesson:
		rules.interface.view_article(item.article)
	elif item is BaseUpgrade:
		rules.interface.view_article(item.article)
