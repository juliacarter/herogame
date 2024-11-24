extends Control

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")

@onready var grid = get_node("OuterWindow/InnerWindow/GridContainer")

var itemscene = load("res://pickable_item.tscn")

signal equipment_picked(item)
signal picker_closed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open():
	visible = true
	load_equipment()
	
func load_equipment():
	for key in data.items:
		var base = data.items[key]
		if rules.home.stacks.has(base.id):
			var button = itemscene.instantiate()
			button.item_picked.connect(pick_equipment)
			grid.add_child(button)
			button.set_item(base)

func pick_equipment(item):
	equipment_picked.emit(item)

func _on_button_pressed() -> void:
	picker_closed.emit()
	visible = false
