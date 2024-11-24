extends Control

signal row_toggled(row)
signal row_selected(row)

@onready var rules = get_node("/root/WorldVariables")

@onready var button = get_node("Contents/Buttons/SelectButton")

@onready var rowholder = get_node("Contents/RowMain/Row")

@onready var highlightrect = get_node("Contents/RowMain/Highlight")

@onready var checkbox = get_node("Contents/Buttons/CheckBox")

var displayscenes = {
	"TextSortableDisplay": load("res://text_sortable_display.tscn"),
	"TextButtonSortableDisplay": load("res://text_button_sortable_display.tscn"),
	"CheckboxSortableControl": load("res://checkbox_sortable_control.tscn"),
}

var displays = {
	
}

var sortables = []

var selected = false

var object

var selecting_for

var parent

func load_row(newobj, newsort):
	object = newobj
	sortables = newsort.duplicate()
	for sort in sortables:
		var display = displayscenes[sort.displayscene].instantiate()
		display.parent = self
		displays.merge({
			sort.title: display
		})
		rowholder.add_child(display)
		display.set_display(object, sort)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func highlight():
	highlightrect.visible = true
	#select()
	
func select():
	selected = true
	row_selected.emit(self)
	for key in displays:
		var display = displays[key]
		if display.selector:
			display.set_pressed(true)
	
func unhighlight():
	highlightrect.visible = false
	deselect()
			
func deselect():
	selected = false
	for key in displays:
		var display = displays[key]
		if display.selector:
			display.set_pressed(false)

func _on_select_button_pressed() -> void:
	pass
	#if selecting_for != null:
		#selecting_for.select(object)
		
func _on_view_button_pressed():
	rules.interface.open_window("singleunit")
	rules.interface.windows.singleunit.current_tab.load_unit(object)


func _on_row_body_button_pressed() -> void:
	if parent != null:
		parent.select(self)

func toggle(status):
	row_toggled.emit(self, status)
	#if parent != null:
		#parent.toggle(self, status)
		
func hardselect():
	if parent != null:
		parent.select(self)


func _on_check_box_toggled(toggled_on: bool) -> void:
	pass
