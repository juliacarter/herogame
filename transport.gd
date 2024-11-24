extends Object
class_name Transport

var rules

var furniture

var id

var timer = 0.0
var distance = 2.0

var moving = false

var units = {}
var desired_units = {}

var stacks = {}
var desired_bases = {}

var targetmap

var needs_placement = true



func _init(newrules):
	rules = newrules

func set_target(newmap):
	targetmap = newmap
	timer = distance
	if targetmap != null:
		if targetmap.tab != null:
			targetmap.tab.add_transport(self)

func queue_transit(newunits, newmap):
	targetmap = newmap
	if targetmap != null:
		if targetmap.tab != null:
			targetmap.tab.add_transport(self)
	for key in newunits:
		var unit = newunits[key]
		unit.queue_transit(newmap, self)
		desired_units.merge({unit.id: unit})

func store_unit(unit):
	units.merge({
		unit.id: unit
	})
	unit.transport()
	if check_units():
		send_transport()
	
func check_units():
	var valid = true
	for key in desired_units:
		if !units.has(key):
			valid = false
	return valid
	
func send_transport():
	timer = distance
	moving = true
	
	
func travel(delta):
	timer -= delta
	if timer <= 0:
		land_transport()
		return true
	else:
		return false
	
func land_transport():
	rules.transports.erase(id)
	for key in units:
		var unit = units[key]
		if unit.map != null:
			unit.map.remove_unit(unit)
	if targetmap != null:
		if targetmap.tab != null:
			targetmap.tab.remove_transport(self)
	if targetmap is Region:
		targetmap.land_units(units)
	else:
		if !needs_placement:
			var entry = targetmap.get_entry()
			for key in units:
				var unit = units[key]
				unit.on_map = true
				unit.teleport_to_map_entry(targetmap)
			units = {}
			moving = false
		else:
			if targetmap is Grid:
				for key in units:
					var unit = units[key]
					
					unit.on_map = true
				rules.start_placement(units, targetmap, null)
				if targetmap.encounter != null:
					targetmap.encounter.started = true
			
			units = {}
			moving = false
	
