extends VBoxContainer

@onready var rules = get_node("/root/WorldVariables")

@onready var textedit = get_node("TextEdit")
@onready var historylabel = get_node("RichTextLabel")

var history = []

var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ENTER:
			execute()

func activate(toggle):
	textedit.text = ""
	active = toggle
	visible = active

func execute():
	var commandstring = textedit.text
	var commanddelim = commandstring.split(" ")
	var args = []
	var action = commanddelim[0]
	commanddelim.remove_at(0)
	for arg in commanddelim:
		arg = arg.strip_edges()
		args.append(arg)
	textedit.text = ""
	action = action.strip_edges()
	print_line(commandstring)
	#if rules.has_method(action):
		#pass
	rules.callv(action, args)

func print_line(line):
	history.append(line)
	var newtext = "\n" + line
	historylabel.add_text(newtext)
