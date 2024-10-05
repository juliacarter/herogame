extends HBoxContainer

@onready var number = get_node("StatBar/NumberVal")
@onready var title = get_node("StatBar/StatName")
@onready var bar = get_node("StatBar")


@onready var box = get_node("SpinBox")

var stat

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stat != null:
		box.max_value = stat.max
		bar.max_value = stat.max
		bar.value = stat.value
		number.text = String.num(stat.value) + "/" + String.num(stat.max)
		title.text = stat.title


func _on_button_pressed() -> void:
	stat.set_value(box.value)
