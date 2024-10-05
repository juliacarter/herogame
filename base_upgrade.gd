extends Object
class_name BaseUpgrade

var title = "lesson"

var time = 0
var time_per_scaling = 0

var key

var type = "lesson"
var limit = "unlimited"

var article

var taught_by

var triggers = {}

var abilities = {}

var itemcost = {}
var item_per_scaling = {}

var manacost = {}
var mana_per_scaling = {}

func _init(data):
	if data.has("time"):
		time = data.time
	if data.has("limit"):
		limit = data.limit
	if data.has("type"):
		type = data.type
	if data.has("article"):
		article = data.article
	if data.has("manacost"):
		manacost = data.manacost.duplicate()
	if data.has("mana_per_scaling"):
		mana_per_scaling = data.mana_per_scaling.duplicate()
	if data.has("time_per_scaling"):
		time_per_scaling = data.time_per_scaling
	else:
		time = 2
	if data.has("taught_by"):
		taught_by = data.taught_by
	if data.has("name"):
		title = data.name
		
#Calculate the cost of an upgrade based on scaling, then return
func get_cost(scaling):
	pass
		
func name():
	return title
