extends Object
class_name UnitData

var allegiance
var aggressive
var sprite

var unitclass# = ""


var equipment = {}

var abilities = {}

var stats = {}

var lessons = []

var roles

var master = false

var datakey

func _init (data):
	allegiance = data.allegiance
	aggressive = data.aggressive
	if data.has("lessons"):
		lessons = data.lessons.duplicate()
	if data.has("stats"):
		stats = data.stats.duplicate()
	if data.has("class"):
		unitclass = data.class
	sprite = data.sprite
	roles = data.roles
	if data.has("master"):
		master = data.master
