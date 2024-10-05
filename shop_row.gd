extends HBoxContainer

@onready var namelabel = get_node("NameLabel")
#@onready var pricelabel = get_node("PriceLabel")
@onready var heatlabel = get_node("HeatLabel")

@onready var spinbox = get_node("SpinBox")

@onready var pricebox = get_node("PriceBox")

var item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_item(option):
	namelabel.text = option.name
	#pricelabel.text = String.num(option.prices.cash)
	heatlabel.text = String.num(option.heat)
	pricebox.load_prices(option.prices)
	item = option


func _on_buy_button_pressed() -> void:
	var count = spinbox.value
	item.buy_count(count)
