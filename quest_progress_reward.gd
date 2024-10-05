extends Reward
class_name QuestProgressReward

var objective

func _init(newobj):
	objective = newobj
	
func get_reward():
	return {
		"function": "progress_objective",
		"args": [objective, 1]
	}
