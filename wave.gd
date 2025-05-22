extends Encounter
class_name Wave

var heatcost = 10
var intcost = 0

var weight = 2

var entry

#var unitlist = []

var sneaky = false
var aggressive = true


func _init(gamedata, wavedata):
	if wavedata.has("lists"):
		for role in wavedata.lists:
			var lists = wavedata.lists[role]
			unit_lists.merge({
				role: []
			})
			for list in lists:
				unit_lists[role].append(gamedata.lists.unit[list])
				
	type = "wave"
	if wavedata.has("sneaky"):
		sneaky = wavedata.sneaky

func think(delta):
	if objective == null || objective.dead:
		find_objective(rules.home)
	if !wave_active():
		complete_encounter(true)
		#fire_rewards()
		rules.complete_wave(self)
		
func wave_active():
	var result = false
	for key in units:
		var unit = units[key]
		if !unit.dead:
			result = true
	return result
		
func find_objective(map):
	var next = map.find_objective(entry)
	if next != null:
		objective = next
	elif rules.player.master != null:
		objective = rules.player.master
	else:
		objective = null
	
