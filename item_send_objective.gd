extends Objective
class_name ItemSendObjective

#the key of the item to send
var item

var count = 0

var sent = 0

func _init(args):
	super(args)
	if args.has("item"):
		if rules.data.items.has(args.item):
			item = rules.data.items[args.item]
	if args.has("amount"):
		count = args.amount
	
func fulfil(amt):
	sent += amt
	return amt
		
func status_function():
	return sent >= count
	
func can_fire():
	return true
	
#On fire, make a new QuestSend order
func fire():
	rules.send_quest_item(item, count, self)
