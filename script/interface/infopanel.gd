extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var doom = get_node("OuterWindow/HFlowContainer/Control/DoomCounter")

#@onready var cashlabel = get_node("HFlowContainer/Cash")
@onready var minionlabel = get_node("OuterWindow/HFlowContainer/Control3/Minions")
@onready var researchnamelabel = get_node("OuterWindow/HFlowContainer/Control4/VBoxContainer/Label")

@onready var researchbar = get_node("OuterWindow/HFlowContainer/VBoxContainerControl4/Research")

#@onready var poslabel = get_node("OuterWindow/HFlowContainer/Control5/Cursorpos")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#cashlabel.text = "Cash: " + String.num(rules.player.intangibles.cash)
	minionlabel.text = "minions: " + String.num(rules.home.units.size())
	pass
