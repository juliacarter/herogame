extends Object
class_name Player

var rules

var cash = 123456789

var threat = 0


var infamy = 0

var notoriety = 0
var notoriety_to_next = 100

var infamy_upgrades = {
	"armysize": 0,
	"masterexperience": 0,
	"assetslots": 0,
}

#the number of Notoriety Perks the player still has to choose
var notoriety_picks = 0

var intangibles = {
	"cash": 1000,
	"authority": 0,
	"influence": 0,
	"intel": 0,
}

var limits = {
	"innercircle": 2,
	"army": 10,
}

#Origins that can potentially appear in the player's Free Agent pool
var possible_free_agents = ["goon"]

#Origins that can be hired as Prospects
var possible_prospects = ["agent"]

var doomsday

var master

var lifepods = {}

var science: Science

var innercircle = {}

func _init(gamerules):
	rules = gamerules

func earn_intangible(resource, amount):
	if intangibles.has(resource):
		intangibles[resource] += amount
	else:
		intangibles.merge({
			resource: amount
		})

func earn_notoriety(amount):
	notoriety += amount
	if notoriety >= notoriety_to_next:
		infamy_up()
		
func infamy_up():
	var extra = notoriety_to_next - notoriety
	if extra < 0:
		extra = 0
	infamy += 1
	notoriety = 0
	earn_notoriety(extra)
	

func inner_circle_add(unit):
	innercircle.merge({
		unit.id: unit
	})

func inner_circle_remove(unit):
	innercircle.erase(unit.id)

func save():
	var save_dict = {
		"science": science.save(),
		"cash": cash,
		"master": master.id,
	}
	return save_dict

func add_to_circle(unit):
	innercircle.merge({
		unit.id: unit
	})
