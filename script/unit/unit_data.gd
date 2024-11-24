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

var needs_name = true

var firstname = ""
var nickname = ""
var lastname = ""

func _init(data):
	allegiance = data.allegiance
	aggressive = data.aggressive
	if data.has("lessons"):
		lessons = data.lessons.duplicate()
	if data.has("firstname"):
		needs_name = false
		firstname = data.firstname
	if data.has("nickname"):
		needs_name = false
		nickname = data.nickname
	if data.has("lastname"):
		needs_name = false
		lastname = data.lastname
	if data.has("stats"):
		stats = data.stats.duplicate()
	if data.has("class"):
		unitclass = data.class
	sprite = data.sprite
	roles = data.roles
	if data.has("master"):
		master = data.master
