extends BoxContainer

#The variables displayed in the sortable table, and the associated TableCell type
var sortable_vars = {}
#Order of vars, from left to right
var var_order = []

#The var to sort by
var sorted_by = ""

#Rows, unsorted, organized by time added
var rows = []

#Rows post-sorting
var sorted_rows = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
