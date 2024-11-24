extends Panel

@onready var list = get_node("SortableList")

var sortables = [
	NameSortable.new(),
	LevelSortable.new(),
	CheckboxSortable.new()
]

var selected = {}

var possible = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_options(options):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_pressed():
	visible = false
