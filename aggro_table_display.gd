extends Control

@onready var table = get_node("ScrollContainer/Table")
var rows = []

var rowscene = load("res://aggro_table_row.tscn")

var aggro

func load_aggro(new):
	clear_aggro()
	aggro = new
	for data in aggro.table.items:
		var row = rowscene.instantiate()
		table.add_child(row)
		row.load_data(data)
		rows.append(row)
		
func clear_aggro():
	if rows != []:
		for i in range(rows.size(),-1,-1):
			var row = rows[i]
			table.remove_child(row)
			rows.pop_at(i)
