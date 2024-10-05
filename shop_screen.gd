extends Panel


@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")

@onready var grid = get_node("ScrollContainer/Content")

var map
var depot

var rowscene = load("res://shop_row.tscn")

var items = []
var buttons = []

var selling

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_buy()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func clear_options():
	for i in range(buttons.size()-1,-1,-1):
		var button = buttons[i]
		grid.remove_child(button)
		buttons.pop_at(i)
		items.pop_at(i)

func get_buy():
	var items = []
	for key in data.items:
		var item = data.items[key]
		var entry = ShopItemEntry.new(rules, item, 10)
		items.append(entry)
	for key in data.schemes:
		var scheme = data.schemes[key]
		var entry = ShopMissionEntry.new(rules, scheme, 10)
		items.append(entry)
	load_options(items, false)
	
func get_sell():
	var items = []
	for key in rules.home.stacks:
		var item = rules.home.stacks[key][0].base
		var entry = ShopItemSellEntry.new(rules, item, 10)
		items.append(entry)
	load_options(items, false)

func load_options(options, selling):
	clear_options()
	for option in options:
		var button = rowscene.instantiate()
		items.append(option)
		buttons.append(button)
		grid.add_child(button)
		button.load_item(option)


func _on_commit_pressed() -> void:
	pass
	#for button in buttons:
		#if !selling:
			#if button.desired > 0:
				#depot.depot_fill(button.item, button.desired)


func _on_sell_pressed() -> void:
	get_sell()
