extends Object
#Generic class for quest objectives
class_name Objective

var rules

var step
var completed = false

#if true, objective will not complete automatically and the player must hit a button to "fire" it
#Use for objectives that consume things
var needs_fire = false

var completion_effect = ""
var completion_args = []

var quest

func can_fire():
	return false

func fire():
	pass

func _init(args, newquest = null):
	quest = newquest
	step = args.step
	rules = args.rules

func get_log_text():
	return "placeholder objective"
	
func start_objective():
	pass

#Called every frame to see if the objective is complete
#Different implementation for different objective subclasses
func check_status():
	if !completed:
		if status_function():
			return complete()
		else:
			return false
	else:
		return true
	
func complete():
	completed = true
	return true
	
func status_function():
	pass
	
func objective_started():
	pass
