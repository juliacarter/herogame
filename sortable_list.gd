extends Control

@onready var sortbuttons = get_node("VBoxContainer/SortButtonRow")

@onready var rowholder = get_node("VBoxContainer/Control/ScrollContainer/Rows")

var rowscene = load("res://sortable_row.tscn")

#The variables displayed in the sortable table, and the associated TableCell type
var sortable_vars = {}
#Order of vars, from left to right
var var_order = []

#The var to sort by
var sorted_by = ""

var rows = []

var objects = []

var sortables = []

var selected = []

#panel to send selected objects to
var selecting_for

var sorting_by

signal select_row(row)

signal toggle_row(row, state)

func load_sortables(newobjects, newsortables):
	sortables = newsortables.duplicate()
	#objects = newobjects.duplicate()
	sortbuttons.load_sortables(sortables)
	await update_sortables(newobjects)
	
func update_sortables(newobj):
	clear_sortables()
	for obj in newobj:
		objects.append(obj)
		var row = rowscene.instantiate()
		row.parent = self
		row.selecting_for = selecting_for
		row.row_selected.connect(select)
		row.row_toggled.connect(toggle)
		rows.append(row)
		rowholder.add_child(row)
		row.load_row(obj, sortables)
		

		
func sort_pushed(sortable):
	if sorting_by == sortable:
		sortable.ascending = !sortable.ascending
	sort_by(sortable)
		
#func toggle_sort(sortable):
	
		
func sort_by(sortable):
	sorting_by = sortable
	var sorted = sortable.sort(rows)
	var objects = []
	for row in sorted:
		objects.append(row.object)
	update_sortables(objects)

func clear_sortables():
	for i in range(rows.size()-1,-1,-1):
		var row = rows[i]
		rowholder.remove_child(row)
		rows.pop_at(i)
		objects.pop_at(i)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sortbuttons.parent = self

func add_selection(row):
	var i = selected.find(row)
	if i == -1:
		selected.append(row)
	row.highlight()
	
func remove_selection(row):
	var i = selected.find(row)
	if i != -1:
		selected.pop_at(i)
	row.unhighlight()

func clear_selection():
	for i in range(selected.size()-1,-1,-1):
		var row = selected[i]
		selected.pop_at(i)
		row.unhighlight()

func select(row):
	clear_selection()
	selected = [row]
	row.highlight()
	select_row.emit(row)
	
func toggle(row, state):
	if state:
		add_selection(row)
	else:
		remove_selection(row)
	toggle_row.emit(row, state)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
