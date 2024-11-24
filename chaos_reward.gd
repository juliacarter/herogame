extends Reward
class_name ChaosReward


func _init(amount):
	count = amount
	function = "add_chaos"

func get_reward():
	return {
		"function": function,
		"args": [count]
	}
