extends Object
class_name FreeAgent

#The amount of time the Agent stays available
var time

#The Unit associated with the Free Agent
var unit

func _init(newunit, newtime):
	time = newtime
	unit = newunit
