extends Button

@onready var namelabel = get_node("HBoxContainer/Name")
@onready var countlabel = get_node("HBoxContainer/Count")

var reward

func load_reward(new):
	reward = new
	namelabel.text = reward.object_name()
	countlabel.text = String.num(reward.count)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
