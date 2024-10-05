extends HBoxContainer
class_name PriceBox

@onready var content = get_node("Content")

var tagscene = load("res://price_tag.tscn")

var prices = {}
var tags = {}

func load_prices(newprices):
	for key in newprices:
		var amount = newprices[key]
		add_tag(key, amount)

func add_tag(type, amount):
	var tag = tagscene.instantiate()
	content.add_child(tag)
	tag.load_tag(type, amount)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
