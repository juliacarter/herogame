extends Object
#an object that gives Aggro to relevant units
class_name AggroDelivery

#made of AggroPackages
#for each unit receiving aggro, apply the AggroPackage and add all units in their "aggro share range" to aggroshare dictionary
#units in aggroshare that arent a primary aggro recipient receive 10% of aggro


#the unit the Aggro is towards
var source

var package

func _init():
	package = AggroPackage.new()

func deliver_to(units):
	var sharing = {}
	for key in units:
		var unit = units[key]
		for sharekey in unit.aggro_share:
			var shared = unit.aggro_share[sharekey]
			if !units.has(sharekey):
				sharing.merge({
					sharekey: shared
				})
		unit.apply_aggro_package(package)
	for key in sharing:
		var unit = sharing[key]
		unit.apply_aggro_package(package.sharepackage)
