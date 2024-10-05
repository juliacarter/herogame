extends Reward
class_name CashReward

var amount = 12345

func _init(args = {}):
	if args.has("amount"):
		amount = args.amount
	function = "add_cash"

func get_reward():
	return {
		"function": function,
		"args": [amount]
	}
