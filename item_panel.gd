extends Panel
class_name ItemPanel

@onready var rules = get_node("/root/WorldVariables")

@onready var namebox = get_node("NameBox")
@onready var idbox = get_node("IdBox")

@onready var countlabel = get_node("Count")
@onready var reservedlabel = get_node("Reserved")

var interface

var item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interface = rules.interface
	if(interface.selected != null):
		if(interface.selected.entity() == "FLOORSTACK"):
			item = interface.selected.item

func _process(delta):
	if item != null:
		namebox.text = item.base.itemname
		idbox.text = item.id
		if(interface.selected != null):
			countlabel.text = String.num(item.count)
			reservedlabel.text = String.num(item.reserved_count)
