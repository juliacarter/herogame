extends CheckBox

@onready var rules = get_node("/root/WorldVariables")

var varname = ""

var value = false

func load_var(new):
	if rules.debugvars.has(new):
		varname = new
		text = varname
		value = rules.debugvars[new]
		button_pressed = value
	else:
		varname = "error"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_toggled(toggled_on: bool) -> void:
	rules.debugvars[varname] = toggled_on
