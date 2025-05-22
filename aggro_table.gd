extends Object
class_name AggroTable

signal new_target(target)

var table = PriorityQueue.new()

#the unit this table belongs to
var unit

func apply_aggro(package):
	var target = package.unit
	var amount = package.value
	var current = table.take(target)
	var total = 0
	
	var modified_aggro = amount
	var aggro_bonus = 0
	if unit != null:
		for mod in package.percent_target_mods:
			var percent = unit.mods.ret(mod)
			if percent > 0:
				var bonus = percent * amount
				aggro_bonus += bonus
			elif percent < 0:
				var bonus = percent * modified_aggro
				modified_aggro += bonus
	amount = modified_aggro + aggro_bonus
	if current != null:
		total = amount + current
	else:
		total = amount
	if total > 0:
		target.aggro_tables.merge({
			self: false
		})
		table.insert(target, total)
	else:
		remove_unit(target)
	get_best()

#get the unit at the top of the aggro table, send it out as a signal
func get_best():
	var best = table.peek()
	new_target.emit(best)
	return best

func clear_table():
	for unit in table.items:
		remove_unit(unit.item, true)

func remove_unit(target, clearing = false):
	var current = table.take(target)
	target.aggro_tables.erase(self)
	if !clearing:
		get_best()
