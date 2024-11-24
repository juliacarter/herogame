extends VBoxContainer

@onready var rules = get_node("/root/WorldVariables")

var rowscene = load("res://resource_row.tscn")

var rows = []

var finders = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finders = [IntangibleResourceFinder.new(rules, "cash"), ItemResourceFinder.new(rules, "metal")]
	load_resources()

func load_resources():
	for finder in finders:
		var row = rowscene.instantiate()
		add_child(row)
		rows.append(row)
		row.load_counter(finder)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
