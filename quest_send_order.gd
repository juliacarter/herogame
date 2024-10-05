extends SellOrder
class_name QuestSendOrder

var objective

func _init(gamerules, newobj):
	super(gamerules)
	objective = newobj


func order_item(base, amount):
	if desired_items.has(base.key):
		pass
	else:
		sell_point.request(base, amount, "quest")
		bases.merge({
			base.key: base
		})
		desired_items.merge({
			base.key: amount
		})
		
func send_items(base, count):
	sell_point.remove_item(base.id, count, "quest")
	var sold = objective.fulfil(count)
	return sold
		
func check_items():
	for key in desired_items:
		var count = desired_items[key]
		var base = bases[key]
		var has = sell_point.shelves.quest.has(base, count)
		if has != 0:
			var sold = send_items(base, has)
			if sent_items.has(key):
				sent_items[key] += sold
			else:
				sent_items.merge({
					key: sold
				})
			if sent_items[key] >= desired_items[key]:
				return true
	return false
