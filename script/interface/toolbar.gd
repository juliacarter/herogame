extends FlowContainer

@onready var data = get_node("/root/Data")

var toolscene = preload("res://scene/interface/tool_button.tscn")

var category


var tools = []

var is_open

# Called when the node enters the scene tree for the first time.
func _ready():
	is_open = visible
	
func open(status):
	is_open = status
	visible = status

func _exit_tree():
	for child in get_children():
		child.queue_free()
		
func load_tools(palette, newcategory):
	category = newcategory
	tools = palette
	var i = 0
	for tool in tools:
		var newtool = toolscene.instantiate()
		newtool.make_button(tool.object_name, tool.action, tool.args, i)
		i = i + 1
		add_child(newtool)
		queue_sort()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
