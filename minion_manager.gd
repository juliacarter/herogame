extends Panel

var interface

var classscene = load("res://class_editor.tscn")
var unitscene = load("res://unit_list.tscn")
var squadscene = load("res://squad_screen.tscn")

var views = {
	"classes": classscene.instantiate(),
	"units": unitscene.instantiate(),
	"squads": squadscene.instantiate(),
}

@onready var panel = get_node("Panel")

var selected_panel


# Called when the node enters the scene tree for the first time.
func _ready():
	views.squads.mainscene = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func open_view(view):
	panel.remove_child(selected_panel)
	selected_panel = views[view]
	panel.add_child(selected_panel)
	
	


func _on_classes_pressed():
	open_view("classes")
	views.classes.initial_open()

func _on_units_pressed():
	open_view("units")


func _on_squads_pressed():
	open_view("squads")
	views.squads.get_options()


func _on_close_pressed():
	interface.close_window()
