extends Object
class_name BaseUpgrade

var data

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

var prerequisites = []

#tags provided to the unit by this upgrade
var points = {}

#whether or not the upgrade can be acquired via level up
var learnable = false

func check_prerequisites(unit):
	var result = true
	for prereq in prerequisites:
		var can = prereq.check_against(unit)
		if !can:
			result = false
	return result

func _init(gamedata, upgradedata):
	data = gamedata
	if upgradedata.has("time"):
		time = upgradedata.time
	if upgradedata.has("limit"):
		limit = upgradedata.limit
	if upgradedata.has("type"):
		type = upgradedata.type
	if upgradedata.has("article"):
		article = upgradedata.article
	if upgradedata.has("manacost"):
		manacost = upgradedata.manacost.duplicate()
	if upgradedata.has("learnable"):
		learnable = upgradedata.learnable
	if upgradedata.has("points"):
		points = upgradedata.points.duplicate()
	if upgradedata.has("prerequisites"):
		var prereqs = upgradedata.prerequisites
		for prereqdata in prereqs:
			var prereq = data.make_prereq(prereqdata)
			if prereq != null:
				prerequisites.append(prereq)
	if upgradedata.has("mana_per_scaling"):
		mana_per_scaling = upgradedata.mana_per_scaling.duplicate()
	if upgradedata.has("time_per_scaling"):
		time_per_scaling = upgradedata.time_per_scaling
	else:
		time = 2
	#if upgradedata.has("tags"):
		#tags = upgradedata.tags.duplicate()
	if upgradedata.has("taught_by"):
		taught_by = upgradedata.taught_by
	if upgradedata.has("name"):
		title = upgradedata.name
		
#Calculate the cost of an upgrade based on scaling, then return
func get_cost(scaling):
	pass
		
func name():
	return title
