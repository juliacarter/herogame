extends Object
class_name FactionBase

var unitlists = {}

var waves = {}
var wave_weights = {}

var lists = {}

#Threats the faction can roll when looking for a basic mission
var threats = []

#Roll these when looking for an advanced mission, such as a base assault
var superthreats = []

var name

var color

var alignment = "hero"

var type = "agency"

func _init(data):
	if data.has("name"):
		name = data.name
	if data.has("alignment"):
		alignment = data.alignment
	if data.has("threats"):
		threats = data.threats.duplicate()
	if data.has("unitlists"):
		lists = data.unitlists.duplicate(true)
