extends Object
class_name Squad

var id

var leader

var data
var rules

var units = {}

var priority = 0

var objective

var rallied = false

var movepoint

var entry: Vector2

var transporting_to

var orders = []

var criteria = []

func save():
	var saved_units = []
	for key in units:
		saved_units.append(key)
	var save_dict = {
		"id": id,
		"units": saved_units,
	}
	return save_dict

func get_objective_task():
	var task = DestroyTask.new(objective)
	return task

func update_priority(newpri):
	priority = newpri

func remove_syntax(slot, syn):
	if slot == "criteria":
		var index = criteria.find(syn)
		criteria.pop_at(index)
	if slot == "order":
		var index = orders.find(syn)
		orders.pop_at(index)
	
func add_syntax(slot, syn):
	if slot == "criteria":
		criteria.append(syn)
	if slot == "order":
		orders.append(syn)
		
func think(delta):
	if objective == null || objective.dead:
		find_objective(rules.home)
		
func find_objective(map):
	objective = map.find_objective(entry)

func rally():
	rallied = true
	move_order(leader.current_square)

func move_order(target):
	movepoint = target
	for key in units:
		var unit = units[key]
		unit.move_order(target)
		unit.rallied = false

func add_unit(unit):
	unit.squad = self
	units.merge({
		unit.id: unit
	})
	for order in orders:
		unit.add_order(order)
	
func remove_unit(unit):
	units.erase(unit.id)
	for order in orders:
		unit.remove_order(order)
	#if units.size() == 0:
	#	rules.remove_squad(self)

func generate_squad():
	for i in 5:
		var unit = Unit.new()
		unit.load_data(rules, data, data.units.agent)
		unit.id = rules.assign_id(unit)
		unit.squad = self
		units.merge({
			unit.id: unit
		})
		if i == 1:
			leader = unit
	
func remove_orders():
	for key in units:
		var unit = units[key]
		for order in orders:
			unit.remove_order(order)
			
func apply_orders():
	for key in units:
		var unit = units[key]
		for order in orders:
			unit.add_order(order)
			
func save_orders():
	for key in units:
		var unit = units[key]
		for order in orders:
			unit.remove_order(order)
			unit.add_order(order)
			
func transport_order(map, wants_placement = true):
	var transport = Transport.new(rules)
	transport.needs_placement = wants_placement
	transport.id = rules.assign_id(transport)
	rules.transports.merge({
		transport.id: transport
	})
	transporting_to = map
	transport.queue_transit(units, transporting_to)
	return transport

func check_eligibility(unit):
	if criteria == []:
		return 1
	var result = true
	for crit in criteria:
		if !crit.fits(unit):
			result = false
			break
	#0 = Unit is eligible, not in squad
	#1 = Unit is eligible, but already in squad
	#2 = Unit not eligible, not in squad
	#3 = Unit not eligible, in squad (needs removal)
	if result:
		if !units.has(unit.id):
			return 0
		else:
			return 1
	else:
		if !units.has(unit.id):
			return 2
		else:
			return 3
