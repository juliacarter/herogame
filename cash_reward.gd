extends Reward
class_name CashReward


func _init(args = {}):
	if args.has("amount"):
		count = args.amount
	function = "add_cash"

func get_reward():
	return {
		"function": function,
		"args": [count]
	}
