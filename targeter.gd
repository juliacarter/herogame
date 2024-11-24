extends Object
#generic class that gets targets from the game world and returns them
class_name Targeter

var rules

#visual used to aid in targeting, if anything
var visual

#unit targeter is checking for
var origin

func _init(gamerules, targetdata, caster = null):
	rules = gamerules
	origin = caster
	

	
#get targets based on current mouse position
func manual_target():
	pass

#get a target based on automated criteria
func auto_target():
	pass

#check whether a retrieved target meets targeter criteria
func is_valid(target):
	pass

#check whether the mouse cursor is over a valid position
func has_valid():
	pass
