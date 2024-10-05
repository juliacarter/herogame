extends Job
class_name Lesson


var base: BaseUpgrade

var time_left

var actor

var effect = {}

var task: Task

var site: Furniture

#Set true after resources have been requested
var ordered = false
#Set true when a site has been found & resources delivered
var begun = false

var scaled_items = {}
var scaled_mana = {}

func calc_scaling(scale):
	scaled_items = base.itemcost.duplicate(true)
	scaled_mana = base.manacost.duplicate(true)
	time_left = base.time
	time_left += base.time_per_scaling * scale
	for item in base.item_per_scaling:
		var cost = base.item_per_scaling[item] * scale
		if scaled_items.has(item):
			scaled_items[item] += cost
		else:
			scaled_items.merge({
				item: cost
			})
	for mana in base.mana_per_scaling:
		var cost = base.mana_per_scaling[mana] * scale
		if scaled_mana.has(mana):
			scaled_mana[mana] += cost
		else:
			scaled_mana.merge({
				mana: cost
			})

func can_learn():
	if base.itemcost == {}:
		var furn = find_site()
		return furn != null
		#return true
	if !ordered:
		var has_resources = resources_available()
		if has_resources:
			order_resources()
			ordered = true
		return false
	else:
		var can = resources_ready()
		if can:
			var furn# = find_site()
			if site == null:
				furn = find_site()
			else:
				furn = site
			return furn != null
		else:
			return false

#Request the actor gather the resources into its inventory
func order_resources():
	for key in scaled_items:
		var cost = scaled_items[key]
	#make_hauls(base, count, location, shelf, final, job)
		actor.find_and_store(key, "input", cost)
	
#Check to see if the Actor has the correct items in its inventory
func resources_ready():
	var result = true
	for key in scaled_items:
		var cost = scaled_items[key]
		if !actor.shelves.input.has(key, cost):
			result = false
	return result
	
#Check the actor's Map to see if resources exist for the upgrade
func resources_available():
	var result = true
	for key in scaled_items:
		var cost = scaled_items[key]
		var found = actor.map.find_item_amount_for(key, cost, actor)
		if found != null:
			if found.count < cost:
				result = false
		else:
			result = false
	return result
	
#Find the best possible furniture for learning this lesson
func find_site():
	var teacher = actor.map.find_teacher(base.taught_by, actor)
	var furn
	if teacher != null:
		site = furn
		furn = teacher.object
	return furn
	
func start_lesson():
	for key in scaled_mana:
		var cost = scaled_mana[key]
		rules.player.intangibles[key] -= cost
	
#***SHITTY VERSION ENDS HERE

func save():
	var save_dict = {
		"base": base.key,
		"time_left": time_left
	}
	return save_dict
	
func load_save(savedata):
	time_left = savedata.time_left

func _init(newbase, newrules):
	rules = newrules
	base = newbase
	#neededitems = newbase.cost.duplicate()
	time_left = base.time

func learn(delta):
	time_left -= delta
	
	if time_left < 0:
		actor.finish_task()
		#teach()
		return true
	
func ready():
	return actor.working
	
func teach():
	actor.learn_lesson(self)
	actor.remove_resources(scaled_items, "input")
	site.in_use = false
	map.active_lessons.erase(id)
	return true
