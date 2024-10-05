extends Object
class_name WorkSlot

var title
var count
var max
var role = ""

var reserving = true

var escorted = false

var actors = []

var modifiers = {}

func _init(data):
	title = data.title
	reserving = data.reserving
	count = data.count
	if data.has("escorted"):
		escorted = data.escorted
	modifiers = data.modifiers.duplicate()
	max = data.max
	role = data.role
