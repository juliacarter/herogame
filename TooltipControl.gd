extends Control

@onready var rules = get_node("/root/WorldVariables")

var timer = 1.0

var is_on = false

var tooltip = {
	"text": "blah blah blah"
}

#the currently active tooltip produced by this Area
var active_tooltip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func tooltip_cleared():
	pass

func _on_mouse_entered() -> void:
	#if active_tooltip == null:
	active_tooltip = rules.interface.make_tooltip(tooltip)
	active_tooltip.source = self
	if active_tooltip != null:
		active_tooltip.hovered = true
	is_on = true


func _on_mouse_exited() -> void:
	#if active_tooltip != null:
	active_tooltip.hovered = false
	if !active_tooltip.locked:
		active_tooltip.clear_tooltip()
	is_on = false
