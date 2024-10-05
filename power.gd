extends Object
class_name Power

var powername
var category

var on_prime = ""
var on_cast = ""

var prime_args = []
var cast_args = []

var tool_data = {}

var dragselect = false
var targeting = "NOTHING"

var count = -1

var icon = "sampleicon"

#Name the panel to be used by the power, if any
var panel = ""

func altclick():
	pass

func make_tool():
	tool_data = {
		"name": powername,
		"action": on_prime,
		"args": prime_args.duplicate(),
		"icon": icon,
		"category": category,
		"power": self
	}
	pass
	
func _init(data):
	if data.has("panel"):
		panel = data.panel
	if data.has("name"):
		powername = data.name
	if data.has("category"):
		category = data.category
	if data.has("icon"):
		icon = data.icon
	if data.has("on_prime"):
		on_prime = data.on_prime
	if data.has("on_cast"):
		on_cast = data.on_cast
	if data.has("cast_args"):
		cast_args = data.cast_args.duplicate()
	if data.has("prime_args"):
		prime_args = data.prime_args.duplicate()
	if data.has("dragselect"):
		dragselect = data.dragselect
	if data.has("targeting"):
		targeting = data.targeting
