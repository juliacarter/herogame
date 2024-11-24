extends Objective
#Objective that is completed simply by having the right amount of the given resource.
class_name ResourceObjective

var amount
var resource = ""

func _init(args, newquest = null):
	super(args, newquest)
	resource = args.resource
	amount = args.amount
	
func get_log_text():
	if !completed:
		var has = rules.player.intangibles[resource]
		return resource + ": " + String.num(has) + "/" + String.num(amount)
	else:
		return resource + ": " + String.num(amount) + "/" + String.num(amount) + "!"

func status_function():
	var has = rules.player.intangibles[resource]
	return has >= amount
