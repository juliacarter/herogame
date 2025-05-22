extends Object
class_name Science

var rules
var data

var current_tech

var queue = {}

var completed = {}
var researchable = {}
var unresearched = {}

func save():
	var saved_complete = []
	for key in completed:
		saved_complete.append(key)
	var save_dict = {
		"completed": saved_complete
	}
	if current_tech != null:
		save_dict.merge({
			"current_tech": current_tech.id
		})

func _init(newrules, newdata):
	rules = newrules
	data = newdata

func load_techs():
	for key in data.techs:
		var techdata = data.techs[key]
		var tech = Tech.new(techdata)
		tech.id = rules.assign_id(tech)
		if techdata.has("starting"):
			research_tech(tech)
		else:
			unresearched.merge({
				tech.id: tech
			})
		
func check_researchable():
	researchable = {}
	for key in unresearched:
		if !completed.has(key):
			var tech = unresearched[key]
			researchable.merge({tech.id: tech})

func research_tech(tech):
	if current_tech == tech:
		current_tech = null
	unresearched.erase(tech.id)
	researchable.erase(tech.id)
	completed.merge({
		tech.id: tech
	})
	for key in tech.cost:
		queue[key].pop_at(queue[key].find(tech))
	rules.unlock_stuff(tech.unlocks)
	
func start_research(tech):
	current_tech = tech
	for key in tech.cost:
		queue.merge({
			key: []
		})
		queue[key].append(tech)
	queue_tasks(tech)

func queue_tasks(tech):
	for key in tech.cost:
		var has = 0
		if tech.progress.has(key):
			has = tech.progress[key]
		var needs = tech.cost[key] - has
		var jobinstances = rules.current_map.jobs[key]
		var workorder = WorkOrder.new()
		workorder.count = needs
		workorder.jobs = jobinstances
		
		rules.workorders.append(workorder)

func progress_research(type, amount):
	current_tech.progress.merge({
		type: 0
	})
	current_tech.progress[type] += amount
	var done = true
	for key in current_tech.cost:
		if !current_tech.progress.has(key):
			done = false
		else:
			if current_tech.progress[key] < current_tech.cost[key]:
				done = false
	if done:
		research_tech(current_tech)
