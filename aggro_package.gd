extends Object
class_name AggroPackage

var value = 10

#the unit the package is directed to
var unit

var sharepackage


var percent_target_mods = []

func _init(newunit, newvalue = 10, shared = false):
	unit = newunit
	value = newvalue
	if !shared:
		sharepackage = AggroPackage.new(unit, value/10, true)

func deliver_to(units):
	var sharing = {}
	for key in units:
		var unit = units[key]
		for sharekey in unit.seen_by:
			var shared = unit.seen_by[sharekey]
			if unit.friendly_to(shared):
				if !units.has(sharekey):
					sharing.merge({
						sharekey: shared
					})
		unit.apply_aggro_package(self)
	for key in sharing:
		var unit = sharing[key]
		unit.apply_aggro_package(sharepackage)
