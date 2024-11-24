extends Panel

@onready var titlelabel = get_node("DragBar/HBoxContainer2/WindowTitle")

@onready var dragbar = get_node("DragBar")
@onready var tabbar = get_node("Tabs")
@onready var tabs = get_node("Tabs/ScrollContainer/TabHolder")

@onready var content = get_node("Content")

@onready var resizetab = get_node("ResizeDragger")

var tabscene = load("res://tab.tscn")

var parent

var resizing = false

var dragging = false
var dragging_from = Vector2(0, 0)

var resizable = false
var tabbed = true

var padding = 50

var outer

var upper

var current_tab

var minsize: Vector2

var dimensions = {
	"x": 0,
	"y": 0,
}

var tabbuttons = []
var tabcontents = []

var windowname = ""

var z = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if resizable:
		resizetab.visible = true
	if tabbed:
		tabbar.visible = true
		padding = 100
	#content.position = Vector2(16, padding)
	apply_minimum_size(size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if resizing:
		#Size is upper.globalpos - outer.globalpos
		outer = get_global_mouse_position()
		var trysize = (global_position - outer) * -1
		var newsize = size
		if trysize.x > minsize.x:
			newsize.x = trysize.x
		if trysize.y > minsize.y:
			newsize.y = trysize.y
		if newsize > minsize:
			pass
			apply_size(newsize)
	if dragging:
		global_position = get_global_mouse_position() - dragging_from

func apply_x(x):
	apply_size(Vector2(x, size.y))
	
func apply_y(y):
	apply_size(Vector2(size.x, y))

func apply_size(newsize):
	size = newsize + Vector2(8, 8)
	#if current_tab != null:
		#current_tab.size = newsize - Vector2(0, padding)
	dragbar.size.x = size.x-8
	tabbar.size.x = size.x-8

func apply_minimum_size(newsize):
	minsize = newsize
	apply_size(minsize)

func create_tab(newtab):
	
	var tab = tabscene.instantiate()
	var tabtitle = newtab.get("tabtitle")
	if tabtitle != null:
		tab.set_title(tabtitle)
	tabcontents.append(newtab)
	tab.parent = self
	tab.index = tabbuttons.size()
	tabbuttons.append(tab)
	tabs.add_child(tab)
	if current_tab == null:
		open_tab(newtab)

func open_tab(newtab):
	content.remove_child(current_tab)
	content.add_child(newtab)
	var tabtitle = newtab.callv("get_window_title", [])
	if tabtitle != null:
		titlelabel.text = tabtitle
	current_tab = newtab
	apply_minimum_size(newtab.size + Vector2(0, padding))


func _on_resize_dragger_button_down() -> void:
	resizing = true

func open_tab_index(index):
	if index < tabcontents.size():
		var tab = tabcontents[index]
		open_tab(tab)

func to_top():
	get_parent().get_parent().window_to_top(self)

func _on_resize_dragger_button_up() -> void:
	resizing = false


func _on_drag_bar_button_down() -> void:
	dragging = true
	to_top()

func start_drag():
	dragging = true
	
	


func _on_drag_bar_button_up() -> void:
	dragging = false


func close() -> void:
	if current_tab != null:
		if current_tab.has_method("close"):
			current_tab.close()
	get_parent().get_parent().close_window(windowname)


func _on_drag_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			dragging_from = event.position
			dragging = true
			to_top()
		else:
			dragging = false


func _on_close_button_button_up() -> void:
	close()


func _on_close_button_button_down() -> void:
	pass # Replace with function body.
