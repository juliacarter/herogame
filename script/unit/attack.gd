@tool
extends Action
#Action that deals a randomly rolled amount of damage to the unit's target
class_name Attack

var data

var id

var range = 0.1
var variance
var mindamage
var accuracy


var aimtime
var readytime

var firetime
var attackcount
var currentcount
var attacking

var rangepenalty

var melee

var attention_cost = 1

var experience = 10

var damage = {}

var damage_per_rank = {"kinetic": {"min": 1, "variance": 1}}

var accuracy_per_rank = 5

#Appllied to Every Roll
var damage_rank_bonuses = {}
var accuracy_rank_bonus = 0

var time = 0.0
var attackdown = 0.0

var slot = ""

var key = ""

var rank = 0

#Modifiers added to rank
var rankmods = []
#Modifiers to be added as accuracy bonuses
var accmods = []
#Modifiers to be added as damage bonuses
var dammods = []

var types = {"generic": null}

var damagerolls = {
	
}

var damagebonuses = {
	
}

var triggers = {
	
}

var bonus_ap = 0

var parent
var rules

var last_shot_range

func cooldown(delta):
	if time > 0:
		time -= delta
	if time < 0:
		time = 0

func fire_at(target):
	parent.fire_weapon(self, target)
	time = readytime

func damage_roll_sum():
	var result = 0
	for key in damagerolls:
		for stat in damagerolls[key]:
			result += damagerolls[key][stat]
	return result



func roll_damage(type):
	damagerolls = {}
	damagebonuses = {}
	bonus_ap = 0
	damagerolls.erase(type)
	calc_ranks()
	if damage.has(type):
		for atk in damage[type]:
			var dam = atk.min
			var damvar = atk.variance
			if damage_rank_bonuses.has(type):
				dam += damage_rank_bonuses[type].min
				damvar += damage_rank_bonuses[type].variance
			if damvar != 0:
				var variance = randi() % damvar
				dam += variance
			if damagerolls.has(type):
				if damagerolls[type].has(atk.stat):
					damagerolls[type][atk.stat] += dam
				else:
					damagerolls[type].merge({
						atk.stat: dam
					})
			else:
				damagerolls.merge({
					type: {atk.stat: dam}
				})
				
func percent_to_all(percent):
	for type in damagerolls:
		for stat in damagerolls[type]:
			percent_bonus(type, stat, percent)
				
func percent_bonus(type, stat, percent):
	var ratio = percent / 100
	var amount = damagerolls[type][stat] * ratio
	add_bonus(type, stat, amount)
		
func add_bonus(type, stat, amount):
	if damagebonuses.has(type):
		if damagebonuses[type].has(stat):
			damagebonuses[type][stat] += amount
		else:
			damagebonuses[type].merge({damagebonuses[type][stat]: amount})
	else:
		damagebonuses.merge({
			type: {stat: amount}
		})
		
func total_damage(type):
	var total = {}
	if damagerolls.has(type):
		for stat in damagerolls[type]:
			if total.has(stat):
				total[stat] += damagerolls[type][stat]
			else:
				total.merge({
					stat: damagerolls[type][stat]
				})
	if damagebonuses.has(type):
		for stat in damagebonuses[type]:
			if total.has(stat):
				total[stat] += damagebonuses[type][stat]
			else:
				total.merge({
					stat: damagebonuses[type][stat]
				})
	return total
	
func get_all_damages():
	var damaging = {}
	for key in damagerolls:
		damaging.merge({
			key: damagerolls[key]
		})
	for key in damagebonuses:
		damaging.merge({
			key: damagebonuses[key]
		})
	var result = {}
	for key in damaging:
		result.merge({
			key: total_damage(key)
		})
	return result
	
	
func trigger(trigger_name, triggered_by):
	if parent.triggers.has(trigger_name):
		for triggerdata in parent.triggers[trigger_name]:
			if triggerdata.check_conditions(self, triggered_by):
				var action = triggerdata.action
				var args = triggerdata.get_args(self, triggered_by)
				rules.callv(action, args)
	if triggers.has(trigger_name):
		for triggerdata in triggers[trigger_name]:
			if triggerdata.check_conditions(self, triggered_by):
				var action = triggerdata.action
				var triggered_for = self
				if triggerdata.by_parent:
					triggered_for = parent
				var args = triggerdata.get_args(triggered_for, triggered_by)
				rules.callv(action, args)

func add_trigger(time, triggerdata):
	var newtrigger = Trigger.new(data, triggerdata)
	newtrigger.time = time
	#trigger.rules = rules
	#trigger.parent = self
	triggers.merge({
		time: []
	})
	triggers[time].append(newtrigger)
	return newtrigger
	
func remove_trigger(oldtrigger):
	if triggers.has(oldtrigger.time):
		triggers[oldtrigger.time].pop_at(triggers[oldtrigger.time].find(oldtrigger))
		if triggers[oldtrigger.time] == []:
			triggers.erase(oldtrigger.time)

func _init(gamedata, attackdata, count = 1):
	super(gamedata, attackdata)
	data = gamedata
	rank = count
	if attackdata.has("types"):
		for type in attackdata.types:
			types.merge({
				type: true
			})
	if attackdata.has("triggers"):
		for time in attackdata.triggers:
			for triggerdata in attackdata.triggers[time]:
				add_trigger(time, triggerdata)
	
	if attackdata.has("range"):
		range = attackdata.range * 64
	else:
		melee = true
		range = 64
	if attackdata.has("accmods"):
		accmods = attackdata.accmods.duplicate()
	if attackdata.has("dammods"):
		dammods = attackdata.dammods.duplicate()
	damage = attackdata.damage
	if attackdata.has("slot"):
		slot = attackdata.slot
	#mindamage = data.mindamage
	accuracy = attackdata.accuracy
	aimtime = attackdata.aimtime
	readytime = attackdata.readytime
	time = readytime
	firetime = attackdata.firetime
	attackcount = attackdata.attackcount
	currentcount = attackcount
	rangepenalty = attackdata.rangepenalty
	calc_ranks()



func add_count(count):
	rank += count
	calc_ranks()
	
func remove_count(count):
	rank -= count
	calc_ranks()
	
func calc_ranks():
	damage_rank_bonuses = {}
	for type in damage_per_rank:
		var dammin = damage_per_rank[type].min * rank
		var damvar = damage_per_rank[type].variance * rank
		damage_rank_bonuses.merge({
			type: {"min": dammin, "variance": damvar}
		})
		var acc = accuracy_per_rank * rank
		accuracy_rank_bonus = acc

func reset():
	time =  0
	attackdown = 0
	currentcount = attackcount
	attacking = false

func attack(delta):
	if attackdown == 0:
		attackdown = attackdown + delta
		return 2
	else:
		attackdown = attackdown + delta
	if attackdown >= firetime:
		currentcount -= 1
		if currentcount <= 0:
			attacking = false
			return 0
		else:
			attackdown = 0.0
			return 1
	else:
		return 3

func try_attack(delta):
	if attacking:
		return 0
	time = time + delta
	if time > aimtime + readytime:
		attacking = true
		return 0
	if time > readytime:
		return 1
	else:
		return 2
