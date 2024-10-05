#Used to hold values during Wavebuy
extends Object
class_name Requisition

#Item, upgrade, or plan
var obj

var cost = 5

func _init(new, price):
	obj = new
	cost = price
