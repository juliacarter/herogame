extends Reward
class_name DoomReward

var phase

func _init(new):
	phase = new
	function = "add_doom_to_phase"

func get_reward():
	return {
		"function": function,
		"args": [phase]
	}
