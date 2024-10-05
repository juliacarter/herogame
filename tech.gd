extends Object
class_name Tech

var id

var unlocks = {
	"techs": [],
	"furn": [],
	"upgrades": [],
}
var cost = {}
var progress = {}

var techname = "science!"

func _init(data):
	if data.has("unlocks"):
		if data.unlocks.has("tech"):
			for tech in data.unlocks.tech:
				unlocks.techs.append(tech)
		if data.unlocks.has("furn"):
			for furn in data.unlocks.furn:
				unlocks.furn.append(furn)
		if data.unlocks.has("upgrades"):
			for lesson in data.unlocks.upgrades:
				unlocks.upgrades.append(lesson)
	if data.has("cost"):
		cost = data.cost
	if data.has("name"):
		techname = data.name
