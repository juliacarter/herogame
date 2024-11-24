extends Control

@onready var grid = get_node("GridContainer")

var buttonscene = load("res://reward_button.tscn")

var rewards = []

var quest

func clear_rewards():
	for i in range(rewards.size()-1,-1,-1):
		var button = rewards[i]
		grid.remove_child(button)
		rewards.pop_at(i)

func load_quest(new):
	clear_rewards()
	quest = new
	for reward in quest.rewards:
		var button = buttonscene.instantiate()
		rewards.append(button)
		grid.add_child(button)
		button.load_reward(reward)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
