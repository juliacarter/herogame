extends Object
class_name ActionVisual

var visual

var on_fail = true
var on_success = true

func _init(visdata):
	if visdata.has("visual"):
		visual = visdata.visual
	if visdata.has("on_success"):
		on_success = visdata.on_success
	if visdata.has("on_fail"):
		on_fail = visdata.on_fail
