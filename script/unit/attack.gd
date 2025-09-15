@tool
extends Action
#Action that deals a randomly rolled amount of damage to the unit's target
class_name Attack



var aggro_percent_bonus_base = 0
#the modifier attached to the CASTER that modifies aggro by a %
var aggro_percent_self_mods = ["genericaggropct"]
#modifier attached to TARGET that modifies aggro by %
var aggro_percent_target_mods = []


var id
var variance
var mindamage
var accuracy

var basecrit = 10

var aimtime
var readytime

var firetime
var attackcount
var currentcount
var attacking

var rangepenalty

var melee

var experience = 10

var damage = {}

var damage_per_rank = {"kinetic": {"min": 1, "variance": 1}}

var accuracy_per_rank = 5

#Appllied to Every Roll
var damage_rank_bonuses = {}
var accuracy_rank_bonus = 0

var shots = 1
#the time between each individual shot. if total time is less than cast time, attack will clip
var time_per_shot = 0

#attacks already shot
var shots_in_sequence = 0

var slot = ""

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

var bonus_accuracy = 0

var last_shot_range

func cast(delta, target, pos = null):
	var finished = shots_in_sequence >= shots
	if cooldown <= 0 && !finished:
		fire_at(target, pos)
		shots_in_sequence += 1
		if shots_in_sequence == shots:
			shots_in_sequence = 0
		return true
	return false

#func cool_down(delta):
#	super(delta)
	#time += delta

func fire_at(target, pos = null):
	super(target, pos)
	fire_weapon(target, pos)
	#time = cooldown
	#cooldown = time_per_shot

func damage_bonuses():
	var percents = get_damage_mods()
	for percent in percents:
		percent_to_all(percent)

func get_damage_mods():
	var percents = []
	if unit != null:
		for mod in dammods:
			var percent = unit.mods.ret(mod)
			percents.append(percent)
			#percent_to_all(percent)
	return percents
	
func get_acc_mods():
	pass
	
func get_accuracy():
	var acc = accuracy
	if unit != null:
		acc += unit.baseaccuracy
		for mod in accmods:
			accuracy += unit.mods.ret(mod)
	acc += bonus_accuracy
	bonus_accuracy = 0
	return acc
	
func success_visuals(pos):
	if unit != null:
		for anim in visuals:
			if anim.on_success:
				unit.map.visual_effect(anim.visual, unit.position, pos)
				
func failure_visuals(pos):
	if unit != null:
		for anim in visuals:
			if anim.on_fail:
				unit.map.visual_effect(anim.visual, unit.global_position, pos)

func fire_weapon(target, location = null):
	if target != null:
		
		var aggroval = 0
		for impact in impacts:
			aggroval += impact.magnitude
		var aggrobonus = aggro_percent_bonus_base
		for mod in aggro_percent_self_mods:
			var bonus = unit.mods.ret(mod)
			if bonus != 0:
				pass
			aggrobonus += bonus
		if melee:
			aggrobonus += 10
		var bonus_aggro = aggroval * (aggrobonus/100)
		#for mod in aggro_percent_self_mods:
		#	var mod_percent = unit.mods.ret(mod)
		#	if mod_percent != 0:
		#		var bonus = mod_percent * aggroval
		#		bonus_aggro += bonus
		aggroval += bonus_aggro
		var aggro = AggroPackage.new(unit, aggroval)
		aggro.deliver_to({
			target.id: target
		})
		
		last_shot_range = unit.global_position.distance_to(target.global_position)
		
		last_fire_position = location
		#gain_experience("combat", weapon.experience)
		target.trigger("attack_tried_against", self)
		var chance = get_accuracy()
		var critchance = basecrit
		chance -= target.total_evasion()
		var extra = chance - 100
		var bonus = int(extra) % 10
		extra -= bonus
		critchance += extra/10
		if chance < 10:
			chance = 10
		#elif accuracy > 90:
			#accuracy = 90
		pass
		var hit = randi() % 100
		if hit < chance:
			var crits = 0
			var critroll = critchance
			while critroll >= 100:
				critroll -= 100
				crits += 1
			var critrand = randi() % 100
			if critrand > critroll:
				crits = 1
			for impact in impacts:
				impact.fire(target, crits)
			success_visuals(target.position)
			
			rules.trigger("damage_rolled", target, self)
			rules.trigger("attack_hit", target, self)
		else:
			var xdir = randi() % 2
			var ydir = randi() % 2
			if xdir == 0:
				xdir -= 1
			if ydir == 0:
				ydir -= 1
			var missx = 32 * ydir + ((randi() % 32) - 16)
			var missy = 32 * xdir + ((randi() % 32) - 16)
			var misspos = target.global_position + Vector2(missx, missy)
			failure_visuals(misspos)
			if unit != null:
				unit.make_popup("Miss!")
			rules.trigger("attack_miss", target, self)
						#if target.defend(damage):

func damage_roll_sum():
	var result = 0
	for key in damagerolls:
		for stat in damagerolls[key]:
			result += damagerolls[key][stat]
	return result



func make_power():
	var power = ActionPower.new({
		"name": key,
		"on_cast": "fire_attack_at_target",
		"cast_args": [],
		"category": "unit",
		"action": self
	}, rules)
	power.make_tool()
	return power

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
	if unit != null:
		if unit.triggers.has(trigger_name):
			for triggerdata in unit.triggers[trigger_name]:
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
					triggered_for = unit
				var args = triggerdata.get_args(triggered_for, triggered_by)
				triggerdata.fire(triggered_by)
				#rules.callv(action, args)

func add_trigger(newtime, triggerdata):
	var newtrigger = Trigger.new(data, triggerdata, unit)
	newtrigger.time = newtime
	#trigger.rules = rules
	#trigger.parent = self
	triggers.merge({
		newtime: []
	})
	triggers[newtime].append(newtrigger)
	return newtrigger
	
func remove_trigger(oldtrigger):
	if triggers.has(oldtrigger.time):
		triggers[oldtrigger.time].pop_at(triggers[oldtrigger.time].find(oldtrigger))
		if triggers[oldtrigger.time] == []:
			triggers.erase(oldtrigger.time)

func _init(gamedata, attackdata, parent = null, count = 1):
	
	data = gamedata
	rules = data.rules
	cast_time = 0
	super(data, attackdata, parent)
	#data = gamedata
	rank = count
	#time = cast_time
	autocast = true
	if attackdata.has("basecrit"):
		basecrit = attackdata.basecrit
	if attackdata.has("aggro_percent_bonus_base"):
		aggro_percent_bonus_base = attackdata.aggro_percent_bonus_base
	if attackdata.has("aggro_percent_self_mods"):
		aggro_percent_self_mods = attackdata.aggro_percent_self_mods.duplicate
	if attackdata.has("aggro_percent_target_mods"):
		aggro_percent_target_mods = attackdata.aggro_percent_target_mods.duplicate()
	if attackdata.has("shots"):
		shots = attackdata.shots
	if attackdata.has("time_per_shot"):
		time_per_shot = attackdata.time_per_shot
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
	if attackdata.has("slot"):
		slot = attackdata.slot
	#mindamage = data.mindamage
	accuracy = attackdata.accuracy
	#aimtime = attackdata.aimtime
	#readytime = attackdata.readytime
	#time = cast_time
	#firetime = attackdata.firetime
	#attackcount = attackdata.attackcount
	#currentcount = attackcount
	#rangepenalty = attackdata.rangepenalty
	
	calc_ranks()
	
	

func generate_tooltip_data():
	var impact_text = ""
	for impact in impacts:
		var newtext = impact.get_text() + "\n"
		impact_text = impact_text + newtext
	var tipdata = {
		"text": impact_text,
		"type": "TextTip",
	}
	var totaldata = {
		"text": "",
		"title": "Attack",
		"tips": [tipdata],
	}
	var finaldata = TooltipData.new(totaldata)
	return finaldata

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
	cooldown = 0
	currentcount = attackcount
	attacking = false

func attack(delta):
	if time == 0:
		time = time + delta
		return 2
	else:
		time = time + delta
	if time >= firetime:
		currentcount -= 1
		if currentcount <= 0:
			attacking = false
			return 0
		else:
			time = 0.0
			return 1
	else:
		return 3

#func make_tooltip():
	#var tipdata = super()
	

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
