extends UnitPrerequisite
class_name UnitUpgradePrerequisite

#upgrades to check for
var upgrades = []

#how many of these upgrades are needed to fulfil the prereq
var count = 1

#allow multiple copies of an upgrade to count towards prereq count
var allow_repeats = false

func _init(prereqdata):
	if prereqdata.has("count"):
		count = prereqdata.count
	if prereqdata.has("upgrades"):
		upgrades = prereqdata.upgrades.duplicate()

func check_against(unit):
	var found = false
	var amount = 0
	var done = false
	while !done:
		done = true
		for key in upgrades:
			for base in unit.upgrades:
				if base.title == key:
					done = false
					amount += 1
		if amount >= count:
			done = true
