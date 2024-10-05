extends Object
#a recharging buyable that gives a Quest when bought
class_name Scheme

var data

var cooldown = 10
var time = 0

var quest = ""

func _init(gamedata, args):
	if args.has("quest"):
		quest = args.quest
	if args.has("cooldown"):
		cooldown = args.cooldown
