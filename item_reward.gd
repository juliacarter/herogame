extends Reward
class_name ItemReward

var item = ""
var amount = 12345

func _init(args = {}):
	if args.has("item"):
		item = args.item
	if args.has("amount"):
		amount = args.amount
	function = "spawn_item_at_depot"

func get_reward():
	return {
		"function": function,
		"args": [item, amount]
	}
