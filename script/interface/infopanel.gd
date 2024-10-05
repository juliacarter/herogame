extends PanelContainer

@onready var rules = get_node("/root/WorldVariables")

#@onready var cashlabel = get_node("HFlowContainer/Cash")
@onready var minionlabel = get_node("HFlowContainer/Minions")
@onready var researchnamelabel = get_node("HFlowContainer/VBoxContainer/Label")

@onready var researchbar = get_node("HFlowContainer/VBoxContainer/Research")

@onready var poslabel = get_node("HFlowContainer/Cursorpos")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#cashlabel.text = "Cash: " + String.num(rules.player.intangibles.cash)
	if rules.current_map != null:
		if(rules.current_map.current != null):
			poslabel.text = String.num(rules.current_map.highlighted.x) + ", " + String.num(rules.current_map.highlighted.y)
		minionlabel.text = String.num(rules.current_map.units.size())
