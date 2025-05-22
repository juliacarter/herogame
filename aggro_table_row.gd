extends HBoxContainer

@onready var namelabel = get_node("Name")
@onready var vallabel = get_node("Aggro")

func load_data(data):
	namelabel.text = data.item.nickname
	vallabel.text = String.num(data.cost)
