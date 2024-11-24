extends Reward
class_name ItemReward

var item = ""

func _init(args = {}):
	if args.has("item"):
		item = args.item
	if args.has("amount"):
		count = args.amount
	function = "spawn_item_at_depot"

func get_reward():
	return {
		"function": function,
		"args": [item, count]
	}
